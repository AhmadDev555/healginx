import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  push(Widget widget) {
    navigatorKey.currentState?.push(getRoute(widget));
  }

  pushReplacement(Widget widget) {
    navigatorKey.currentState?.pushReplacement(getRoute(widget));
  }

  pushAndClearStack(Widget widget) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      getRoute(widget),
          (Route<dynamic> route) => false,
    );
  }

  Route getRoute(Widget widget) {
    if (!kIsWeb && Platform.isIOS) {
      // ✅ iOS specific navigation only on mobile
      return CupertinoPageRoute(builder: (context) => widget);
    } else {
      // ✅ Default for Android and Web
      return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
