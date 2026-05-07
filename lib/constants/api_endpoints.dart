class ApiEndpoints {
  ApiEndpoints._();
  static const String baseUrl = 'https://nakhlah-api.nakhlah.net';
  static const String apiPrefix = '/api';
  static const String signUp = '/users/sign-in', login = '/users/login', logout = '/users/logout', socialLogin = '/users/social-login', forgotPassword = '/users/forgot-password', resetPassword = '/users/reset-password', changePassword = '/users/change-password', refreshToken = '/users/refresh-token', me = '/users/me';
  static const String userProfile = '/user-profile', updateProfile = '/user-profile/update-me', deleteProfile = '/user-profile/me', learnerProgress = '/user-profile/learner-progress', profileDailyQuest = '/user-profile/daily-quest', palmRefill = '/user-profile/palm-refill', learnerStreak = '/user-profile/learner-streak', gamificationStocks = '/user-profile/gamification-stocks';
  static const String helpCenter = '/globals/help-center', about = '/globals/about', legalDocuments = '/globals/legal-documents', userOnboarding = '/globals/user-onboarding';
  static const String journeyStructure = '/globals/questionnaires/journey-structure', lessonByOrder = '/globals/questionnaires/lesson-by-order', wrongAnswer = '/globals/questionnaires/wrong-answer', dailyQuestsConfig = '/globals/gamification/get-daily-quests', badgesConfig = '/globals/gamification/get-badges', achievements = '/globals/questionnaires/get-achievements', nextLesson = '/globals/questionnaires/next-lesson', previousLesson = '/globals/questionnaires/previous-lesson', generalMedia = '/general-media';
  static String lessonsByTask(String id) => '/globals/questionnaires/tasks/$id/lessons';
  static String giftBox(String id) => '/globals/questionnaires/gift-box/$id';
  static String examQuestions(String id) => '/globals/questionnaires/tasks/$id/exam-questions';
  static String questionsByLesson(String id) => '/globals/questionnaires/lessons/$id';
  static String fullMarks(String id) => '/globals/questionnaires/full-marks/$id';
  static String makeLearnerProgress(String id) => '/globals/questionnaires/make-learner-progress/$id';
  static String restoreStreak(int days) => '/globals/questionnaires/restore-streak/$days';
}
