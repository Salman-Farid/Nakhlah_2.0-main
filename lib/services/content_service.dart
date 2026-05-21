import '../constants/api_endpoints.dart';
import '../models/lesson_question_model.dart';
import '../models/models.dart';
import 'api_service.dart';

class ContentService {
  ContentService(this._api);

  final ApiService _api;

  Future<List<JourneyLevel>> journey() async {
    return parseJourneyLevels(await _api.get(ApiEndpoints.journeyStructure));
  }

  Future<List<LessonModel>> lessonsByTask(String id) async {
    return parseLessons(await _api.get(ApiEndpoints.lessonsByTask(id)));
  }

  Future<List<QuestionModel>> lessonByOrder(
    int l,
    int u,
    int t,
    int lesson,
  ) async {
    return parseQuestions(
      await _api.get(
        ApiEndpoints.lessonByOrder,
        query: {
          'levelOrder': l,
          'unitOrder': u,
          'taskOrder': t,
          'lessonOrder': lesson,
        },
      ),
    );
  }

  Future<List<QuestionModel>> questionsByLesson(String id) async {
    return parseQuestions(await _api.get(ApiEndpoints.questionsByLesson(id)));
  }

  Future<List<QuestionModel>> examQuestions(String taskId) async {
    return parseQuestions(await _api.get(ApiEndpoints.examQuestions(taskId)));
  }

  Future<List<LessonQuestion>> fetchLessonQuestions(String lessonId) async {
    return parseLessonQuestions(
      await _api.get(ApiEndpoints.questionsByLesson(lessonId)),
    );
  }

  Future<List<LessonQuestion>> fetchExamQuestions(String taskId) async {
    return parseLessonQuestions(
      await _api.get(ApiEndpoints.examQuestions(taskId)),
    );
  }

  Future<GamificationStock> reportWrongAnswer() async {
    return GamificationStock.fromJson(await _api.get(ApiEndpoints.wrongAnswer));
  }

  Future<dynamic> reportFullMarks(String lessonId) {
    return _api.get(ApiEndpoints.fullMarks(lessonId));
  }

  Future<dynamic> giftBox(String id) => _api.get(ApiEndpoints.giftBox(id));
  Future<dynamic> fullMarks(String id) => _api.get(ApiEndpoints.fullMarks(id));

  Future<GamificationStock> wrongAnswer() async {
    return GamificationStock.fromJson(await _api.get(ApiEndpoints.wrongAnswer));
  }

  Future<dynamic> makeLearnerProgress(String id) {
    return _api.get(ApiEndpoints.makeLearnerProgress(id));
  }

  Future<List<QuestionModel>> nextLesson(ProgressModel p) =>
      _ordered(ApiEndpoints.nextLesson, p);
  Future<List<QuestionModel>> previousLesson(ProgressModel p) =>
      _ordered(ApiEndpoints.previousLesson, p);

  Future<List<QuestionModel>> _ordered(String path, ProgressModel p) async {
    return parseQuestions(
      await _api.get(
        path,
        query: {
          'levelOrder': p.levelOrder,
          'unitOrder': p.unitOrder,
          'taskOrder': p.taskOrder,
          'lessonOrder': p.lessonOrder,
        },
      ),
    );
  }

  Future<dynamic> media({int limit = 15}) =>
      _api.get(ApiEndpoints.generalMedia, query: {'limit': limit});
}
