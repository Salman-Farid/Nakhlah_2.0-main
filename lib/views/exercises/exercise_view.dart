import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_theme.dart';
import '../../models/lesson_question_model.dart';
import '../../services/content_service.dart';
import 'lesson_result_view.dart';

const _lessonMaxWidth = 430.0;
const _maxPalmTrees = 5;

class LessonEngineArgs {
  const LessonEngineArgs({
    required this.lessonId,
    this.taskId,
    this.isExamLesson = false,
  });

  final String lessonId;
  final String? taskId;
  final bool isExamLesson;
}

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView>
    with TickerProviderStateMixin {
  late final ContentService _contentService;

  List<LessonQuestion> _questions = [];
  bool _loading = true;
  String? _error;

  int _currentIndex = 0;
  int _palmTrees = _maxPalmTrees;
  int _elapsedSeconds = 0;
  Timer? _timer;

  int _correctAnswers = 0;
  bool _hasWrongAnswer = false;
  bool _questionAnswered = false;
  bool? _lastAnswerCorrect;

  // MCQ / True-False / Fill-blank state
  String? _selectedOptionId;
  bool? _selectedTrueFalse;
  String? _selectedFillBlankId;

  // Word/Sentence making state
  final List<LessonAnswer> _selectedTokens = [];
  final Set<String> _usedTokenIds = {};

  // Pair matching state
  String? _selectedLeftId;
  final Map<String, String> _matchedPairs = {};
  bool _pairPenaltyApplied = false;

  // Feedback animation
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  LessonEngineArgs? _args;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _feedbackAnimation = CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.easeOutBack,
    );

    _contentService = Get.find<ContentService>();
    _args = Get.arguments is LessonEngineArgs
        ? Get.arguments as LessonEngineArgs
        : null;

    if (_args == null) {
      _error = 'No lesson specified';
      _loading = false;
    } else {
      _loadQuestions();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final args = _args!;
      List<LessonQuestion> questions;

      if (args.isExamLesson && args.taskId != null) {
        questions = await _contentService.fetchExamQuestions(args.taskId!);
      } else {
        questions = await _contentService.fetchLessonQuestions(args.lessonId);
      }

      if (questions.isEmpty) {
        setState(() {
          _error = 'No questions found for this lesson';
          _loading = false;
        });
        return;
      }

      setState(() {
        _questions = questions;
        _loading = false;
        _currentIndex = 0;
        _palmTrees = _maxPalmTrees;
        _correctAnswers = 0;
        _hasWrongAnswer = false;
      });

      _startTimer();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  String get _timerText {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  LessonQuestion get _currentQuestion => _questions[_currentIndex];
  int get _totalQuestions => _questions.length;
  bool get _isLastQuestion => _currentIndex >= _totalQuestions - 1;
  int get _scoredQuestions => _questions.where((q) => q.isScored).length;

  double get _progress => _totalQuestions > 0
      ? (_currentIndex + 1) / _totalQuestions
      : 0;

  void _resetQuestionState() {
    _selectedOptionId = null;
    _selectedTrueFalse = null;
    _selectedFillBlankId = null;
    _selectedTokens.clear();
    _usedTokenIds.clear();
    _selectedLeftId = null;
    _matchedPairs.clear();
    _pairPenaltyApplied = false;
    _questionAnswered = false;
    _lastAnswerCorrect = null;
  }

  bool get _hasAnswer {
    final q = _currentQuestion;
    if (q.isLearn) return true;
    if (q.isMcq) return _selectedOptionId != null;
    if (q.isTrueFalse) return _selectedTrueFalse != null;
    if (q.isFillBlank) return _selectedFillBlankId != null;
    if (q.isWordMaking || q.isSentenceMaking) return _selectedTokens.isNotEmpty;
    if (q.isPairMatching) {
      return _matchedPairs.length == q.answers.length;
    }
    return false;
  }

  bool _checkAnswer() {
    final q = _currentQuestion;
    if (q.isLearn) return true;
    if (q.isMcq) {
      final selected = q.answers.where((a) => a.id == _selectedOptionId).firstOrNull;
      return selected?.isCorrect == true;
    }
    if (q.isTrueFalse) {
      return _selectedTrueFalse == q.trueFalseAnswer;
    }
    if (q.isFillBlank) {
      final selected = q.answers.where((a) => a.id == _selectedFillBlankId).firstOrNull;
      return selected?.isCorrect == true;
    }
    if (q.isWordMaking || q.isSentenceMaking) {
      final sorted = q.sortedAnswers;
      if (_selectedTokens.length != sorted.length) return false;
      for (var i = 0; i < sorted.length; i++) {
        if (_selectedTokens[i].id != sorted[i].id) return false;
      }
      return true;
    }
    if (q.isPairMatching) {
      return _matchedPairs.length == q.answers.length;
    }
    return false;
  }

  void _handleCheck() {
    if (_questionAnswered) {
      _handleContinue();
      return;
    }

    final isCorrect = _checkAnswer();

    setState(() {
      _questionAnswered = true;
      _lastAnswerCorrect = isCorrect;
    });

    if (isCorrect) {
      _correctAnswers++;
      _feedbackController.forward(from: 0);
    } else {
      _hasWrongAnswer = true;
      _palmTrees--;
      _feedbackController.forward(from: 0);
      _reportWrongAnswer();

      if (_palmTrees <= 0) {
        _showOutOfLivesDialog();
        return;
      }
    }
  }

  Future<void> _reportWrongAnswer() async {
    try {
      await _contentService.reportWrongAnswer();
    } catch (_) {}
  }

  Future<void> _completeLesson() async {
    _timer?.cancel();

    try {
      if (_hasWrongAnswer) {
        await _contentService.makeLearnerProgress(_args!.lessonId);
      } else {
        await _contentService.reportFullMarks(_args!.lessonId);
      }
    } catch (_) {}

    if (!mounted) return;

    final result = LessonResultData(
      lessonId: _args!.lessonId,
      elapsedSeconds: _elapsedSeconds,
      totalQuestions: _totalQuestions,
      scoredQuestions: _scoredQuestions,
      correctAnswers: _correctAnswers,
      injazEarned: _hasWrongAnswer ? 25 : 50,
      palmTreesRemaining: _palmTrees,
      hasWrongAnswer: _hasWrongAnswer,
    );

    Get.off(() => const LessonResultView(), arguments: result);
  }

  void _handleContinue() {
    if (_isLastQuestion) {
      _completeLesson();
      return;
    }

    setState(() {
      _currentIndex++;
      _resetQuestionState();
    });
  }

  void _handleBack() {
    _showLeavingDialog();
  }

  void _showLeavingDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Leave lesson?',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text(
          'Your progress in this lesson will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Stay',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.back();
            },
            child: const Text(
              'Leave',
              style: TextStyle(
                color: AppColors.wrongRed,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOutOfLivesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Out of lives!',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text(
          'You ran out of palm trees. Come back later or refill to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.back();
            },
            child: const Text(
              'Leave',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _lessonMaxWidth),
              child: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.accent),
            SizedBox(height: 16),
            Text(
              'Loading lesson...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.wrongRed,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: AppTheme.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                    ),
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildQuestionContent(),
          ),
        ),
        if (_questionAnswered) _buildFeedbackBanner(),
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildTopBar() {
    return SizedBox(
      height: 72,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 12, 4),
        child: Row(
          children: [
            IconButton(
              onPressed: _handleBack,
              icon: const Icon(
                Icons.close_rounded,
                color: AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8,
                      backgroundColor: AppColors.optionBorderDefault,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _timerText,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildPalmTrees(),
          ],
        ),
      ),
    );
  }

  Widget _buildPalmTrees() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_maxPalmTrees, (i) {
        final active = i < _palmTrees;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Icon(
            Icons.park_rounded,
            size: 18,
            color: active ? AppColors.palm : AppColors.optionBorderDefault,
          ),
        );
      }),
    );
  }

  Widget _buildQuestionContent() {
    final q = _currentQuestion;

    switch (q.questionType) {
      case 'learn':
        return _buildLearnQuestion(q);
      case 'mcq':
        return _buildMcqQuestion(q);
      case 'true_false':
        return _buildTrueFalseQuestion(q);
      case 'fill_blank':
        return _buildFillBlankQuestion(q);
      case 'word_making':
      case 'sentence_making':
        return _buildTokenMakingQuestion(q);
      case 'pair_matching':
        return _buildPairMatchingQuestion(q);
      default:
        return _buildLearnQuestion(q);
    }
  }

  // ─── LEARN ──────────────────────────────────────────────────────────────
  Widget _buildLearnQuestion(LessonQuestion q) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          _buildQuestionLabel('Learn'),
          const SizedBox(height: 20),
          if (q.imageUrl != null) ...[
            _buildImageCard(q.imageUrl!),
            const SizedBox(height: 24),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                if (q.questionTitle.isNotEmpty) ...[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      q.questionTitle,
                      textAlign: TextAlign.center,
                      style: AppTheme.arabicTextStyle(fontSize: 36),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (q.learnAnswer.isNotEmpty)
                  Text(
                    q.learnAnswer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─── MCQ ────────────────────────────────────────────────────────────────
  Widget _buildMcqQuestion(LessonQuestion q) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel('Question'),
          const SizedBox(height: 18),
          Text(
            q.questionTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          if (q.imageUrl != null) ...[
            const SizedBox(height: 18),
            _buildImageCard(q.imageUrl!, height: 150),
          ],
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.25,
            ),
            itemCount: q.answers.length,
            itemBuilder: (context, index) {
              final answer = q.answers[index];
              final isSelected = _selectedOptionId == answer.id;
              final isCorrectAnswer = answer.isCorrect == true;
              final showCorrect = _questionAnswered && isCorrectAnswer;
              final showWrong =
                  _questionAnswered && isSelected && !isCorrectAnswer;

              return _McqOption(
                text: answer.title,
                selected: isSelected,
                correct: showCorrect,
                wrong: showWrong,
                onTap: _questionAnswered
                    ? null
                    : () => setState(() => _selectedOptionId = answer.id),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── TRUE / FALSE ──────────────────────────────────────────────────────
  Widget _buildTrueFalseQuestion(LessonQuestion q) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel('Question'),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              q.questionTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                height: 1.25,
              ),
            ),
          ),
          if (q.imageUrl != null) ...[
            const SizedBox(height: 18),
            _buildImageCard(q.imageUrl!, height: 150),
          ],
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _TrueFalseButton(
                  label: 'True',
                  icon: Icons.check_rounded,
                  selected: _selectedTrueFalse == true,
                  correct: _questionAnswered && q.trueFalseAnswer == true,
                  wrong: _questionAnswered &&
                      _selectedTrueFalse == true &&
                      q.trueFalseAnswer != true,
                  onTap: _questionAnswered
                      ? null
                      : () => setState(() => _selectedTrueFalse = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TrueFalseButton(
                  label: 'False',
                  icon: Icons.close_rounded,
                  selected: _selectedTrueFalse == false,
                  correct: _questionAnswered && q.trueFalseAnswer == false,
                  wrong: _questionAnswered &&
                      _selectedTrueFalse == false &&
                      q.trueFalseAnswer != false,
                  onTap: _questionAnswered
                      ? null
                      : () => setState(() => _selectedTrueFalse = false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── FILL BLANK ────────────────────────────────────────────────────────
  Widget _buildFillBlankQuestion(LessonQuestion q) {
    final displayTitle = q.questionTitle.replaceAll(
      RegExp(r'[_\-\.]{2,}'),
      '____',
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel('Fill in the blank'),
          const SizedBox(height: 18),
          Directionality(
            textDirection: _isArabicText(q.questionTitle)
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Text(
              displayTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _isArabicText(q.questionTitle) ? 28 : 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                height: 1.35,
                fontFamily: _isArabicText(q.questionTitle)
                    ? AppTheme.arabicFontFamily
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.25,
            ),
            itemCount: q.answers.length,
            itemBuilder: (context, index) {
              final answer = q.answers[index];
              final isSelected = _selectedFillBlankId == answer.id;
              final isCorrectAnswer = answer.isCorrect == true;
              final showCorrect = _questionAnswered && isCorrectAnswer;
              final showWrong =
                  _questionAnswered && isSelected && !isCorrectAnswer;

              return _McqOption(
                text: answer.title,
                selected: isSelected,
                correct: showCorrect,
                wrong: showWrong,
                onTap: _questionAnswered
                    ? null
                    : () =>
                          setState(() => _selectedFillBlankId = answer.id),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── WORD / SENTENCE MAKING ────────────────────────────────────────────
  Widget _buildTokenMakingQuestion(LessonQuestion q) {
    final sorted = q.sortedAnswers;
    final isSentence = q.questionType == 'sentence_making';

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel(isSentence ? 'Arrange the words' : 'Build the word'),
          const SizedBox(height: 18),
          Text(
            q.questionTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 82),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(
                color: _questionAnswered
                    ? (_lastAnswerCorrect == true
                        ? AppColors.correctGreen
                        : AppColors.wrongRed)
                    : AppColors.accent,
                width: 1.5,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_selectedTokens.isEmpty)
                    const Text(
                      '____',
                      style: TextStyle(
                        fontSize: 28,
                        color: AppColors.textSecondary,
                        fontFamily: AppTheme.arabicFontFamily,
                      ),
                    ),
                  for (var i = 0; i < _selectedTokens.length; i++)
                    _LetterTile(
                      label: _selectedTokens[i].title,
                      active: true,
                      onTap: _questionAnswered
                          ? null
                          : () => _removeToken(i),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final answer in sorted)
                  _LetterTile(
                    label: answer.title,
                    active: !_usedTokenIds.contains(answer.id),
                    onTap: _questionAnswered || _usedTokenIds.contains(answer.id)
                        ? null
                        : () => _addToken(answer),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToken(LessonAnswer answer) {
    setState(() {
      _usedTokenIds.add(answer.id);
      _selectedTokens.add(answer);
    });
  }

  void _removeToken(int index) {
    setState(() {
      final removed = _selectedTokens.removeAt(index);
      _usedTokenIds.remove(removed.id);
    });
  }

  // ─── PAIR MATCHING ─────────────────────────────────────────────────────
  Widget _buildPairMatchingQuestion(LessonQuestion q) {
    final leftItems = q.answers;
    final rightItems = q.answers.toList()..shuffle();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel('Match the pairs'),
          const SizedBox(height: 18),
          Text(
            q.questionTitle.isNotEmpty
                ? q.questionTitle
                : 'Match Arabic & English',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_matchedPairs.length} of ${q.answers.length} pairs correctly matched',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: leftItems.map((answer) {
                    final isMatched = _matchedPairs.containsKey(answer.id);
                    final isSelected = _selectedLeftId == answer.id;
                    return _MatchTile(
                      label: answer.leftTitle.isNotEmpty
                          ? answer.leftTitle
                          : answer.title,
                      rtl: _isArabicText(
                        answer.leftTitle.isNotEmpty
                            ? answer.leftTitle
                            : answer.title,
                      ),
                      selected: isSelected,
                      matched: isMatched,
                      onTap: isMatched || _questionAnswered
                          ? null
                          : () => setState(() => _selectedLeftId = answer.id),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: rightItems.map((answer) {
                    final isMatched = _matchedPairs.containsValue(answer.id);
                    return _MatchTile(
                      label: answer.rightTitle.isNotEmpty
                          ? answer.rightTitle
                          : answer.title,
                      matched: isMatched,
                      onTap: isMatched || _questionAnswered
                          ? null
                          : () => _tryMatchPair(answer.id),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _tryMatchPair(String rightId) {
    final leftId = _selectedLeftId;
    if (leftId == null) return;

    final question = _currentQuestion;
    final leftAnswer = question.answers.where((a) => a.id == leftId).firstOrNull;
    if (leftAnswer == null) return;

    if (leftId == rightId || leftAnswer.rightTitle == question.answers.where((a) => a.id == rightId).firstOrNull?.rightTitle) {
      setState(() {
        _matchedPairs[leftId] = rightId;
        _selectedLeftId = null;
      });

      if (_matchedPairs.length == question.answers.length) {
        setState(() {
          _questionAnswered = true;
          _lastAnswerCorrect = true;
          _correctAnswers++;
        });
        _feedbackController.forward(from: 0);
      }
    } else {
      if (!_pairPenaltyApplied) {
        _pairPenaltyApplied = true;
        _hasWrongAnswer = true;
        _palmTrees--;
        _reportWrongAnswer();

        if (_palmTrees <= 0) {
          _showOutOfLivesDialog();
          return;
        }
      }
      setState(() => _selectedLeftId = null);
    }
  }

  // ─── SHARED WIDGETS ────────────────────────────────────────────────────

  Widget _buildQuestionLabel(String label) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildImageCard(String imageUrl, {double height = 170}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, a, b) => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_rounded, size: 56, color: AppColors.accent),
            SizedBox(height: 12),
            Text(
              'Image',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackBanner() {
    final isCorrect = _lastAnswerCorrect == true;
    final q = _currentQuestion;

    String feedbackText;
    if (isCorrect) {
      feedbackText = 'Correct!';
    } else if (q.isMcq || q.isFillBlank) {
      final correct = q.correctAnswer;
      feedbackText = correct != null
          ? 'Correct answer: ${correct.title}'
          : 'Incorrect';
    } else if (q.isTrueFalse) {
      feedbackText = q.trueFalseAnswer == true ? 'True' : 'False';
    } else {
      feedbackText = 'Incorrect';
    }

    return AnimatedBuilder(
      animation: _feedbackAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _feedbackAnimation.value) * 20),
          child: Opacity(
            opacity: _feedbackAnimation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCorrect ? AppColors.optionBgCorrect : AppColors.optionBgWrong,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCorrect
                ? AppColors.optionBorderCorrect
                : AppColors.optionBorderWrong,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: isCorrect ? AppColors.success : AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                feedbackText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isCorrect ? AppColors.success : AppColors.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    final q = _currentQuestion;
    final canCheck = _hasAnswer && !_questionAnswered;

    String buttonLabel;
    Color buttonColor;
    VoidCallback? onPressed;

    if (q.isLearn) {
      buttonLabel = 'Continue';
      buttonColor = AppColors.accent;
      onPressed = _handleContinue;
    } else if (_questionAnswered) {
      buttonLabel = 'Continue';
      buttonColor = _lastAnswerCorrect == true
          ? AppColors.success
          : AppColors.accent;
      onPressed = _handleContinue;
    } else {
      buttonLabel = 'Check Answer';
      buttonColor = AppColors.accent;
      onPressed = canCheck ? _handleCheck : null;
    }

    return Padding(
      padding: AppTheme.bottomActionPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: AppTheme.buttonHeight,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.buttonDisabled,
                disabledForegroundColor: AppColors.buttonDisabledText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                ),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          if (!q.isLearn && !_questionAnswered) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _handleContinue,
              child: const Text(
                'Skip',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isArabicText(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);
}

// ─── PRIVATE WIDGETS ────────────────────────────────────────────────────

class _McqOption extends StatelessWidget {
  const _McqOption({
    required this.text,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback? onTap;

  bool get _isArabic => RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  @override
  Widget build(BuildContext context) {
    final color = wrong
        ? AppColors.optionBgWrong
        : correct
        ? AppColors.optionBgCorrect
        : selected
        ? AppColors.optionBgSelected
        : AppColors.card;
    final border = wrong
        ? AppColors.optionBorderWrong
        : correct
        ? AppColors.optionBorderCorrect
        : selected
        ? AppColors.optionBorderSelected
        : AppColors.optionBorderDefault;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: border,
            width: selected || correct || wrong ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: _isArabic ? AppTheme.arabicFontFamily : null,
            fontWeight: FontWeight.w900,
            fontSize: _isArabic ? 18 : 14,
          ),
        ),
      ),
    );
  }
}

class _TrueFalseButton extends StatelessWidget {
  const _TrueFalseButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = wrong
        ? AppColors.optionBgWrong
        : correct
        ? AppColors.optionBgCorrect
        : selected
        ? AppColors.optionBgSelected
        : AppColors.card;
    final border = wrong
        ? AppColors.optionBorderWrong
        : correct
        ? AppColors.optionBorderCorrect
        : selected
        ? AppColors.optionBorderSelected
        : AppColors.optionBorderDefault;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: border,
            width: selected || correct || wrong ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: wrong
                  ? AppColors.wrongRed
                  : correct
                  ? AppColors.correctGreen
                  : selected
                  ? AppColors.accent
                  : AppColors.textPrimary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: wrong
                    ? AppColors.wrongRed
                    : correct
                    ? AppColors.correctGreen
                    : selected
                    ? AppColors.accent
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({required this.label, required this.active, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: active ? 1 : .28,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 58,
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({
    required this.label,
    this.rtl = false,
    this.selected = false,
    this.matched = false,
    this.onTap,
  });

  final String label;
  final bool rtl;
  final bool selected;
  final bool matched;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = matched
        ? AppColors.optionBgCorrect
        : selected
        ? AppColors.optionBgSelected
        : AppColors.card;
    final foreground = selected ? Colors.white : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 58),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: matched
                  ? AppColors.optionBorderCorrect
                  : selected
                  ? AppColors.optionBorderSelected
                  : AppColors.optionBorderDefault,
              width: selected || matched ? 2 : 1,
            ),
          ),
          child: Directionality(
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: rtl ? 18 : 14,
                fontWeight: FontWeight.w800,
                color: matched ? AppColors.success : foreground,
                fontFamily: rtl ? AppTheme.arabicFontFamily : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
