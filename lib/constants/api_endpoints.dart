class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://nakhlah-api.nakhlah.net';
  static const String apiPrefix = '/api';

  static const String signUp = '/users/sign-in';
  static const String login = '/users/login';
  static const String logout = '/users/logout';
  static const String socialLogin = '/users/social-login';
  static const String forgotPassword = '/users/forgot-password';
  static const String resetPassword = '/users/reset-password';
  static const String changePassword = '/users/change-password';
  static const String refreshToken = '/users/refresh-token';
  static const String me = '/users/me';

  static const String userProfile = '/user-profile';
  static const String updateProfile = '/user-profile/update-me';
  static const String deleteProfile = '/user-profile/me';
  static const String learnerProgress = '/user-profile/learner-progress';
  static const String profileDailyQuest = '/user-profile/daily-quest';
  static const String palmRefill = '/user-profile/palm-refill';
  static const String learnerStreak = '/user-profile/learner-streak';
  static const String gamificationStocks = '/user-profile/gamification-stocks';
  static const String leaderboard = '/user-profile/get-leaderboard';

  static const String helpCenter = '/globals/help-center';
  static const String about = '/globals/about';
  static const String legalDocuments = '/globals/legal-documents';
  static const String userOnboarding = '/globals/user-onboarding';

  static const String journeyStructure = '/lessons/journey-structure';
  static const String lessonByOrder = '/lessons/lesson-by-order';
  static const String wrongAnswer = '/lessons/wrong-answer';
  static const String bulkUpload = '/lessons/bulk-upload';
  static const String bulkUploadTemplate = '/lessons/bulk-upload-template';

  static const String dailyQuestsConfig =
      '/globals/gamification/get-daily-quests';
  static const String badgesConfig = '/globals/gamification/get-badges';
  static const String achievements = '/globals/questionnaires/get-achievements';
  static const String nextLesson = '/globals/questionnaires/next-lesson';
  static const String previousLesson =
      '/globals/questionnaires/previous-lesson';
  static const String generalMedia = '/general-media';

  static String lessonsByTask(String id) => '/lessons/tasks/$id/lessons';
  static String giftBox(String id) => '/lessons/gift-box/$id';
  static String examQuestions(String id) => '/lessons/tasks/$id/exam-questions';
  static String questionsByLesson(String id) => '/lessons/$id';
  static String fullMarks(String id) =>
      '/globals/questionnaires/full-marks/$id';
  static String makeLearnerProgress(String id) =>
      '/lessons/make-learner-progress/$id';
  static String restoreStreak(int days) =>
      '/globals/questionnaires/restore-streak/$days';
}
