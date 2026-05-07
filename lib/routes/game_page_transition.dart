import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/app_motion.dart';

class GamePageTransition extends CustomTransition {
  GamePageTransition();

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (AppMotion.reduceMotion(context)) return child;

    final enter = CurvedAnimation(parent: animation, curve: const Interval(.02, 1, curve: AppMotion.out));
    // TweenSequence asserts when its input falls outside 0..1. Spring-like
    // curves can intentionally overshoot, so keep the scale sequence on a
    // clamped/linear progress while allowing the slide to retain the spring feel.
    final safeScaleProgress = CurvedAnimation(parent: animation, curve: const Interval(.02, 1, curve: Curves.linear));
    final fade = CurvedAnimation(parent: animation, curve: const Interval(0, .36, curve: AppMotion.out));
    final exit = CurvedAnimation(parent: secondaryAnimation, curve: AppMotion.inOut);

    final incomingSlide = Tween<Offset>(begin: const Offset(0.035, 0.012), end: Offset.zero).animate(enter);
    final incomingScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: .97, end: 1.006).chain(CurveTween(curve: AppMotion.out)), weight: 55),
      TweenSequenceItem(tween: Tween<double>(begin: 1.006, end: 1).chain(CurveTween(curve: Curves.easeOut)), weight: 45),
    ]).animate(safeScaleProgress);
    final incomingOpacity = Tween<double>(begin: 0, end: 1).animate(fade);

    final outgoingScale = Tween<double>(begin: 1, end: 0.975).animate(exit);
    final outgoingOpacity = Tween<double>(begin: 1, end: 0.72).animate(exit);

    return FadeTransition(
      opacity: outgoingOpacity,
      child: ScaleTransition(
        scale: outgoingScale,
        child: FadeTransition(
          opacity: incomingOpacity,
          child: SlideTransition(
            position: incomingSlide,
            child: ScaleTransition(
              scale: incomingScale,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
