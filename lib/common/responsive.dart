import 'package:flutter/widgets.dart';
import 'app_motion.dart';

class Responsive {
  static double pagePadding(BuildContext context) => MediaQuery.sizeOf(context).width < 380 ? 16 : 20;
  static double maxContentWidth = 720;
}

class PageShell extends StatelessWidget {
  const PageShell({super.key, required this.child, this.padding, this.animate = true});
  final Widget child;
  final EdgeInsets? padding;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: Padding(padding: padding ?? EdgeInsets.all(Responsive.pagePadding(context)), child: child),
      ),
    );
    return animate ? PageEnter(child: content) : content;
  }
}
