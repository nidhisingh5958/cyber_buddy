import 'package:cyber_buddy/screens/components/colors.dart';
import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    fontFamily: 'Inter',
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    cardTheme: cardTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    textTheme: textTheme(),
    elevatedButtonTheme: elevatedButtonsTheme(),
    primaryColor: Colors.black,
    primarySwatch: Colors.grey,
  );
}

CardThemeData cardTheme() {
  return CardThemeData(
    elevation: 0.5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: black.withValues(alpha: 0.1),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(26),
    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
  );
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: const BorderSide(color: Colors.black45, width: 1.5),
    ),
    border: outlineInputBorder,
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(color: Colors.grey.shade500),
  );
}

TextTheme textTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 24,
      letterSpacing: -0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: -0.2,
    ),
  );
}

ElevatedButtonThemeData elevatedButtonsTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.black54,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
    ),
  );
}

InputDecorationTheme dropdownButtonFormFieldTheme() {
  return const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(26)),
      borderSide: BorderSide(color: Colors.grey, width: 1.5),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}
