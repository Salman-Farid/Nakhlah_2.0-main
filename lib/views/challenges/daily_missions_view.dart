import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/empty_state.dart';
import '../../common/loading_state.dart';
import '../../constants/app_colors.dart';
import '../../controllers/gamification_controller.dart';
import '../../models/models.dart';

class DailyMissionsView extends StatefulWidget {
  const DailyMissionsView({super.key});

  @override
  State<DailyMissionsView> createState() => _DailyMissionsViewState();
}

class _DailyMissionsViewState extends State<DailyMissionsView> {
  final GamificationController _gamification = Get.find<GamificationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _gamification.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_gamification.loading.value && _gamification.quests.isEmpty) {
        return const LoadingState(message: 'Loading daily quests...');
      }

      final quests = _gamification.quests;
      final config = _gamification.questConfig;

      if (quests.isEmpty && config.isEmpty) {
        return const EmptyState(
          icon: Icons.assignment_outlined,
          title: 'No daily quests available',
          subtitle: 'Complete lessons to unlock daily quests.',
        );
      }

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          _buildSectionHeader(context, quests.length),
          const SizedBox(height: 16),
          if (quests.isEmpty)
            _buildEmptyQuestsCard()
          else
            ...quests.map((q) => _buildMissionCard(q, config)),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  Widget _buildSectionHeader(BuildContext context, int questCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.assignment_rounded,
              color: AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Quests',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Reset every day',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$questCount',
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyQuestsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 48,
            color: AppColors.muted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'No active quests',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete a lesson to see your daily quests',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(QuestStatus quest, Map<String, dynamic> config) {
    final isCompleted = quest.status == 'completed';
    final progress = quest.required > 0
        ? (quest.current / quest.required).clamp(0.0, 1.0)
        : 0.0;

    final questLabel = _getQuestLabel(quest.challengeId, config);
    final questIcon = _getQuestIcon(quest.challengeId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? AppColors.correctGreen.withValues(alpha: 0.3)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.correctGreen.withValues(alpha: 0.1)
                  : AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              questIcon,
              color: isCompleted ? AppColors.correctGreen : AppColors.accent,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isCompleted ? AppColors.muted : AppColors.ink,
                    decoration:
                        isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.diamond_rounded,
                      size: 14,
                      color: AppColors.gold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${quest.reward} Injaz',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isCompleted)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.correctGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.correctGreen,
                size: 20,
              ),
            )
          else
            _buildProgressBar(progress, quest.current, quest.required),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, int current, int required) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 60,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$current/$required',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }

  String _getQuestLabel(String challengeId, Map<String, dynamic> config) {
    final questData = config[challengeId];
    if (questData is Map) {
      final name = questData['name'] ?? questData['title'] ?? questData['label'];
      if (name != null) return name.toString();
    }
    if (challengeId.isNotEmpty) {
      return challengeId
          .replaceAll('-', ' ')
          .replaceAll('_', ' ')
          .split(' ')
          .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
    }
    return 'Daily challenge';
  }

  IconData _getQuestIcon(String challengeId) {
    final lower = challengeId.toLowerCase();
    if (lower.contains('lesson')) return Icons.menu_book_rounded;
    if (lower.contains('streak')) return Icons.local_fire_department_rounded;
    if (lower.contains('score') || lower.contains('perfect')) {
      return Icons.star_rounded;
    }
    if (lower.contains('quiz')) return Icons.quiz_rounded;
    if (lower.contains('practice')) return Icons.fitness_center_rounded;
    if (lower.contains('review')) return Icons.replay_rounded;
    return Icons.assignment_rounded;
  }
}
