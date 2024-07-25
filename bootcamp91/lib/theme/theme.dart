import 'package:bootcamp91/product/project_colors.dart';
import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData.light().copyWith(
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
      color: ProjectColors.firstColor,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: ProjectColors.firstColor,
    ),
    actionsIconTheme: IconThemeData(
      color: ProjectColors.firstColor,
    ),
  ),
  //TEXT THEME
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
        color: ProjectColors.textColor,
        fontSize: 22,
        fontWeight: FontWeight.w800),
    bodyMedium: TextStyle(color: ProjectColors.textColor, fontSize: 20),
    bodySmall: TextStyle(color: ProjectColors.textColor, fontSize: 18),
  ),
  hintColor: ProjectColors.project_gray,
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
            .buttonColor; // Buton etkin olduğunda sarı arka plan
      }),
      foregroundColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.red;
          // Buton devre dışı bırakıldığında kırmızı yazı rengi
        }
        return ProjectColors.firstColor; // Buton etkin olduğunda metin rengi
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
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
  ),
  // TEXT FIELD THEME
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: ProjectColors.default_color),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: ProjectColors.default_color),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: ProjectColors.project_yellow),
    ),
    labelStyle: const TextStyle(color: ProjectColors.default_color),
  ),
);
