import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  static const _codeLength = 4;
  static const _timerSeconds = 120;

  final List<TextEditingController> _controllers =
      List.generate(_codeLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_codeLength, (_) => FocusNode());

  Timer? _timer;
  int _remaining = _timerSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remaining = _timerSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 0) {
        t.cancel();
      } else {
        setState(() => _remaining--);
      }
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  bool get _isComplete => _code.length == _codeLength;

  String get _timerDisplay {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyPressed(String digit) {
    final emptyIndex = _controllers.indexWhere((c) => c.text.isEmpty);
    if (emptyIndex == -1) return;
    _controllers[emptyIndex].text = digit;
    _onChanged(emptyIndex, digit);
  }

  void _onDelete() {
    final lastFilledIndex =
        _controllers.lastIndexWhere((c) => c.text.isNotEmpty);
    if (lastFilledIndex == -1) return;
    _controllers[lastFilledIndex].clear();
    _onChanged(lastFilledIndex, '');
  }

  void _onConfirm() {
    if (!_isComplete) return;
    Get.toNamed(Routes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar with back button ───────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: Get.back,
                  ),
                ],
              ),
            ),

            // ── Scrollable content ─────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // ── Mail icon ──────────────────────
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: .10),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: .18),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.mail_outline_rounded,
                        color: AppColors.accent,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Header ─────────────────────────
                    const Text(
                      'You have got mail \u{1F4EC}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We have sent the OTP verification code to your email address. Check your email and enter the code below',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── OTP input boxes ────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_codeLength, (i) {
                        final hasValue = _controllers[i].text.isNotEmpty;
                        final isFocused =
                            _focusNodes[i].hasFocus || (!hasValue && i == _controllers.indexWhere((c) => c.text.isEmpty));
                        return Container(
                          width: 64,
                          height: 64,
                          margin: EdgeInsets.only(
                            right: i < _codeLength - 1 ? 12 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isFocused
                                  ? AppColors.accent
                                  : AppColors.border,
                              width: isFocused ? 2 : 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (v) => _onChanged(i, v),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // ── Timer / Resend ─────────────────
                    if (_remaining > 0)
                      Text(
                        'You can resend code in $_timerDisplay',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Did not receive email? ',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: _startTimer,
                            child: const Text(
                              'Resend',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),

                    // ── Number pad dialer ──────────────
                    _buildNumberPad(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Confirm button (fixed bottom) ─────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isComplete ? _onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.disabled,
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    const digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return SizedBox(
      width: 280,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.6,
        ),
        itemCount: digits.length,
        itemBuilder: (context, index) {
          final digit = digits[index];
          if (digit.isEmpty) return const SizedBox.shrink();
          final isDelete = digit == '⌫';
          return Material(
            color: isDelete
                ? AppColors.destructive.withValues(alpha: .08)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                HapticFeedback.lightImpact();
                if (isDelete) {
                  _onDelete();
                } else {
                  _onKeyPressed(digit);
                }
              },
              child: Center(
                child: isDelete
                    ? const Icon(
                        Icons.backspace_outlined,
                        color: AppColors.destructive,
                        size: 22,
                      )
                    : Text(
                        digit,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Circular icon button (back arrow)
// ─────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      scale: .9,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.border,
              width: 1.2,
            ),
          ),
          child: Icon(icon, size: 18, color: AppColors.ink),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PressableScale (local copy to avoid import)
// ─────────────────────────────────────────────

class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.scale = .97,
    this.onTap,
  });

  final Widget child;
  final double scale;
  final VoidCallback? onTap;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    lowerBound: 0,
    upperBound: 1,
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: _ctrl.reverse,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) {
          final s = 1 - (1 - widget.scale) * _ctrl.value;
          return Transform.scale(scale: s, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
