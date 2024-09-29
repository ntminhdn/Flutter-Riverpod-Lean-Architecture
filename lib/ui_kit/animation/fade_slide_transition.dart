import 'package:flutter/material.dart';

import '../../index.dart';

class FadeSlideTransition extends StatelessWidget {
  FadeSlideTransition({
    required this.animation,
    super.key,
    this.child,
    this.slideDirection = SlideAnimDirection.down,
    this.slideDistance = 0.2,
  });

  final Animation<double> animation;
  final Widget? child;
  final SlideAnimDirection slideDirection;
  final double slideDistance;

  late final Animatable<double> _fadeInTransition = CurveTween(
    curve: const Interval(0.0, 0.3),
  );

  late final Animatable<Offset> _slideInTransition = Tween<Offset>(
    begin: Offset(_dx, _dy),
    end: Offset.zero,
  ).chain(CurveTween(curve: Easing.legacyDecelerate));

  static final Animatable<double> _fadeOutTransition = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );

  double get _dy {
    switch (slideDirection) {
      case SlideAnimDirection.rightToLeft:
      case SlideAnimDirection.leftToRight:
        return 0;
      case SlideAnimDirection.down:
        return -slideDistance;
      case SlideAnimDirection.up:
        return slideDistance;
    }
  }

  double get _dx {
    switch (slideDirection) {
      case SlideAnimDirection.rightToLeft:
        return -slideDistance;
      case SlideAnimDirection.leftToRight:
        return slideDistance;
      case SlideAnimDirection.down:
      case SlideAnimDirection.up:
        return 0;
    }
  }

  bool get isVertical =>
      slideDirection == SlideAnimDirection.up || slideDirection == SlideAnimDirection.down;

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return FadeTransition(
          opacity: _fadeInTransition.animate(animation),
          child: SlideTransition(
            position: _slideInTransition.animate(animation),
            child: child,
          ),
        );
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return FadeTransition(
          opacity: _fadeOutTransition.animate(animation),
          child: child,
        );
      },
      child: child,
    );
  }
}
