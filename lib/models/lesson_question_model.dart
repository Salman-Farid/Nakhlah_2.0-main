import 'models.dart';

class LessonQuestionMedia {
  const LessonQuestionMedia({this.mediaType = '', this.media});

  final String mediaType;
  final MediaModel? media;

  bool get isAudio => mediaType == 'audio' || (media?.isAudio ?? false);
  bool get isImage => mediaType == 'image' || media?.url != null;

  String? get url => media?.absoluteUrl;

  factory LessonQuestionMedia.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return LessonQuestionMedia(
      mediaType: _string(j['media_type'] ?? j['mediaType'] ?? ''),
      media: MediaModel.fromJson(j['media']),
    );
  }
}

class LessonAnswer {
  const LessonAnswer({
    required this.id,
    this.title = '',
    this.isCorrect,
    this.orderNumber = 0,
    this.leftTitle = '',
    this.rightTitle = '',
    this.mediaType = '',
    this.media,
  });

  final String id, title, leftTitle, rightTitle, mediaType;
  final bool? isCorrect;
  final int orderNumber;
  final MediaModel? media;

  factory LessonAnswer.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return LessonAnswer(
      id: _string(j['id']),
      title: _string(j['title'] ?? j['answer_title'] ?? j['text'] ?? j['answer']),
      isCorrect: j['is_correct'] is bool
          ? j['is_correct'] as bool
          : (j['isCorrect'] is bool ? j['isCorrect'] as bool : null),
      orderNumber: _int(j['order_number'] ?? j['orderNumber'] ?? j['order']),
      leftTitle: _string(j['left_title'] ?? j['leftTitle'] ?? j['left']),
      rightTitle: _string(j['right_title'] ?? j['rightTitle'] ?? j['right']),
      mediaType: _string(j['media_type'] ?? j['mediaType']),
      media: MediaModel.fromJson(j['media']),
    );
  }
}

class LessonQuestion {
  const LessonQuestion({
    required this.id,
    required this.questionType,
    this.questionTitle = '',
    this.questionMedia = const [],
    this.answers = const [],
    this.learnAnswer = '',
    this.trueFalseAnswer,
  });

  final String id;
  final String questionType;
  final String questionTitle;
  final List<LessonQuestionMedia> questionMedia;
  final List<LessonAnswer> answers;
  final String learnAnswer;
  final bool? trueFalseAnswer;

  bool get isLearn => questionType == 'learn';
  bool get isMcq => questionType == 'mcq';
  bool get isTrueFalse => questionType == 'true_false';
  bool get isFillBlank => questionType == 'fill_blank';
  bool get isWordMaking => questionType == 'word_making';
  bool get isSentenceMaking => questionType == 'sentence_making';
  bool get isPairMatching => questionType == 'pair_matching';
  bool get isScored => !isLearn;

  String? get imageUrl {
    for (final m in questionMedia) {
      if (m.isImage && m.url != null) return m.url;
    }
    return null;
  }

  String? get audioUrl {
    for (final m in questionMedia) {
      if (m.isAudio && m.url != null) return m.url;
    }
    return null;
  }

  List<LessonAnswer> get sortedAnswers =>
      [...answers]..sort((a, b) => a.orderNumber.compareTo(b.orderNumber));

  List<LessonAnswer> get correctAnswers =>
      answers.where((a) => a.isCorrect == true).toList();

  LessonAnswer? get correctAnswer =>
      answers.where((a) => a.isCorrect == true).firstOrNull;

  factory LessonQuestion.fromJson(dynamic value) {
    final j = _map(value) ?? const {};
    return LessonQuestion(
      id: _string(j['id']),
      questionType: _string(
        j['question_type'] ?? j['questionType'] ?? j['type'],
        'learn',
      ),
      questionTitle: _string(
        j['question_title'] ?? j['questionTitle'] ?? j['title'],
      ),
      questionMedia: _list(j['question_media'] ?? j['questionMedia'])
          .map((e) => LessonQuestionMedia.fromJson(e))
          .toList(),
      answers: _list(j['answers'])
          .map((e) => LessonAnswer.fromJson(e))
          .toList(),
      learnAnswer: _string(j['learn_answer'] ?? j['learnAnswer']),
      trueFalseAnswer: j['true_false_answer'] is bool
          ? j['true_false_answer'] as bool
          : (j['trueFalseAnswer'] is bool
              ? j['trueFalseAnswer'] as bool
              : null),
    );
  }
}

List<LessonQuestion> parseLessonQuestions(dynamic value) => _unwrapList(value)
    .map((e) => LessonQuestion.fromJson(e))
    .toList();

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

String _string(dynamic value, [String fallback = '']) {
  final text = value?.toString();
  return text == null || text == 'null' ? fallback : text;
}

List<dynamic> _unwrapList(dynamic value) {
  var current = value;
  for (var depth = 0; depth < 8; depth++) {
    if (current is List) return current;
    final map = current is Map ? current : null;
    if (map == null) return const [];
    for (final key in ['data', 'docs', 'items', 'results', 'questions']) {
      if (map[key] is List) return map[key] as List;
    }
    dynamic next;
    for (final key in ['data', 'payload', 'result']) {
      if (map[key] is Map || map[key] is List) {
        next = map[key];
        break;
      }
    }
    if (next == null || identical(next, current)) break;
    current = next;
  }
  return const [];
}
