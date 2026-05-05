import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension NavigationExtension on Widget {
  void push(BuildContext context) {
    Navigator.of(context).push(_handleRoute(context, this));
  }

  void pushReplacement(BuildContext context) {
    Navigator.of(context).pushReplacement(_handleRoute(context, this));
  }

  void pushAndRemoveUntil(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(_handleRoute(context, this), (_) => false);
  }

}


PageRoute _handleRoute(BuildContext context, Widget widget) {
  if(Platform.isIOS) {
    return CupertinoPageRoute(builder: (context) => widget) ;
  }
  else {
    return MaterialPageRoute(builder: (context) => widget) ;
  }
}
