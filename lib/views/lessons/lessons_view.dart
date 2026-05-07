import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_card.dart';
import '../../common/app_motion.dart';
import '../../common/empty_state.dart';
import '../../common/loading_state.dart';
import '../../common/responsive.dart';
import '../../controllers/content_controller.dart';
import '../../models/models.dart';
import '../../routes/app_routes.dart';

class LessonsView extends StatefulWidget {
  const LessonsView({super.key});

  @override
  State<LessonsView> createState() => _LessonsViewState();
}

class _LessonsViewState extends State<LessonsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = Get.find<ContentController>();
      if (controller.levels.isEmpty) controller.loadJourney();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContentController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: PageShell(
        child: Obx(
          () => controller.loading.value
              ? const LoadingState()
              : controller.levels.isEmpty
              ? const EmptyState(title: 'No lessons found')
              : ListView(
                  children: [
                    StaggeredList(
                      children: controller.levels
                          .expand(
                            (level) => level.units.expand(
                              (unit) => unit.tasks.map(
                                (task) => AppCard(
                                  onTap: () async {
                                    await controller.loadLessons(task.id);
                                    if (!context.mounted) return;
                                    _showLessons(context, controller.lessons);
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      '${level.title} • ${unit.title}',
                                    ),
                                    subtitle: Text(task.title),
                                    trailing: const Icon(
                                      Icons.chevron_right_rounded,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showLessons(BuildContext context, List<LessonModel> lessons) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .65,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(18),
          children: [
            Text('Lessons', style: Theme.of(context).textTheme.titleLarge),
            ...lessons.map(
              (lesson) => ListTile(
                title: Text(lesson.title),
                subtitle: Text(lesson.isExam ? 'Exam' : 'Practice lesson'),
                trailing: const Icon(Icons.play_circle),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.exercise, arguments: lesson);
                },
              ),
            ),
            if (lessons.isEmpty)
              const EmptyState(title: 'No lessons in this task yet'),
          ],
        ),
      ),
    );
  }
}
