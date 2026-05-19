import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_card.dart';
import '../../common/app_motion.dart';
import '../../common/empty_state.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../constants/app_colors.dart';
import '../../controllers/content_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/models.dart';
import '../../routes/app_routes.dart';

class LessonsView extends StatefulWidget {
  const LessonsView({super.key});

  @override
  State<LessonsView> createState() => _LessonsViewState();
}

class _LessonsViewState extends State<LessonsView> {
  String? _taskId;
  JourneyLevel? _level;
  JourneyUnit? _unit;
  JourneyTask? _task;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _readArguments();
      final controller = Get.find<ContentController>();
      if (controller.levels.isEmpty) controller.loadJourney();
      final taskId = _taskId;
      if (taskId != null && taskId.isNotEmpty) {
        controller.loadLessons(taskId);
      }
    });
  }

  void _readArguments() {
    final args = Get.arguments;
    String? id;
    if (args is String) {
      id = args;
    } else if (args is JourneyTask) {
      id = args.id;
      _task = args;
    } else if (args is Map) {
      id = args['taskId']?.toString();
    }
    if (id != null && id.isNotEmpty) {
      setState(() => _taskId = id);
      _resolveTask(id);
    }
  }

  void _resolveTask(String taskId) {
    final controller = Get.find<ContentController>();
    for (final level in controller.levels) {
      for (final unit in level.units) {
        for (final task in unit.tasks) {
          if (task.id == taskId) {
            _level = level;
            _unit = unit;
            _task = task;
            return;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContentController>();
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: Text(
          _taskId == null ? 'Lessons' : _unit?.title ?? 'Choose a lesson',
        ),
        actions: [
          if (_taskId != null)
            IconButton(
              tooltip: 'Refresh lessons',
              onPressed: () => controller.loadLessons(_taskId!),
              icon: const Icon(Icons.refresh_rounded),
            ),
        ],
      ),
      body: PageShell(
        animate: false,
        child: Obx(() {
          if (controller.loading.value &&
              (_taskId != null || controller.levels.isEmpty)) {
            return const LoadingState(message: 'Loading lessons...');
          }

          if (_taskId != null) {
            _resolveTask(_taskId!);
            return _LessonChooser(
              lessons: controller.lessons,
              level: _level,
              unit: _unit,
              task: _task,
            );
          }

          if (controller.levels.isEmpty) {
            return const EmptyState(
              title: 'No lessons found',
              subtitle: 'Pull down to refresh your journey.',
            );
          }

          return RefreshIndicator(
            onRefresh: controller.loadJourney,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Text(
                  'Choose a module',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Pick a unit/task first, then choose Lesson 01, Lesson 02, tests, or locked lessons.',
                  style: TextStyle(color: AppColors.muted, height: 1.4),
                ),
                const SizedBox(height: 18),
                StaggeredList(
                  gap: 12,
                  children: controller.levels
                      .expand(
                        (level) => level.units.expand(
                          (unit) => unit.tasks.map(
                            (task) => _ModuleCard(
                              level: level,
                              unit: unit,
                              task: task,
                              onTap: () {
                                Get.toNamed(Routes.lessons, arguments: task.id);
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.level,
    required this.unit,
    required this.task,
    required this.onTap,
  });

  final JourneyLevel level;
  final JourneyUnit unit;
  final JourneyTask task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.palm,
            foregroundColor: Colors.white,
            child: Text(
              '${unit.unitOrder}',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${level.title} • ${task.title}',
                  style: const TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class _LessonChooser extends StatelessWidget {
  const _LessonChooser({
    required this.lessons,
    required this.level,
    required this.unit,
    required this.task,
  });

  final List<LessonModel> lessons;
  final JourneyLevel? level;
  final JourneyUnit? unit;
  final JourneyTask? task;

  @override
  Widget build(BuildContext context) {
    final sorted = [...lessons]
      ..sort((a, b) => a.lessonOrder.compareTo(b.lessonOrder));
    final profileController = Get.find<ProfileController>();
    final profile = profileController.profile.value;
    final progress =
        profile?.currentProgress ?? profileController.progress.value;
    final fallbackCount = task?.lessonCount ?? 0;
    final visibleCount = sorted.isEmpty
        ? fallbackCount
        : (fallbackCount > sorted.length ? fallbackCount : sorted.length);

    return RefreshIndicator(
      onRefresh: () async {
        final id = task?.id;
        if (id != null && id.isNotEmpty) {
          await Get.find<ContentController>().loadLessons(id);
        }
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _LessonHeader(level: level, unit: unit, task: task),
          const SizedBox(height: 18),
          if (visibleCount == 0)
            const EmptyState(
              title: 'No lesson data found',
              subtitle:
                  'This task has no lessons from the API yet. Pull down to retry.',
            )
          else
            StaggeredList(
              gap: 12,
              children: List.generate(visibleCount, (index) {
                final order = index + 1;
                final lesson = index < sorted.length ? sorted[index] : null;
                final locked = _isLocked(lesson, order, progress);
                return _LessonTile(
                  lesson: lesson,
                  order: order,
                  locked: locked,
                  onTap: locked || lesson == null
                      ? null
                      : () async {
                          final controller = Get.find<ContentController>();
                          controller.resetLessonState(lesson: lesson);
                          await controller.loadQuestions(lesson);
                          Get.toNamed(
                            Routes.arabicLessonFlow,
                            arguments: lesson,
                          );
                        },
                );
              }),
            ),
        ],
      ),
    );
  }

  bool _isLocked(LessonModel? lesson, int order, ProgressModel? progress) {
    if (lesson == null) return true;
    if (lesson.active) return false;
    if (progress == null) return order > 1;

    final sameTask =
        lesson.levelOrder == progress.levelOrder &&
        lesson.unitOrder == progress.unitOrder &&
        lesson.taskOrder == progress.taskOrder;
    if (sameTask) return lesson.lessonOrder > progress.lessonOrder;

    final beforeCurrentTask =
        lesson.levelOrder < progress.levelOrder ||
        (lesson.levelOrder == progress.levelOrder &&
            lesson.unitOrder < progress.unitOrder) ||
        (lesson.levelOrder == progress.levelOrder &&
            lesson.unitOrder == progress.unitOrder &&
            lesson.taskOrder < progress.taskOrder);
    return !beforeCurrentTask && order > 1;
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.level,
    required this.unit,
    required this.task,
  });

  final JourneyLevel? level;
  final JourneyUnit? unit;
  final JourneyTask? task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.palm, AppColors.palmDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x337C3AED),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            level?.title ?? 'Lessons',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            unit?.title ?? 'Choose a lesson',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task?.title ?? 'Start with the unlocked lessons below.',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.lesson,
    required this.order,
    required this.locked,
    required this.onTap,
  });

  final LessonModel? lesson;
  final int order;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isExam = lesson?.isExam == true;
    final title = lesson?.title.trim().isNotEmpty == true
        ? lesson!.title
        : isExam
        ? 'Test ${order.toString().padLeft(2, '0')}'
        : 'Lesson ${order.toString().padLeft(2, '0')}';
    final color = locked
        ? const Color(0xFFE5E7EB)
        : isExam
        ? AppColors.date
        : AppColors.palm;

    return PressableScale(
      scale: locked ? 1 : .97,
      child: Opacity(
        opacity: locked ? .72 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: locked
                  ? const Color(0xFFD1D5DB)
                  : color.withValues(alpha: .25),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            enabled: !locked && lesson != null,
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: color,
              foregroundColor: locked ? AppColors.muted : Colors.white,
              child: Icon(
                locked
                    ? Icons.lock_rounded
                    : isExam
                    ? Icons.quiz_rounded
                    : Icons.play_arrow_rounded,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: locked ? AppColors.muted : AppColors.ink,
              ),
            ),
            subtitle: Text(
              locked
                  ? 'Locked lesson'
                  : isExam
                  ? 'Test'
                  : 'Tap to open lesson content',
              style: const TextStyle(color: AppColors.muted),
            ),
            trailing: Icon(
              locked ? Icons.lock_outline_rounded : Icons.chevron_right_rounded,
              color: locked ? AppColors.muted : color,
            ),
          ),
        ),
      ),
    );
  }
}
