import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/app_button.dart';
import '../../constants/app_colors.dart';

const _lessonMaxWidth = 430.0;

enum ArabicExerciseType { learn, multipleChoice, textArrangement, matching }

class ArabicOption {
  const ArabicOption({required this.id, required this.label, this.arabic});

  final String id;
  final String label;
  final String? arabic;
}

class ArabicMatchPair {
  const ArabicMatchPair({
    required this.arabicId,
    required this.arabic,
    required this.englishId,
    required this.english,
  });

  final String arabicId;
  final String arabic;
  final String englishId;
  final String english;
}

class ArabicExerciseData {
  const ArabicExerciseData({
    required this.type,
    required this.title,
    this.arabicText = '',
    this.transliteration = '',
    this.english = '',
    this.image = '',
    this.question = '',
    this.options = const [],
    this.correctAnswer = '',
    this.matchPairs = const [],
    this.letterTiles = const [],
  });

  final ArabicExerciseType type;
  final String title;
  final String arabicText;
  final String transliteration;
  final String english;
  final String image;
  final String question;
  final List<ArabicOption> options;
  final String correctAnswer;
  final List<ArabicMatchPair> matchPairs;
  final List<String> letterTiles;
}

class ExerciseView extends StatelessWidget {
  const ExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments is ArabicExerciseData
        ? Get.arguments as ArabicExerciseData
        : _fallbackExercise;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _lessonMaxWidth),
            child: ExerciseRenderer(
              data: data,
              onContinue: () => Get.back(result: true),
              onSkip: () => Get.back(result: true),
              onComplete: () => Get.back(result: true),
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseRenderer extends StatefulWidget {
  const ExerciseRenderer({
    super.key,
    required this.data,
    required this.onContinue,
    required this.onSkip,
    required this.onComplete,
  });

  final ArabicExerciseData data;
  final VoidCallback onContinue;
  final VoidCallback onSkip;
  final VoidCallback onComplete;

  @override
  State<ExerciseRenderer> createState() => _ExerciseRendererState();
}

class _ExerciseRendererState extends State<ExerciseRenderer> {
  String? selectedOptionId;
  final List<_LetterSelection> answerLetters = [];
  final Set<int> usedLetterIndexes = {};
  String? selectedArabicId;
  final Map<String, String> matchedPairs = {};

  @override
  void didUpdateWidget(covariant ExerciseRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      selectedOptionId = null;
      answerLetters.clear();
      usedLetterIndexes.clear();
      selectedArabicId = null;
      matchedPairs.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.data.type) {
      ArabicExerciseType.learn => _LearnExercise(
        data: widget.data,
        onContinue: widget.onContinue,
        onSkip: widget.onSkip,
      ),
      ArabicExerciseType.multipleChoice => _MultipleChoiceExercise(
        data: widget.data,
        selectedOptionId: selectedOptionId,
        onSelect: (id) => setState(() => selectedOptionId = id),
        onCheck: selectedOptionId == null ? null : widget.onComplete,
      ),
      ArabicExerciseType.textArrangement => _TextArrangementExercise(
        data: widget.data,
        answerLetters: answerLetters,
        usedLetterIndexes: usedLetterIndexes,
        onTapTile: _tapLetterTile,
        onRemoveAnswer: _removeAnswerLetter,
        onCheck: _arrangedAnswer.isEmpty ? null : _checkArrangement,
      ),
      ArabicExerciseType.matching => _MatchingExercise(
        data: widget.data,
        selectedArabicId: selectedArabicId,
        matchedPairs: matchedPairs,
        onTapArabic: (id) => setState(() => selectedArabicId = id),
        onTapEnglish: _tapEnglishMatch,
        onCheck: matchedPairs.length == widget.data.matchPairs.length
            ? widget.onComplete
            : null,
      ),
    };
  }

  String get _arrangedAnswer => answerLetters.map((e) => e.value).join();

  void _tapLetterTile(int index, String value) {
    if (usedLetterIndexes.contains(index)) return;
    setState(() {
      usedLetterIndexes.add(index);
      answerLetters.add(_LetterSelection(index, value));
    });
  }

  void _removeAnswerLetter(int answerIndex) {
    setState(() {
      final removed = answerLetters.removeAt(answerIndex);
      usedLetterIndexes.remove(removed.tileIndex);
    });
  }

  void _checkArrangement() {
    if (_arrangedAnswer == widget.data.correctAnswer) {
      widget.onComplete();
      return;
    }
    _showError('Try again');
    setState(() {
      answerLetters.clear();
      usedLetterIndexes.clear();
    });
  }

  void _tapEnglishMatch(String englishId) {
    final arabicId = selectedArabicId;
    if (arabicId == null || matchedPairs.containsKey(arabicId)) return;

    final isCorrect = widget.data.matchPairs.any(
      (pair) => pair.arabicId == arabicId && pair.englishId == englishId,
    );

    if (isCorrect) {
      setState(() {
        matchedPairs[arabicId] = englishId;
        selectedArabicId = null;
      });
    } else {
      _showError('Not a match — try another pair');
      setState(() => selectedArabicId = null);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
      ),
    );
  }
}

class _LearnExercise extends StatelessWidget {
  const _LearnExercise({
    required this.data,
    required this.onContinue,
    required this.onSkip,
  });

  final ArabicExerciseData data;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return _ExerciseScaffold(
      title: data.title,
      child: Column(
        children: [
          _ImageCard(label: data.image),
          const SizedBox(height: 24),
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
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    data.arabicText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.transliteration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.english,
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
          const Spacer(),
          AppButton.continueButton(onPressed: onContinue),
          const SizedBox(height: 12),
          AppButton.skip(onPressed: onSkip),
        ],
      ),
    );
  }
}

class _MultipleChoiceExercise extends StatelessWidget {
  const _MultipleChoiceExercise({
    required this.data,
    required this.selectedOptionId,
    required this.onSelect,
    required this.onCheck,
  });

  final ArabicExerciseData data;
  final String? selectedOptionId;
  final ValueChanged<String> onSelect;
  final VoidCallback? onCheck;

  @override
  Widget build(BuildContext context) {
    return _ExerciseScaffold(
      title: data.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _ImageCard(label: data.image),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.25,
              physics: const NeverScrollableScrollPhysics(),
              children: data.options
                  .map(
                    (option) => AppButton.option(
                      label: option.arabic == null
                          ? option.label
                          : '${option.arabic}\n${option.label}',
                      selected: selectedOptionId == option.id,
                      onPressed: () => onSelect(option.id),
                    ),
                  )
                  .toList(),
            ),
          ),
          AppButton.checkAnswer(onPressed: onCheck),
        ],
      ),
    );
  }
}

class _TextArrangementExercise extends StatelessWidget {
  const _TextArrangementExercise({
    required this.data,
    required this.answerLetters,
    required this.usedLetterIndexes,
    required this.onTapTile,
    required this.onRemoveAnswer,
    required this.onCheck,
  });

  final ArabicExerciseData data;
  final List<_LetterSelection> answerLetters;
  final Set<int> usedLetterIndexes;
  final void Function(int index, String value) onTapTile;
  final ValueChanged<int> onRemoveAnswer;
  final VoidCallback? onCheck;

  @override
  Widget build(BuildContext context) {
    return _ExerciseScaffold(
      title: data.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 82),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < answerLetters.length; i++)
                    _LetterTile(
                      label: answerLetters[i].value,
                      active: true,
                      onTap: () => onRemoveAnswer(i),
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
                for (var i = 0; i < data.letterTiles.length; i++)
                  _LetterTile(
                    label: data.letterTiles[i],
                    active: !usedLetterIndexes.contains(i),
                    onTap: usedLetterIndexes.contains(i)
                        ? null
                        : () => onTapTile(i, data.letterTiles[i]),
                  ),
              ],
            ),
          ),
          const Spacer(),
          AppButton.checkAnswer(onPressed: onCheck),
        ],
      ),
    );
  }
}

class _MatchingExercise extends StatelessWidget {
  const _MatchingExercise({
    required this.data,
    required this.selectedArabicId,
    required this.matchedPairs,
    required this.onTapArabic,
    required this.onTapEnglish,
    required this.onCheck,
  });

  final ArabicExerciseData data;
  final String? selectedArabicId;
  final Map<String, String> matchedPairs;
  final ValueChanged<String> onTapArabic;
  final ValueChanged<String> onTapEnglish;
  final VoidCallback? onCheck;

  @override
  Widget build(BuildContext context) {
    return _ExerciseScaffold(
      title: data.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: data.matchPairs
                        .map(
                          (pair) => _MatchTile(
                            label: pair.arabic,
                            rtl: true,
                            selected: selectedArabicId == pair.arabicId,
                            matched: matchedPairs.containsKey(pair.arabicId),
                            onTap: matchedPairs.containsKey(pair.arabicId)
                                ? null
                                : () => onTapArabic(pair.arabicId),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: data.matchPairs
                        .map(
                          (pair) => _MatchTile(
                            label: pair.english,
                            matched: matchedPairs.containsValue(pair.englishId),
                            onTap: matchedPairs.containsValue(pair.englishId)
                                ? null
                                : () => onTapEnglish(pair.englishId),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          AppButton.checkAnswer(onPressed: onCheck),
        ],
      ),
    );
  }
}

class _ExerciseScaffold extends StatelessWidget {
  const _ExerciseScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_rounded, size: 56, color: AppColors.primary),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
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
        ? AppColors.successLight
        : selected
        ? AppColors.primary
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
                  ? AppColors.success
                  : selected
                  ? AppColors.primary
                  : AppColors.border,
              width: selected || matched ? 2 : 1,
            ),
          ),
          child: Directionality(
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: rtl ? 20 : 15,
                fontWeight: FontWeight.w800,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LetterSelection {
  const _LetterSelection(this.tileIndex, this.value);

  final int tileIndex;
  final String value;
}

const _fallbackExercise = ArabicExerciseData(
  type: ArabicExerciseType.learn,
  title: 'Learn',
  arabicText: 'السلام عليكم',
  transliteration: 'Assalamu Alaykum',
  english: 'Peace be upon you',
  image: 'Two friends greeting each other',
);
