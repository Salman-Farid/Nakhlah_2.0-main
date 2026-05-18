import 'package:flutter/material.dart';
import 'app_motion.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      scale: .98,
      child: ElevatedButton.icon(
        onPressed: loading ? null : onPressed,
        icon: AnimatedSwitcher(
          duration: AppMotion.fast,
          child: loading
              ? const SizedBox(
                  key: ValueKey('loader'),
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  icon ?? Icons.arrow_forward_rounded,
                  key: const ValueKey('icon'),
                ),
        ),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
