import 'package:flutter/material.dart';

class FadeWidget extends StatelessWidget {
  const FadeWidget({Key key, @required this.child, this.duration})
      : super(key: key);
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration ?? Duration(seconds: 1),
      curve: Curves.easeInToLinear,
      builder: (context, value, _) => Opacity(
        opacity: value,
        child: child,
      ),
    );
  }
}


class ScaleWidget extends StatelessWidget {
  const ScaleWidget({Key key, @required this.child, this.duration})
      : super(key: key);
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration ?? Duration(milliseconds: 300),
      curve: Curves.easeInToLinear,
      builder: (context, value, _) => Transform.scale(
        scale: value,
        child: child,
      ),
    );
  }
}