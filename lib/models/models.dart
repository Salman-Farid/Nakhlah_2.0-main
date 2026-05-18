import '../constants/api_endpoints.dart';

Map<String, dynamic>? _map(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return null;
}

List<dynamic> _list(dynamic value) => value is List ? value : const [];

int _int(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? fallback;
}

bool _bool(dynamic value) => value == true || value?.toString() == 'true';

String _string(dynamic value, [String fallback = '']) {
  final text = value?.toString();
  return text == null || text == 'null' ? fallback : text;
}

dynamic _unwrap(dynamic value) {
  var current = value;
  final seen = <dynamic>{};
  while (current is Map && !seen.contains(current)) {
    seen.add(current);
    if (current['data'] is Map || current['data'] is List) {
      current = current['data'];
    } else if (current['profile'] is Map) {
      current = current['profile'];
    } else if (current['docs'] is List &&
        (current['docs'] as List).isNotEmpty) {
      current = (current['docs'] as List).first;
    } else {
      break;
    }
  }
  return current;
}

List<dynamic> _unwrapList(dynamic value, {List<String> keys = const []}) {
  final unwrapped = _unwrap(value);
  if (unwrapped is List) return unwrapped;
  final map = _map(unwrapped);
  if (map == null) return const [];
  for (final key in [...keys, 'data', 'docs', 'items', 'results']) {
    if (map[key] is List) return map[key] as List;
  }
  return const [];
}

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.payload});

  final String message;
  final int? statusCode;
  final dynamic payload;

  @override
  String toString() => message;
}

class MediaModel {
  const MediaModel({
    this.id,
    this.url,
    this.thumbnailUrl,
    this.filename,
    this.mimeType,
    this.alt,
  });

  final String? id, url, thumbnailUrl, filename, mimeType, alt;

  String? get absoluteUrl {
    final u = url ?? thumbnailUrl;
    if (u == null || u.isEmpty) return null;
    if (u.startsWith('http')) return u;
    return '${ApiEndpoints.baseUrl}$u';
  }

  factory MediaModel.fromJson(dynamic value) {
    final j = _map(_unwrap(value));
    if (j == null) return const MediaModel();
    return MediaModel(
      id: j['id']?.toString(),
      url: j['url']?.toString() ?? j['profilePictureUrl']?.toString(),
      thumbnailUrl:
          j['thumbnailURL']?.toString() ?? j['thumbnailUrl']?.toString(),
      filename: j['filename']?.toString(),
      mimeType: j['mimeType']?.toString(),
      alt: j['alt']?.toString(),
    );
  }
}

class UserModel {
  const UserModel({this.id, this.email, this.name, this.role, this.pictureUrl});

  final String? id, email, name, role, pictureUrl;

  factory UserModel.fromJson(dynamic value) {
    final j = _map(_unwrap(value));
    if (j == null) return const UserModel();
    return UserModel(
      id: j['id']?.toString(),
      email: j['email']?.toString(),
      name: (j['name'] ?? j['fullName'])?.toString(),
      role: j['role']?.toString(),
      pictureUrl: (j['socialMediaPictureUrl'] ?? j['profilePictureUrl'])
          ?.toString(),
    );
  }
}

class AuthSession {
  const AuthSession({this.message, this.exp, this.token, this.user});

  final String? message, token;
  final int? exp;
  final UserModel? user;

  factory AuthSession.fromJson(dynamic value) {
    final j = _map(value);
    if (j == null) return const AuthSession();
    final data = _map(j['data']);
    final source = data ?? j;
    return AuthSession(
      message: j['message']?.toString(),
      exp: source['exp'] is int
          ? source['exp'] as int
          : int.tryParse('${source['exp']}'),
      token: (source['token'] ?? source['accessToken'])?.toString(),
      user: UserModel.fromJson(source['user']),
    );
  }
}

class OnboardInfo {
  const OnboardInfo({
    this.age = '',
    this.country = '',
    this.purpose = '',
    this.goalTime = 0,
    this.userSource = '',
    this.languageStrength = '',
  });

  final String age, country, purpose, userSource, languageStrength;
  final int goalTime;

  Map<String, dynamic> toJson() => {
    'age': age,
    'country': country,
    'purpose': purpose,
    'goalTime': goalTime,
    'userSource': userSource,
    'languageStrength': languageStrength,
  };

  factory OnboardInfo.fromJson(dynamic value) {
    final j = _map(_unwrap(value));
    if (j == null) return const OnboardInfo();
    return OnboardInfo(
      age: _string(j['age']),
      country: _string(j['country']),
      purpose: _string(j['purpose']),
      goalTime: _int(j['goalTime']),
      userSource: _string(j['userSource']),
      languageStrength: _string(j['languageStrength']),
    );
  }
}

class ProgressModel {
  const ProgressModel({
    this.levelOrder = 1,
    this.unitOrder = 1,
    this.taskOrder = 1,
    this.lessonOrder = 1,
    this.achievement = '',
  });

  final int levelOrder, unitOrder, taskOrder, lessonOrder;
  final String achievement;

  factory ProgressModel.fromJson(dynamic value) {
    final j = _map(_unwrap(value));
    if (j == null) return const ProgressModel();
    return ProgressModel(
      levelOrder: _int(j['levelOrder'], 1),
      unitOrder: _int(j['unitOrder'], 1),
      taskOrder: _int(j['taskOrder'], 1),
      lessonOrder: _int(j['lessonOrder'], 1),
      achievement: _string(j['achievement']),
    );
  }
}

class GamificationStock {
  const GamificationStock({
    this.palmStock = 0,
    this.dateStock = 0,
    this.injazStock = 0,
  });

  final int palmStock, dateStock, injazStock;

  factory GamificationStock.fromJson(dynamic value) {
    final j = _map(_unwrap(value));
    if (j == null) return const GamificationStock();
    final palm = _map(j['palm']);
    return GamificationStock(
      palmStock: palm == null ? _int(j['palmStock']) : _int(palm['palmStock']),
      dateStock: _int(j['dateStock']),
      injazStock: _int(j['injazStock'] ?? j['injazCount']),
    );
  }
}

class UserProfileModel {
  const UserProfileModel({
    this.id,
    this.fullName,
    this.contactNumber,
    this.email,
    this.profilePicture,
    this.onboardInfo = const OnboardInfo(),
    this.currentProgress = const ProgressModel(),
    this.stock = const GamificationStock(),
  });

  final String? id, fullName, contactNumber, email;
  final MediaModel? profilePicture;
  final OnboardInfo onboardInfo;
  final ProgressModel currentProgress;
  final GamificationStock stock;

  factory UserProfileModel.fromJson(dynamic value) {
    final j = _map(_unwrap(value));
    if (j == null) return const UserProfileModel();
    return UserProfileModel(
      id: j['id']?.toString(),
      fullName: j['fullName']?.toString(),
      contactNumber: j['contactNumber']?.toString(),
      email: j['email']?.toString(),
      profilePicture: MediaModel.fromJson(
        j['profilePicture'] ?? {'profilePictureUrl': j['profilePictureUrl']},
      ),
      onboardInfo: OnboardInfo.fromJson(j['onboardInfo']),
      currentProgress: ProgressModel.fromJson(
        j['currentProgress'] ?? j['learnerProgress'],
      ),
      stock: GamificationStock.fromJson(j['gamificationStock'] ?? j['stock']),
    );
  }
}

class LeaderboardEntryModel {
  const LeaderboardEntryModel({
    required this.rank,
    required this.id,
    required this.fullName,
    required this.injazCount,
    this.email,
    this.profilePictureUrl,
  });

  final int rank;
  final String id, fullName;
  final String? email, profilePictureUrl;
  final int injazCount;

  String get initials {
    final words = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    return words.take(2).map((e) => e[0].toUpperCase()).join();
  }

  factory LeaderboardEntryModel.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return LeaderboardEntryModel(
      rank: _int(j['rank'], 0),
      id: _string(j['id']),
      fullName: _string(j['fullName'] ?? j['name'], 'Learner'),
      email: j['email']?.toString(),
      injazCount: _int(j['injazCount'] ?? j['injazStock'] ?? j['score']),
      profilePictureUrl: j['profilePictureUrl']?.toString(),
    );
  }
}

class JourneyLevel {
  const JourneyLevel({
    required this.id,
    required this.title,
    required this.levelOrder,
    required this.units,
    this.active = false,
  });

  final String id, title;
  final int levelOrder;
  final bool active;
  final List<JourneyUnit> units;

  factory JourneyLevel.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return JourneyLevel(
      id: _string(j['id']),
      title: _string(j['title'] ?? j['name'], 'Level'),
      levelOrder: _int(j['levelOrder'] ?? j['order']),
      active: _bool(j['inProgressOrCompleted'] ?? j['active']),
      units: _list(j['units']).map((e) => JourneyUnit.fromJson(e)).toList(),
    );
  }
}

class JourneyUnit {
  const JourneyUnit({
    required this.id,
    required this.title,
    required this.unitOrder,
    required this.tasks,
    this.active = false,
  });

  final String id, title;
  final int unitOrder;
  final bool active;
  final List<JourneyTask> tasks;

  factory JourneyUnit.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return JourneyUnit(
      id: _string(j['id']),
      title: _string(j['title'] ?? j['name'], 'Unit'),
      unitOrder: _int(j['unitOrder'] ?? j['order']),
      active: _bool(j['inProgressOrCompleted'] ?? j['active']),
      tasks: _list(j['tasks']).map((e) => JourneyTask.fromJson(e)).toList(),
    );
  }
}

class JourneyTask {
  const JourneyTask({
    required this.id,
    required this.title,
    required this.taskOrder,
    this.lessonCount = 0,
    this.giftBox = false,
    this.active = false,
  });

  final String id, title;
  final int taskOrder, lessonCount;
  final bool giftBox, active;

  factory JourneyTask.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return JourneyTask(
      id: _string(j['id']),
      title: _string(j['title'] ?? j['name'], 'Task'),
      taskOrder: _int(j['taskOrder'] ?? j['order']),
      lessonCount: _int(j['lessonCount'] ?? j['lessonsCount']),
      giftBox: _bool(j['giftBox']),
      active: _bool(j['inProgressOrCompleted'] ?? j['active']),
    );
  }
}

class LessonModel {
  const LessonModel({
    required this.id,
    required this.title,
    this.levelOrder = 1,
    this.unitOrder = 1,
    this.taskOrder = 1,
    this.lessonOrder = 1,
    this.isExam = false,
    this.active = false,
  });

  final String id, title;
  final int levelOrder, unitOrder, taskOrder, lessonOrder;
  final bool isExam, active;

  factory LessonModel.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return LessonModel(
      id: _string(j['id']),
      title: _string(j['title'] ?? j['lessonTitle'] ?? j['name'], 'Lesson'),
      levelOrder: _int(j['levelOrder'], 1),
      unitOrder: _int(j['unitOrder'], 1),
      taskOrder: _int(j['taskOrder'], 1),
      lessonOrder: _int(j['lessonOrder'], 1),
      isExam: _bool(j['isExam']),
      active: _bool(j['inProgressOrCompleted'] ?? j['active']),
    );
  }
}

class AnswerModel {
  const AnswerModel({
    required this.id,
    this.title = '',
    this.isCorrect,
    this.mediaType,
    this.media,
  });

  final String id, title;
  final bool? isCorrect;
  final String? mediaType;
  final MediaModel? media;

  factory AnswerModel.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return AnswerModel(
      id: _string(j['id']),
      title: _string(j['title'] ?? j['answer_title'] ?? j['text']),
      isCorrect: j['is_correct'] is bool
          ? j['is_correct'] as bool
          : (j['isCorrect'] is bool ? j['isCorrect'] as bool : null),
      mediaType: j['media_type']?.toString() ?? j['mediaType']?.toString(),
      media: MediaModel.fromJson(j['media']),
    );
  }
}

class QuestionModel {
  const QuestionModel({
    required this.id,
    required this.type,
    required this.title,
    required this.answers,
    this.media = const [],
  });

  final String id, type, title;
  final List<AnswerModel> answers;
  final List<MediaModel> media;

  factory QuestionModel.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return QuestionModel(
      id: _string(j['id']),
      type: _string(
        j['question_type'] ?? j['questionType'] ?? j['type'],
        'mcq',
      ),
      title: _string(
        j['question_title'] ?? j['questionTitle'] ?? j['title'],
        'Question',
      ),
      answers: _list(j['answers']).map((e) => AnswerModel.fromJson(e)).toList(),
      media: _list(
        j['questionMedia'],
      ).map((e) => MediaModel.fromJson(_map(e)?['media'] ?? e)).toList(),
    );
  }
}

class QuestStatus {
  const QuestStatus({
    required this.challengeId,
    required this.status,
    this.required = 0,
    this.current = 0,
    this.reward = 0,
  });

  final String challengeId, status;
  final int required, current, reward;

  factory QuestStatus.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    final d = _map(j['details']) ?? const {};
    return QuestStatus(
      challengeId: _string(j['challengeId']),
      status: _string(j['status'], 'pending'),
      required: _int(d['required']),
      current: _int(d['current']),
      reward: _int(d['reward']),
    );
  }
}

class StreakModel {
  const StreakModel({
    this.currentStreak = 0,
    this.missedDays = 0,
    this.startDate,
    this.lastCompletedDate,
  });

  final int currentStreak, missedDays;
  final String? startDate, lastCompletedDate;

  factory StreakModel.fromJson(dynamic value) {
    final j = _map(_unwrap(value));
    if (j == null) return const StreakModel();
    return StreakModel(
      currentStreak: _int(j['currentStreak']),
      missedDays: _int(j['missedDays']),
      startDate: j['startDate']?.toString(),
      lastCompletedDate: j['lastCompletedDate']?.toString(),
    );
  }
}

class AchievementModel {
  const AchievementModel({
    required this.id,
    required this.title,
    required this.achievementTitle,
    this.achieved = false,
    this.levelOrder = 0,
    this.unitOrder = 0,
  });

  final String id, title, achievementTitle;
  final bool achieved;
  final int levelOrder, unitOrder;

  factory AchievementModel.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return AchievementModel(
      id: _string(j['id']),
      title: _string(j['title']),
      achievementTitle: _string(j['achievementTitle'] ?? j['name']),
      achieved: _bool(j['achieved']),
      levelOrder: _int(j['levelOrder']),
      unitOrder: _int(j['unitOrder']),
    );
  }
}

class FaqModel {
  const FaqModel({required this.question, required this.answer});

  final String question, answer;

  factory FaqModel.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return FaqModel(
      question: _string(j['question']),
      answer: _string(j['answer']),
    );
  }
}

class TextBlock {
  static String extract(dynamic value) {
    final parts = <String>[];
    void walk(dynamic n) {
      if (n is Map) {
        if (n['text'] != null) parts.add(n['text'].toString());
        for (final v in n.values) {
          walk(v);
        }
      } else if (n is List) {
        for (final v in n) {
          walk(v);
        }
      }
    }

    walk(value);
    return parts.join('\n').trim();
  }
}

class OnboardingOptions {
  const OnboardingOptions({
    this.purpose = const [],
    this.goal = const [],
    this.country = const [],
    this.userSource = const [],
    this.languageStrength = const [],
    this.age = const [],
    this.interests = const [],
  });

  final List<String> purpose,
      goal,
      country,
      userSource,
      languageStrength,
      age,
      interests;

  static List<String> _labels(dynamic value) => _list(value)
      .map((e) {
        final m = _map(e);
        return m == null
            ? e.toString()
            : (m['label'] ?? m['title'] ?? m['value'] ?? m['name']).toString();
      })
      .where((e) => e != 'null')
      .toList();

  factory OnboardingOptions.fromJson(dynamic value) {
    final j = _map(_unwrap(value)) ?? const {};
    return OnboardingOptions(
      purpose: _labels(j['purpose']),
      goal: _labels(j['Goal'] ?? j['goal']),
      country: _labels(j['Country'] ?? j['country']),
      userSource: _labels(j['userSource']),
      languageStrength: _labels(j['languageStrength']),
      age: _labels(j['age']),
      interests: _labels(j['interests']),
    );
  }
}

List<JourneyLevel> parseJourneyLevels(dynamic value) => _unwrapList(
  value,
  keys: const ['levels'],
).map((e) => JourneyLevel.fromJson(e)).toList();

List<LessonModel> parseLessons(dynamic value) => _unwrapList(
  value,
  keys: const ['lessons'],
).map((e) => LessonModel.fromJson(e)).toList();

List<QuestionModel> parseQuestions(dynamic value) => _unwrapList(
  value,
  keys: const ['questions'],
).map((e) => QuestionModel.fromJson(e)).toList();

List<AchievementModel> parseAchievements(dynamic value) => _unwrapList(
  value,
  keys: const ['achievements'],
).map((e) => AchievementModel.fromJson(e)).toList();

List<QuestStatus> parseQuestStatuses(dynamic value) => _unwrapList(
  value,
  keys: const ['challengeStatuses'],
).map((e) => QuestStatus.fromJson(e)).toList();

List<LeaderboardEntryModel> parseLeaderboard(dynamic value) =>
    _unwrapList(value, keys: const ['leaderboard'])
        .map((e) => LeaderboardEntryModel.fromJson(e))
        .where((e) => e.id.isNotEmpty || e.fullName.isNotEmpty)
        .toList();
