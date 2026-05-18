import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/nakhlah_intro_widgets.dart';
import '../../constants/app_colors.dart';
import '../../common/app_motion.dart';
import '../../controllers/profile_controller.dart';
import '../../models/models.dart';
import '../../routes/app_routes.dart';

class OnboardingFormView extends StatefulWidget {
  const OnboardingFormView({super.key});

  @override
  State<OnboardingFormView> createState() => _OnboardingFormViewState();
}

class _OnboardingFormViewState extends State<OnboardingFormView> {
  final _pageController = PageController();
  int _step = 0;

  // ── field controllers ────────────────────────
  final age = TextEditingController(text: '30 - 35');
  final country = TextEditingController(text: 'Bangladesh');
  final purpose = TextEditingController(text: 'Learning');
  final goal = TextEditingController(text: '10');
  final source = TextEditingController(text: 'facebook');
  final strength = TextEditingController(text: 'Basic');

  @override
  void dispose() {
    age.dispose();
    country.dispose();
    purpose.dispose();
    goal.dispose();
    source.dispose();
    strength.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _back() {
    if (_step > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _submit(ProfileController c) async {
    final created = await c.createOnboarding(
      OnboardInfo(
        age: age.text,
        country: country.text,
        purpose: purpose.text,
        goalTime: int.tryParse(goal.text) ?? 10,
        userSource: source.text,
        languageStrength: strength.text,
      ),
    );
    if (created) Get.offAllNamed(Routes.shell);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();

    return IntroScaffold(
      showBack: _step > 0,
      child: Column(
        children: [
          // ── top back row ─────────────────────────────
          AnimatedOpacity(
            opacity: _step > 0 ? 1.0 : 0.0,
            duration: AppMotion.fast,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _step > 0 ? _back : null,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.palmDark,
                  textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // ── step progress bar ─────────────────────────
          _StepProgressBar(currentStep: _step, totalSteps: 2),
          const SizedBox(height: 4),
          // ── page view ────────────────────────────────
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (v) => setState(() => _step = v),
              children: [
                _Step1AboutYou(
                  age: age,
                  country: country,
                  strength: strength,
                  onNext: _next,
                ),
                _Step2Goals(
                  purpose: purpose,
                  goal: goal,
                  source: source,
                  c: c,
                  onSubmit: _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Step progress indicator
// ─────────────────────────────────────────────

class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar({required this.currentStep, required this.totalSteps});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(totalSteps, (i) {
          final done = i < currentStep;
          final active = i == currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
              child: AnimatedContainer(
                duration: AppMotion.normal,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: done || active
                      ? AppColors.palm
                      : AppColors.palm.withValues(alpha: .15),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Step 1 – About you
// ─────────────────────────────────────────────

class _Step1AboutYou extends StatelessWidget {
  const _Step1AboutYou({
    required this.age,
    required this.country,
    required this.strength,
    required this.onNext,
  });

  final TextEditingController age;
  final TextEditingController country;
  final TextEditingController strength;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: Column(
        children: [
          const IntroHeroImage(asset: IntroAssets.journeyMarker, height: 160),
          const SizedBox(height: 10),
          const IntroTitleBlock(
            title: 'Tell Us\nAbout You',
            body:
                'A few quick answers help us personalise your Arabic journey.',
            titleSize: 30,
            align: TextAlign.left,
          ),
          const SizedBox(height: 18),
          const ProcessStepCard(
            number: '01',
            title: 'About you',
            body: 'Age range, country, and your current Arabic level.',
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 18),
          AuthPanel(
            children: [
              IntroTextField(
                controller: age,
                label: 'Age range',
                icon: Icons.cake_rounded,
              ),
              const SizedBox(height: 14),
              IntroTextField(
                controller: country,
                label: 'Country',
                icon: Icons.public_rounded,
              ),
              const SizedBox(height: 14),
              IntroTextField(
                controller: strength,
                label: 'Arabic level',
                icon: Icons.auto_awesome_rounded,
              ),
              const SizedBox(height: 20),
              IntroPrimaryButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Step 2 – Goals
// ─────────────────────────────────────────────

class _Step2Goals extends StatelessWidget {
  const _Step2Goals({
    required this.purpose,
    required this.goal,
    required this.source,
    required this.c,
    required this.onSubmit,
  });

  final TextEditingController purpose;
  final TextEditingController goal;
  final TextEditingController source;
  final ProfileController c;
  final Future<void> Function(ProfileController) onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: Column(
        children: [
          const IntroHeroImage(
            asset: IntroAssets.lessonCards,
            height: 160,
            blobColor: AppColors.date,
          ),
          const SizedBox(height: 10),
          const IntroTitleBlock(
            title: 'Set Your\nGoals',
            body:
                'We\'ll build a custom path around your daily learning habit.',
            titleSize: 30,
            align: TextAlign.left,
          ),
          const SizedBox(height: 18),
          const ProcessStepCard(
            number: '02',
            title: 'Daily goal',
            body: 'Set a small habit you can keep every single day.',
            icon: Icons.flag_rounded,
          ),
          const SizedBox(height: 18),
          // goal time quick picks
          _GoalPicker(controller: goal),
          const SizedBox(height: 18),
          AuthPanel(
            children: [
              IntroTextField(
                controller: purpose,
                label: 'Purpose for learning',
                icon: Icons.menu_book_rounded,
              ),
              const SizedBox(height: 14),
              IntroTextField(
                controller: source,
                label: 'How did you hear about us?',
                icon: Icons.campaign_rounded,
              ),
              const SizedBox(height: 20),
              Obx(
                () => IntroPrimaryButton(
                  label: 'Start Learning  🎉',
                  loading: c.loading.value,
                  onPressed: () => onSubmit(c),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'You can update all of this later from your profile.',
            style: TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Quick goal-time picker chips
// ─────────────────────────────────────────────

class _GoalPicker extends StatefulWidget {
  const _GoalPicker({required this.controller});
  final TextEditingController controller;

  @override
  State<_GoalPicker> createState() => _GoalPickerState();
}

class _GoalPickerState extends State<_GoalPicker> {
  final _options = const [5, 10, 15, 20];
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily learning goal',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _options.map((min) {
            final isSelected = _selected == min;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selected = min);
                    widget.controller.text = '$min';
                  },
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.palm
                          : const Color(0xFFF5FAF7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.palm
                            : AppColors.palm.withValues(alpha: .12),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$min',
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'min',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white.withValues(alpha: .80)
                                : AppColors.muted,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
