import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldColor,
    textTheme: TextTheme(
      displayLarge: AppTextTheme.displayLarge,
      displayMedium: AppTextTheme.displayMedium,
      displaySmall: AppTextTheme.displaySmall,
      headlineLarge: AppTextTheme.headLineLarge,
      headlineMedium: AppTextTheme.headLineMedium,
      headlineSmall: AppTextTheme.headLineSmall,
      titleLarge: AppTextTheme.titleLarge,
      titleMedium: AppTextTheme.titleMedium,
      titleSmall: AppTextTheme.titleSmall,
      bodyLarge: AppTextTheme.bodyLarge,
      bodyMedium: AppTextTheme.bodyMedium,
      bodySmall: AppTextTheme.bodySmall,
      labelLarge: AppTextTheme.labelLarge,
      labelMedium: AppTextTheme.labelMedium,
      labelSmall: AppTextTheme.labelSmall,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.scaffoldColor,
      iconTheme:  IconThemeData(color: AppColors.black),
      actionsIconTheme:  IconThemeData(
        color: AppColors.black,
      ),
      titleTextStyle: GoogleFonts.lexend(fontSize: 20, color: AppColors.white),
    ),
  );
}

class AppTextTheme {
  AppTextTheme._();
  //DISPLAY

  static TextStyle get displayLarge {
    return _appFont(
      fontSize: 57,
      weight: FontWeight.w300,
    );
  }

  static TextStyle get displayMedium {
    return _appFont(
      fontSize: 45,
      weight: FontWeight.w400,
    );
  }

  static TextStyle get displaySmall {
    return _appFont(
      fontSize: 36,
      weight: FontWeight.w400,
    );
  } // HEADLINES

  static TextStyle get headLineLarge {
    return _appFont(
      fontSize: 32,
      weight: FontWeight.w400,
    );
  }

  static TextStyle get headLineMedium {
    return _appFont(
      fontSize: 28,
      weight: FontWeight.w400,
    );
  }

  static TextStyle get headLineSmall {
    return _appFont(
      fontSize: 24,
      weight: FontWeight.w400,
    );
  } // TITLE

  static TextStyle get titleLarge {
    return _appFont(
      fontSize: 22,
      weight: FontWeight.w600,
    );
  }

  static TextStyle get titleMedium {
    return _appFont(
      fontSize: 16,
      weight: FontWeight.w500,
    );
  }

  static TextStyle get titleSmall {
    return _appFont(
      fontSize: 14,
      weight: FontWeight.w500,
    );
  }

// BODY
  static TextStyle get bodyLarge {
    return _appFont(fontSize: 16, weight: FontWeight.w400);
  }

  static TextStyle get bodyMedium {
    return _appFont(fontSize: 14, weight: FontWeight.w400);
  }

  static TextStyle get bodySmall {
    return _appFont(fontSize: 12, weight: FontWeight.w400);
  }

//LABEL

  static TextStyle get labelLarge {
    return _appFont(fontSize: 14, weight: FontWeight.w500);
  }

  static TextStyle get labelMedium {
    return _appFont(fontSize: 12, weight: FontWeight.w500);
  }

  static TextStyle get labelSmall {
    return _appFont(fontSize: 11, weight: FontWeight.w500);
  }

  static TextStyle _appFont(
      {required int fontSize, required FontWeight weight}) {
    return GoogleFonts.lexend(
        fontSize: fontSize.toDouble(),
        fontWeight: weight,
        // color: AppColors.primary
    );
  }
}
