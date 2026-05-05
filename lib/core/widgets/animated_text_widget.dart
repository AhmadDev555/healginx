import 'package:flutter/material.dart';
import 'package:healginx/styles/app_colors.dart';


class AnimatedTextWidget extends StatelessWidget {
  final String showText;
  final Color? color;

  const AnimatedTextWidget({super.key, required this.showText, this.color});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOut,
      tween: Tween<double>(begin: 0, end: 10),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Text(
            showText,
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.primary,
            ),
          ),
        );
      },
    );
  }
}
