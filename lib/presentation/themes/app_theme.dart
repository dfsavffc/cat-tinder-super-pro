import 'package:flutter/material.dart';

abstract class AppColors {
  static const backgroundDark = Color(0xFF232323);
  static const primaryDark = Color(0xFF3e3e3e);
  static const textDark = Color(0xFFFDFEFF);
  static const badgeDark = Color(0xFFff7072);

  static const backgroundLight = Color(0xFFFDFEFF);
  static const primaryLight = Color(0xFFe2e2e2);
  static const textLight = Color(0xFF303030);
  static const badgeLight = Color(0xFFff7072);

  static const error = Colors.redAccent;
}

abstract class AppTextStyles {
  static const _font = 'Montserrat';

  static const headline = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static const title = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static const body = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.normal,
    fontSize: 18,
  );

  static const label = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.backgroundDark,
      primary: AppColors.primaryDark,
      error: AppColors.error,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      toolbarHeight: 72,
      elevation: 0,
      titleTextStyle: AppTextStyles.headline.copyWith(
        color: AppColors.textDark,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    ),

    iconTheme: const IconThemeData(size: 28),

    textTheme: TextTheme(
      headlineSmall: AppTextStyles.headline.copyWith(color: AppColors.textDark),
      titleMedium: AppTextStyles.title.copyWith(color: AppColors.textDark),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.textDark),
      labelLarge: AppTextStyles.label.copyWith(color: AppColors.textDark),
      bodySmall: AppTextStyles.body.copyWith(
        color: AppColors.textDark,
        fontSize: 14,
      ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.backgroundDark,
      modalBackgroundColor: AppColors.backgroundDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
    ),
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      surface: AppColors.backgroundLight,
      primary: AppColors.primaryLight,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryLight,
      toolbarHeight: 72,
      elevation: 0,
      titleTextStyle: AppTextStyles.headline.copyWith(
        color: AppColors.textLight,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    ),
    iconTheme: const IconThemeData(size: 28),
    textTheme: TextTheme(
      headlineSmall: AppTextStyles.headline.copyWith(
        color: AppColors.textLight,
      ),
      titleMedium: AppTextStyles.title.copyWith(color: AppColors.textLight),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.textLight),
      labelLarge: AppTextStyles.label.copyWith(color: AppColors.textLight),
      bodySmall: AppTextStyles.body.copyWith(
        color: AppColors.textLight,
        fontSize: 14,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.backgroundLight,
      modalBackgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
    ),
  );

  static Color badgeBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.badgeDark
          : AppColors.badgeLight;
}
