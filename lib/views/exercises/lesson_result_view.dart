import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';

class LessonResultData {
  const LessonResultData({
    this.lessonId = '',
    this.elapsedSeconds = 0,
    this.totalQuestions = 0,
    this.scoredQuestions = 0,
    this.correctAnswers = 0,
    this.injazEarned = 0,
    this.palmTreesRemaining = 5,
    this.hasWrongAnswer = false,
  });

  final String lessonId;
  final int elapsedSeconds;
  final int totalQuestions;
  final int scoredQuestions;
  final int correctAnswers;
  final int injazEarned;
  final int palmTreesRemaining;
  final bool hasWrongAnswer;

  int get accuracyPercentage {
    if (scoredQuestions == 0) return 100;
    return ((correctAnswers / scoredQuestions) * 100).round().clamp(0, 100);
  }

  String get formattedTime {
    final minutes = (elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool get isPerfect => !hasWrongAnswer && scoredQuestions > 0;
}

class LessonResultView extends StatelessWidget {
  const LessonResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments is LessonResultData
        ? Get.arguments as LessonResultData
        : const LessonResultData();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              _buildMascot(),
              const SizedBox(height: 18),
              Text(
                data.isPerfect ? 'Perfect!' : 'Lesson completed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: data.isPerfect ? AppColors.success : AppColors.accent,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 22),
              _buildInjazBanner(data),
              const SizedBox(height: 18),
              _buildStatsRow(data),
              const Spacer(),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMascot() {
    return Image.asset(
      'assets/nakhlah_web/water_drop_cartoon.png',
      height: 140,
      errorBuilder: (_, error, stackTrace) => const Icon(
        Icons.water_drop_rounded,
        size: 120,
        color: AppColors.accent,
      ),
    );
  }

  Widget _buildInjazBanner(LessonResultData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDD5),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Injaz Earned',
            style: TextStyle(
              color: Color(0xFF9A3412),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${data.injazEarned}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 4),
          const Text('⭐', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildStatsRow(LessonResultData data) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'Total Dates',
            value: '${data.palmTreesRemaining}',
            icon: Icons.park_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            label: 'Time',
            value: data.formattedTime,
            icon: Icons.timer_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            label: 'Accuracy',
            value: '${data.accuracyPercentage}%',
            icon: Icons.track_changes_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      height: AppTheme.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.until((route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          ),
        ),
        child: const Text(
          'CONTINUE',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
