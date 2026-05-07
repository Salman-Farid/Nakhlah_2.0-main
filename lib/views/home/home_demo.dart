import 'package:flutter/material.dart';

class NakhlahHome extends StatefulWidget {
  const NakhlahHome({super.key});

  @override
  State<NakhlahHome> createState() => _NakhlahHomeState();
}

class _NakhlahHomeState extends State<NakhlahHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _animation = Tween<double>(begin: -180, end: 180).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4ECFF),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: child,
            );
          },
          child: Image.asset(
            'assets/nakhlah_web/water_drop_cartoon.png',
            width: 280,
            height: 280,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
