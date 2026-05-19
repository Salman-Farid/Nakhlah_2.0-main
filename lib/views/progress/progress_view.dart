import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/app_motion.dart';
import '../../common/app_snackbar.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';
import '../../controllers/gamification_controller.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  int _selectedTab = 0;
  String _badgeQuery = '';
  bool _badgesAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Get.find<GamificationController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<GamificationController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Obx(() {
          if (c.loading.value) return const LoadingState();
          return GameListView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.pagePadding(context),
              vertical: 16,
            ),
            children: [
              const _Header(),
              const SizedBox(height: 24),
              _TabSwitcher(
                selectedIndex: _selectedTab,
                onChanged: (i) => setState(() => _selectedTab = i),
              ),
              const SizedBox(height: 20),
              if (_selectedTab == 0) ..._buildTargetTab(),
              if (_selectedTab == 1) ..._buildBadgesTab(),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> _buildTargetTab() {
    final c = Get.find<GamificationController>();
    final quests = c.quests.toList();
    final total = quests.isEmpty ? c.questConfig.length : quests.length;

    return [
      _SectionHeader(
        icon: '📅',
        title: 'Daily Quests',
        subtitle: 'Reset every day',
        badge: '$total quests',
      ),
      const SizedBox(height: 16),
      if (quests.isEmpty)
        const _InlineInfoCard(
          icon: Icons.flag_outlined,
          title: 'No daily quests yet',
          subtitle:
              'Your daily quests will appear here once the API returns them.',
        )
      else
        ...quests.map((quest) {
          final config = _mapValue(c.questConfig[quest.challengeId]);
          final title = _configText(config, [
            'name',
            'title',
          ], quest.challengeId);
          final emoji = _questEmoji(quest.challengeId);
          return _QuestCard(
            emoji: emoji,
            title: title,
            reward: quest.reward,
            current: quest.current,
            required: quest.required,
            status: quest.status,
            onTap: quest.challengeId == 'shareApp'
                ? () {
                    SharePlus.instance.share(
                      ShareParams(text: 'Check out Nakhlah!'),
                    );
                  }
                : () => AppSnackbar.info(
                    quest.current >= quest.required
                        ? 'Quest completed.'
                        : 'Keep learning to complete this quest.',
                    title: title,
                  ),
          );
        }),
    ];
  }

  List<Widget> _buildBadgesTab() {
    final c = Get.find<GamificationController>();
    final stock = c.stock.value;
    final badges = _badgeCards(c)
      ..sort(
        (a, b) => _badgesAscending
            ? a.target.compareTo(b.target)
            : b.target.compareTo(a.target),
      );
    final filtered = badges
        .where((b) => b.title.toLowerCase().contains(_badgeQuery.toLowerCase()))
        .toList();

    return [
      _SearchFilterRow(
        ascending: _badgesAscending,
        onSearch: (value) => setState(() => _badgeQuery = value),
        onToggleSort: () =>
            setState(() => _badgesAscending = !_badgesAscending),
      ),
      const SizedBox(height: 24),
      _SectionHeader(
        icon: '🔒',
        title: 'Badges',
        subtitle: 'Reach the Injaz target to unlock',
        badge: '${filtered.length} total',
      ),
      const SizedBox(height: 16),
      if (filtered.isEmpty)
        const _InlineInfoCard(
          icon: Icons.workspace_premium_outlined,
          title: 'No badges found',
          subtitle: 'Try another search term.',
        )
      else
        ...filtered.map(
          (badge) => _BadgeCard(
            badge: badge,
            currentInjaz: stock.injazStock,
            onTap: () => AppSnackbar.info(
              stock.injazStock >= badge.target
                  ? 'Badge unlocked.'
                  : '${badge.target - stock.injazStock} more Injaz needed.',
              title: badge.title,
            ),
          ),
        ),
      const SizedBox(height: 20),
      Center(
        child: Text(
          'Your current Activity Injaz: ${stock.injazStock}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.muted,
          ),
        ),
      ),
      const SizedBox(height: 16),
    ];
  }

  List<_BadgeData> _badgeCards(GamificationController c) {
    if (c.badgeConfig.isNotEmpty) {
      return c.badgeConfig.entries.map((entry) {
        final map = _mapValue(entry.value);
        return _BadgeData(
          emoji: _badgeEmoji(entry.key),
          title: _configText(map, ['name', 'title'], entry.key),
          injaz: _formatNumber(
            _configInt(map, ['target', 'injaz', 'required']),
          ),
          target: _configInt(map, ['target', 'injaz', 'required']),
          color: _badgeColor(entry.key),
        );
      }).toList();
    }

    return c.achievements.map((achievement) {
      final target = achievement.unitOrder > 0 ? achievement.unitOrder : 0;
      return _BadgeData(
        emoji: _badgeEmoji(achievement.id),
        title: achievement.achievementTitle.isNotEmpty
            ? achievement.achievementTitle
            : achievement.title,
        injaz: _formatNumber(target),
        target: target,
        color: _badgeColor(achievement.id),
      );
    }).toList();
  }
}

Map<String, dynamic> _mapValue(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((k, v) => MapEntry(k.toString(), v));
  return const {};
}

String _configText(
  Map<String, dynamic> map,
  List<String> keys,
  String fallback,
) {
  for (final key in keys) {
    final value = map[key]?.toString().trim();
    if (value != null && value.isNotEmpty && value != 'null') return value;
  }
  return fallback
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll('_', ' ')
      .trim();
}

int _configInt(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed != null) return parsed;
  }
  return 0;
}

String _formatNumber(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final fromEnd = text.length - i;
    buffer.write(text[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _questEmoji(String id) {
  const icons = {
    'completeLessons': '📖',
    'earnInjaz': '⚡',
    'practiceLessons': '📝',
    'completeTasks': '✅',
    'attendExam': '🎯',
    'spendDatesForLives': '💎',
    'spendMinutes': '⏰',
    'lessonWithNoMistakes': '🏅',
    'scoreHighPoints': '🚀',
    'shareApp': '📤',
  };
  return icons[id] ?? '⭐';
}

String _badgeEmoji(String id) {
  const emojis = ['🏆', '🌟', '⚡', '💎', '🔥', '📚', '🎯', '🚀'];
  return emojis[id.hashCode.abs() % emojis.length];
}

Color _badgeColor(String id) {
  const colors = [
    Color(0xFFE8D5F0),
    Color(0xFFF5F0E8),
    Color(0xFFE8F5E9),
    Color(0xFFFFF3E0),
    Color(0xFFE3F2FD),
  ];
  return colors[id.hashCode.abs() % colors.length];
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Challenges',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(width: 8),
        const Text('🔐', style: TextStyle(fontSize: 24)),
      ],
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E0D5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Target',
              selected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Badges',
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.out,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8D5A3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.ink : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0E8),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(icon, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF4ECFF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.palm,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestCard extends StatelessWidget {
  const _QuestCard({
    required this.emoji,
    required this.title,
    required this.reward,
    required this.current,
    required this.required,
    required this.status,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final int reward;
  final int current;
  final int required;
  final String status;
  final VoidCallback onTap;

  bool get _isCompleted => current >= required || status == 'completed';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F0E8),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _isCompleted ? AppColors.muted : AppColors.ink,
                          decoration: _isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Reward: $reward',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$current/$required',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.palm,
                      ),
                    ),
                    if (_isCompleted) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.palm,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeData {
  const _BadgeData({
    required this.emoji,
    required this.title,
    required this.injaz,
    required this.target,
    required this.color,
  });

  final String emoji;
  final String title;
  final String injaz;
  final int target;
  final Color color;
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.badge,
    required this.currentInjaz,
    required this.onTap,
  });

  final _BadgeData badge;
  final int currentInjaz;
  final VoidCallback onTap;

  bool get _unlocked => currentInjaz >= badge.target;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: badge.color,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badge.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        badge.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '${badge.injaz} Injaz',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.palm,
                            ),
                          ),
                          const Text(
                            '•',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.muted,
                            ),
                          ),
                          Text(
                            _unlocked ? 'Unlocked' : 'Target',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  _unlocked ? Icons.check_circle : Icons.chevron_right,
                  color: _unlocked ? AppColors.palm : AppColors.muted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchFilterRow extends StatelessWidget {
  const _SearchFilterRow({
    required this.ascending,
    required this.onSearch,
    required this.onToggleSort,
  });

  final bool ascending;
  final ValueChanged<String> onSearch;
  final VoidCallback onToggleSort;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 360;
        final search = Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE8E0D5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: AppColors.muted),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onChanged: onSearch,
                  decoration: const InputDecoration(
                    hintText: 'Search badges',
                    hintStyle: TextStyle(fontSize: 14, color: AppColors.muted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        );
        final sort = Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggleSort,
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE8E0D5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      ascending ? 'Injaz Low → High' : 'Injaz High → Low',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
        );
        if (narrow) {
          return Column(
            children: [
              search,
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: sort),
            ],
          );
        }
        return Row(
          children: [
            Expanded(flex: 3, child: search),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: sort),
          ],
        );
      },
    );
  }
}

class _InlineInfoCard extends StatelessWidget {
  const _InlineInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E0D5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.palm),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
