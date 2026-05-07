import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 460);
  static const page = Duration(milliseconds: 820);
  static const stagger = Duration(milliseconds: 155);

  static const Curve out = Cubic(0.16, 1, 0.3, 1);
  static const Curve inOut = Cubic(0.77, 0, 0.175, 1);
  static const Curve liquid = Cubic(0.18, 1.42, 0.22, 1);
  static const Curve playful = Cubic(0.16, 1.36, 0.24, 1);
  static const Curve macosSpring = Cubic(0.16, 1.28, 0.24, 1);

  static bool reduceMotion(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    return media?.disableAnimations == true || media?.accessibleNavigation == true;
  }
}

class PageEnter extends StatefulWidget {
  const PageEnter({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slide = const Offset(0, .12),
    this.beginScale = .86,
    this.duration = AppMotion.page,
    this.curve = AppMotion.playful,
  });

  final Widget child;
  final Duration delay;
  final Offset slide;
  final double beginScale;
  final Duration duration;
  final Curve curve;

  @override
  State<PageEnter> createState() => _PageEnterState();
}

class _PageEnterState extends State<PageEnter> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final liquidSlide = CurvedAnimation(
      parent: _controller,
      curve: Interval(.04, 1, curve: widget.curve),
    );
    final safeScaleProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(.04, 1, curve: Curves.linear),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, .34, curve: AppMotion.out)),
    );
    _slide = Tween<Offset>(begin: widget.slide, end: Offset.zero).animate(liquidSlide);
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: widget.beginScale, end: 1.045).chain(CurveTween(curve: AppMotion.out)), weight: 42),
      TweenSequenceItem(tween: Tween<double>(begin: 1.045, end: .985).chain(CurveTween(curve: Curves.easeInOut)), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: .985, end: 1).chain(CurveTween(curve: AppMotion.out)), weight: 38),
    ]).animate(safeScaleProgress);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant PageEnter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child.key != widget.child.key) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduceMotion(context)) return widget.child;
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}

class StaggeredList extends StatelessWidget {
  const StaggeredList({super.key, required this.children, this.baseDelay = Duration.zero, this.gap = 0});
  final List<Widget> children;
  final Duration baseDelay;
  final double gap;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            PageEnter(
              delay: baseDelay + Duration(milliseconds: AppMotion.stagger.inMilliseconds * i),
              duration: AppMotion.page + Duration(milliseconds: i * 18),
              child: children[i],
            ),
            if (gap > 0 && i != children.length - 1) SizedBox(height: gap),
          ],
        ],
      );
}

class GameListView extends StatelessWidget {
  const GameListView({
    super.key,
    required this.children,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.baseDelay = Duration.zero,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Duration baseDelay;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: [
        for (var i = 0; i < children.length; i++)
          PageEnter(
            delay: baseDelay + Duration(milliseconds: AppMotion.stagger.inMilliseconds * i),
            duration: AppMotion.page + Duration(milliseconds: i * 18),
            child: children[i],
          ),
      ],
    );
  }
}

class GameColumn extends StatelessWidget {
  const GameColumn({super.key, required this.children, this.crossAxisAlignment = CrossAxisAlignment.center, this.mainAxisSize = MainAxisSize.max});
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: [
          for (var i = 0; i < children.length; i++)
            PageEnter(
              delay: Duration(milliseconds: AppMotion.stagger.inMilliseconds * i),
              duration: AppMotion.page + Duration(milliseconds: i * 18),
              child: children[i],
            ),
        ],
      );
}

class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child, this.scale = .96});
  final Widget child;
  final double scale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;
  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduceMotion(context)) return widget.child;
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1,
        duration: AppMotion.fast,
        curve: AppMotion.liquid,
        child: widget.child,
      ),
    );
  }
}

class PopIn extends StatelessWidget {
  const PopIn({super.key, required this.child, this.delay = Duration.zero});
  final Widget child;
  final Duration delay;
  @override
  Widget build(BuildContext context) => PageEnter(delay: delay, child: child);
}
