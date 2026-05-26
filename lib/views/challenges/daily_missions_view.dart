import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/empty_state.dart';
import '../../common/loading_state.dart';
import '../../controllers/gamification_controller.dart';

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
      if (_gamification.loading.value && _gamification.questConfig.isEmpty) {
        return const LoadingState(message: 'Loading daily quests...');
      }

      final config = _gamification.questConfig;

      if (config.isEmpty) {
        return const EmptyState(
          icon: Icons.assignment_outlined,
          title: 'No daily quests available',
          subtitle: 'Complete lessons to unlock daily quests.',
        );
      }

      // Build mission list from ALL global quests, matching user status
      final missions = config.entries.map((entry) {
        final questKey = entry.key;
        final questData = entry.value;
        final status = _gamification.findQuestStatus(questKey);
        return _MissionData(
          key: questKey,
          name: _getName(questData, questKey),
          iconUrl: _getIconUrl(questData),
          current: status?.current ?? 0,
          target: status?.required ?? _getRequired(questData),
          reward: status?.reward ?? _getReward(questData),
          status: status?.status ?? 'pending',
          active: status != null,
        );
      }).toList();

      // Sort: active quests first
      missions.sort((a, b) => (b.active ? 1 : 0) - (a.active ? 1 : 0));

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSectionHeader(context, missions.length),
          const SizedBox(height: 12),
          ...missions.map((m) => _buildMissionCard(m)),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  Widget _buildSectionHeader(BuildContext context, int questCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE8E0D0)),
            ),
            child: const Center(
              child: Text('📅', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Quests',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Reset every day',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EAFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$questCount quests',
              style: const TextStyle(
                color: Color(0xFF7C4DFF),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(_MissionData mission) {
    final isCompleted = mission.status == 'completed';
    final progressText = '${mission.current}/${mission.target}';
    final progressColor = isCompleted
        ? Colors.grey[400]!
        : const Color(0xFF7C4DFF);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8E0D0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Opacity(
        opacity: mission.active ? 1.0 : 0.4,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _getQuestEmoji(mission.key),
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isCompleted ? Colors.grey[400] : Colors.black,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Reward: ${mission.reward}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              progressText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: progressColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getName(dynamic questData, String fallback) {
    if (questData is Map) {
      final name = questData['name'] ?? questData['title'] ?? questData['label'];
      if (name != null) return name.toString();
    }
    if (fallback.isNotEmpty) {
      return fallback
          .replaceAll('-', ' ')
          .replaceAll('_', ' ')
          .replaceAllMapped(
            RegExp(r'([a-z])([A-Z])'),
            (m) => '${m[1]} ${m[2]}',
          )
          .split(' ')
          .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
    }
    return 'Daily challenge';
  }

  String _getIconUrl(dynamic questData) {
    if (questData is Map) {
      final icon = questData['icon'];
      if (icon is Map) return icon['url']?.toString() ?? '';
      if (icon is String) return icon;
    }
    return '';
  }

  int _getRequired(dynamic questData) {
    if (questData is Map) {
      final r = questData['required'];
      if (r is int) return r;
      if (r is String) return int.tryParse(r) ?? 0;
    }
    return 0;
  }

  int _getReward(dynamic questData) {
    if (questData is Map) {
      final r = questData['reward'];
      if (r is int) return r;
      if (r is String) return int.tryParse(r) ?? 0;
    }
    return 0;
  }

  String _getQuestEmoji(String challengeId) {
    final lower = challengeId.toLowerCase();

    if (lower.contains('complete_lesson') || lower.contains('complete-lesson') || lower.contains('completelesson')) {
      return '✅';
    }
    if (lower.contains('practice')) {
      return '🧑‍💻';
    }
    if (lower.contains('minute') || lower.contains('time') || lower.contains('spend_min')) {
      return '⏰';
    }
    if (lower.contains('injaz') || lower.contains('earn')) {
      return '⭐';
    }
    if (lower.contains('complete_task') || lower.contains('complete-task') || lower.contains('task')) {
      return '✔️';
    }
    if (lower.contains('exam') || lower.contains('attend')) {
      return '📋';
    }
    if (lower.contains('lives') || lower.contains('date') || lower.contains('heart')) {
      return '🤍';
    }
    if (lower.contains('mistake') || lower.contains('perfect') || lower.contains('no_mistake')) {
      return '🎓';
    }
    if (lower.contains('score') || lower.contains('high_point') || lower.contains('point')) {
      return '🎯';
    }
    if (lower.contains('share')) {
      return '↗️';
    }
    if (lower.contains('streak')) {
      return '🔥';
    }
    if (lower.contains('lesson')) {
      return '📖';
    }
    if (lower.contains('quiz')) {
      return '❓';
    }
    return '📋';
  }
}

class _MissionData {
  const _MissionData({
    required this.key,
    required this.name,
    required this.iconUrl,
    required this.current,
    required this.target,
    required this.reward,
    required this.status,
    required this.active,
  });

  final String key, name, iconUrl, status;
  final int current, target, reward;
  final bool active;
}
