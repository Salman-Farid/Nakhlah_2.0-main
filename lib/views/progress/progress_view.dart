import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_motion.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';
import '../../controllers/gamification_controller.dart';
import '../../models/models.dart';

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
              const SizedBox(height: 28),
              if (_selectedTab == 0) ...[
                _SectionHeader(
                  icon: '📅',
                  title: 'Daily Quests',
                  subtitle: 'Reset every day',
                  badge: '${c.quests.length} quests',
                ),
                const SizedBox(height: 16),
                ...c.quests.map(
                  (q) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _QuestCard(quest: q),
                  ),
                ),
              ] else ...[
                const _BadgesPlaceholder(),
              ],
            ],
          );
        }),
      ),
    );
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
  const _QuestCard({required this.quest});

  final QuestStatus quest;

  bool get _isCompleted =>
      quest.status.toLowerCase() == 'completed' ||
      (quest.required > 0 && quest.current >= quest.required);

  String get _displayTitle {
    final id = quest.challengeId.toLowerCase();
    if (id.contains('lesson') && id.contains('complete')) {
      return 'Complete Lessons Today';
    }
    if (id.contains('injaz')) return 'Earn Injaz Today';
    if (id.contains('practice')) return 'Practice Lessons';
    if (id.contains('task') && id.contains('complete')) return 'Complete Tasks';
    if (id.contains('task') && id.contains('today')) return 'Complete Tasks Today';
    if (id.contains('exam')) return 'Attend Exam';
    if (id.contains('date') && id.contains('spend')) return 'Spend Dates for Lives';
    if (id.contains('minute') && id.contains('spend')) return 'Spend Minutes';
    if (id.contains('mistake')) return 'Lesson with No Mistakes';
    if (id.contains('score') || id.contains('high')) return 'Score High Points';
    if (id.contains('share')) return 'Share the App';
    return quest.challengeId;
  }

  String get _emoji {
    final id = quest.challengeId.toLowerCase();
    if (id.contains('lesson') && id.contains('complete')) return '😊';
    if (id.contains('injaz')) return '📖';
    if (id.contains('practice')) return '⏰';
    if (id.contains('task') && id.contains('complete')) return '😊';
    if (id.contains('task') && id.contains('today')) return '😊';
    if (id.contains('exam')) return '⏰';
    if (id.contains('date') && id.contains('spend')) return '✈️';
    if (id.contains('minute') && id.contains('spend')) return '😊';
    if (id.contains('mistake')) return '📖';
    if (id.contains('score') || id.contains('high')) return '🛠️';
    if (id.contains('share')) return '⏰';
    return '🎯';
  }

  String get _progressText {
    final target = quest.required == 0 ? 1 : quest.required;
    if (_isCompleted) return '$target/$target';
    return '${quest.current}/$target';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(_emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayTitle,
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
                  'Reward: ${quest.reward}',
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
                _progressText,
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
    );
  }
}

class _BadgesPlaceholder extends StatelessWidget {
  const _BadgesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium_outlined, size: 48, color: AppColors.muted),
            SizedBox(height: 12),
            Text(
              'Badges coming soon',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
