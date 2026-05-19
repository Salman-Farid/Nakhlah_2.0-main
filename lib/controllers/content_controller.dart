import 'package:get/get.dart';
import '../common/app_snackbar.dart';
import '../models/models.dart';
import '../services/content_service.dart';

class ContentController extends GetxController {
  ContentController(this.service);
  final ContentService service;
  final loading = false.obs;
  final levels = <JourneyLevel>[].obs;
  final lessons = <LessonModel>[].obs;
  final questions = <QuestionModel>[].obs;
  LessonModel? currentLesson;
  int currentStepIndex = 0;
  String? selectedAnswer;
  bool isAnswerChecked = false;
  List<String> matchedPairs = <String>[];
  List<String> writtenLetters = <String>[];
  void resetLessonState({LessonModel? lesson}) {
    currentLesson = lesson ?? currentLesson;
    currentStepIndex = 0;
    selectedAnswer = null;
    isAnswerChecked = false;
    matchedPairs = <String>[];
    writtenLetters = <String>[];
    update();
  }

  Future<void> loadJourney() async {
    try {
      loading.value = true;
      levels.assignAll(await service.journey());
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadLessons(String taskId) async {
    try {
      loading.value = true;
      lessons.assignAll(await service.lessonsByTask(taskId));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadQuestions(LessonModel l) async {
    try {
      loading.value = true;
      questions.assignAll(await service.questionsByLesson(l.id));
      if (questions.isEmpty) {
        questions.assignAll(
          await service.lessonByOrder(
            l.levelOrder,
            l.unitOrder,
            l.taskOrder,
            l.lessonOrder,
          ),
        );
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> completeLesson(String lessonId) async {
    try {
      await service.makeLearnerProgress(lessonId);
      AppSnackbar.success('Lesson progress saved.');
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }
}
