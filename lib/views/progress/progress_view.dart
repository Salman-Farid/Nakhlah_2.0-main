import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
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
    return const [
      _SectionHeader(
        icon: '📅',
        title: 'Daily Quests',
        subtitle: 'Reset every day',
        badge: '10 quests',
      ),
      SizedBox(height: 16),
      _QuestCard(
        emoji: '😊',
        title: 'Complete Lessons Today',
        reward: 100,
        current: 0,
        required: 1,
      ),
      _QuestCard(
        emoji: '📖',
        title: 'Earn Injaz Today',
        reward: 100,
        current: 0,
        required: 500,
      ),
      _QuestCard(
        emoji: '⏰',
        title: 'Practice Lessons',
        reward: 100,
        current: 0,
        required: 2,
      ),
      _QuestCard(
        emoji: '😊',
        title: 'Complete Tasks',
        reward: 100,
        current: 0,
        required: 1,
      ),
      _QuestCard(
        emoji: '⏰',
        title: 'Attend Exam',
        reward: 500,
        current: 0,
        required: 1,
      ),
      _QuestCard(
        emoji: '✈️',
        title: 'Spend Dates for Lives',
        reward: 50,
        current: 0,
        required: 500,
      ),
      _QuestCard(
        emoji: '😊',
        title: 'Spend Minutes',
        reward: 100,
        current: 0,
        required: 5,
      ),
      _QuestCard(
        emoji: '📖',
        title: 'Lesson with No Mistakes',
        reward: 500,
        current: 1,
        required: 1,
      ),
      _QuestCard(
        emoji: '🛠️',
        title: 'Score High Points',
        reward: 500,
        current: 1,
        required: 1,
      ),
      _QuestCard(
        emoji: '⏰',
        title: 'Share the App',
        reward: 10,
        current: 0,
        required: 1,
      ),
    ];
  }

  List<Widget> _buildBadgesTab() {
    return const [
      _SearchFilterRow(),
      SizedBox(height: 24),
      _SectionHeader(
        icon: '🔒',
        title: 'Locked',
        subtitle: 'Reach the Injaz target to unlock',
        badge: '10 total',
      ),
      SizedBox(height: 16),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '🔋',
          title: 'The Sweetest',
          injaz: '1,000',
          color: Color(0xFFE8D5F0),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '⏰',
          title: 'Best Target',
          injaz: '2,000',
          color: Color(0xFFF5F0E8),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '⏰',
          title: 'Compass Smart',
          injaz: '3,000',
          color: Color(0xFFF5F0E8),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '⏰',
          title: 'Quiz King',
          injaz: '4,000',
          color: Color(0xFFF5F0E8),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '✈️',
          title: 'Diamond Winner',
          injaz: '5,000',
          color: Color(0xFFE8D5F0),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '😊',
          title: 'Shining Star',
          injaz: '6,000',
          color: Color(0xFFF5F0E8),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '⏰',
          title: 'Quick Fixer',
          injaz: '7,000',
          color: Color(0xFFF5F0E8),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '📖',
          title: 'The Fastest Man',
          injaz: '8,000',
          color: Color(0xFFF5F0E8),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '✈️',
          title: 'Smart Learning',
          injaz: '9,000',
          color: Color(0xFFE8D5F0),
        ),
      ),
      _BadgeCard(
        badge: _BadgeData(
          emoji: '😊',
          title: 'Most Active',
          injaz: '10,000',
          color: Color(0xFFF5F0E8),
        ),
      ),
      SizedBox(height: 20),
      Center(
        child: Text(
          'Your current Activity Injaz: 100',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.muted,
          ),
        ),
      ),
      SizedBox(height: 16),
    ];
  }
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
  const _TabSwitcher({
    required this.selectedIndex,
    required this.onChanged,
  });

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
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                ),
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
  });

  final String emoji;
  final String title;
  final int reward;
  final int current;
  final int required;

  bool get _isCompleted => current >= required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
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
                      decoration:
                          _isCompleted ? TextDecoration.lineThrough : null,
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
          ],
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
    required this.color,
  });

  final String emoji;
  final String title;
  final String injaz;
  final Color color;
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge});

  final _BadgeData badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
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
              child: Text(badge.emoji, style: const TextStyle(fontSize: 24)),
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
                  Row(
                    children: [
                      Text(
                        '${badge.injaz} Injaz',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.palm,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '•',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Target',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchFilterRow extends StatelessWidget {
  const _SearchFilterRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE8E0D5)),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 20, color: AppColors.muted),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search badges',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.muted,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE8E0D5)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Injaz (Low → High)',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.ink,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.muted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
