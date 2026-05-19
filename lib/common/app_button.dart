import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_motion.dart';

enum AppButtonKind {
  continueButton,
  skip,
  checkAnswer,
  option,
  successContinue,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.kind = AppButtonKind.continueButton,
    this.selected = false,
    this.correct = false,
  });

  const AppButton.continueButton({
    super.key,
    this.label = 'Continue',
    required this.onPressed,
    this.loading = false,
    this.icon = Icons.arrow_forward_rounded,
  }) : kind = AppButtonKind.continueButton,
       selected = false,
       correct = false;

  const AppButton.skip({
    super.key,
    this.label = 'Skip',
    required this.onPressed,
    this.loading = false,
    this.icon,
  }) : kind = AppButtonKind.skip,
       selected = false,
       correct = false;

  const AppButton.checkAnswer({
    super.key,
    this.label = 'Check Answer',
    required this.onPressed,
    this.loading = false,
    this.icon = Icons.check_rounded,
  }) : kind = AppButtonKind.checkAnswer,
       selected = false,
       correct = false;

  const AppButton.option({
    super.key,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.correct = false,
    this.loading = false,
    this.icon,
  }) : kind = AppButtonKind.option;

  const AppButton.successContinue({
    super.key,
    this.label = 'Continue',
    required this.onPressed,
    this.loading = false,
    this.icon = Icons.arrow_forward_rounded,
  }) : kind = AppButtonKind.successContinue,
       selected = false,
       correct = true;

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final AppButtonKind kind;
  final bool selected;
  final bool correct;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final style = _style();
    final showIcon = icon != null && kind != AppButtonKind.option;

    return PressableScale(
      scale: _enabled ? .98 : 1,
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: style,
          child: AnimatedSwitcher(
            duration: AppMotion.fast,
            child: loading
                ? const SizedBox(
                    key: ValueKey('loader'),
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    key: const ValueKey('content'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (showIcon) ...[
                        const SizedBox(width: 8),
                        Icon(icon, size: 20),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  ButtonStyle _style() {
    switch (kind) {
      case AppButtonKind.skip:
        return ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textSecondary,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: AppColors.disabled,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.border),
          ),
        );
      case AppButtonKind.checkAnswer:
        return ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        );
      case AppButtonKind.option:
        return ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: selected ? AppColors.primary : AppColors.card,
          foregroundColor: selected ? Colors.white : AppColors.textPrimary,
          disabledBackgroundColor: AppColors.card,
          disabledForegroundColor: AppColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 2 : 1,
            ),
          ),
        );
      case AppButtonKind.successContinue:
        return ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        );
      case AppButtonKind.continueButton:
        return ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        );
    }
  }
}
