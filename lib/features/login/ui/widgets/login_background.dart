import 'dart:math';

import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      // Keep Positioned directly under Stack
      child: Transform.rotate(
        angle: pi,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/login_background.png',
              ),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low, // Optimized raster
            ),
          ),
          child: RepaintBoundary(), // Add RepaintBoundary INSIDE if desired
        ),
      ),
    );
  }
}