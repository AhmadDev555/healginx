import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:healginx/core/navigation_service.dart';
import 'package:healginx/injection_container.dart';
import 'package:healginx/styles/app_colors.dart';
import 'package:intl/intl.dart';


class Utils{


  static BoxDecoration buildBoxDecoration(
      {required Color color,
        required double radius
      }) {
    return BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.borderColor, width: 1.0),
        borderRadius:  BorderRadius.all(Radius.circular(radius)));
  }

  static void unfocusScreen(BuildContext context) {
    FocusScope.of(context).unfocus() ;
  }

  static String getFormattedDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
    return formattedDate;
  }

  static String getFormattedDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
    final date = '$formattedDate $formattedTime';
    return date;
  }



  static String getFormattedTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
    return formattedTime;
  }

 static showSuccessBar(String message){

    sl<NavigationService>().navigatorKey.currentState?.context.showSuccessBar(
        content:  Text(
          message,
        ),
        indicatorColor: AppColors.green);

  }

  static showErrorBar(String message){

    sl<NavigationService>().navigatorKey.currentState?.context.showSuccessBar(
        content:  Text(
          message,
        ),
        indicatorColor: AppColors.errorToastColor);

  }

  // static showToast(String message, bool isError) {
  //   Fluttertoast.showToast(
  //       msg: message,
  //       backgroundColor: isError ? AppColors.errorToastColor : AppColors.successToastColor
  //   );
  //
  // }



}