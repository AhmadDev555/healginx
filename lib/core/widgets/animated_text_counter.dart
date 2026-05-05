import 'package:flutter/material.dart';

class AnimatedTextCounter extends StatelessWidget {
  final int targetNumber;
  final Duration duration;

  const AnimatedTextCounter({
    Key? key,
    required this.targetNumber,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: targetNumber),
      duration: duration,
      builder: (context, value, child) {
        return Text(
          value.toString(),
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
