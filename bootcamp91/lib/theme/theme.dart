import 'package:bootcamp91/product/project_colors.dart';
import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData.dark().copyWith(
  //SCAFFOLD THEME
  scaffoldBackgroundColor: ProjectColors.firstColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ProjectColors.default_color,
    primary: ProjectColors.default_color,
  ),
  //APPBAR THEME
  appBarTheme: const AppBarTheme(
    backgroundColor: ProjectColors.project_yellow,
    foregroundColor: ProjectColors.project_yellow,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: ProjectColors.project_gray,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  ),
  //TEXT THEME
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: ProjectColors.textColor, fontSize: 22),
    bodyMedium: TextStyle(color: ProjectColors.textColor, fontSize: 20),
    bodySmall: TextStyle(color: ProjectColors.textColor, fontSize: 18),
  ),
  //ELEVATED BUTTON THEME
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return ProjectColors.project_gray;
          // Buton devre dışı bırakıldığında gri arka plan
        }
        return ProjectColors
            .project_yellow; // Buton etkin olduğunda sarı arka plan
      }),
      foregroundColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.red;
          // Buton devre dışı bırakıldığında kırmızı yazı rengi
        }
        return ProjectColors.textColor; // Buton etkin olduğunda metin rengi
      }),
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ProjectColors.textColor,
        ),
      ),
      minimumSize: WidgetStateProperty.all<Size>(
        const Size(double.infinity, 50),
      ),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
  ),
);
