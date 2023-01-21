import 'package:flutter/material.dart';

class MyThemes {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF363844),
      textTheme: const TextTheme(
        headline1: TextStyle(color: Color(0xFFE1E7FF)),
        headline2: TextStyle(color: Color(0xFFE1E7FF)),
        headline3: TextStyle(color: Color(0xFFE1E7FF)),
        headline4: TextStyle(color: Color(0xFFE1E7FF)),
        headline5: TextStyle(color: Color(0xFFE1E7FF)),
        headline6: TextStyle(color: Color(0xFFE1E7FF)),
        bodyText1: TextStyle(color: Color(0xFFE1E7FF)),
        bodyText2: TextStyle(color: Color(0xFFE1E7FF)),
        button: TextStyle(color: Color(0xFFE1E7FF)),
        caption: TextStyle(color: Color(0xFFE1E7FF)),
        overline: TextStyle(color: Color(0xFFE1E7FF)),
        subtitle1: TextStyle(color: Color(0xFFE1E7FF)),
        subtitle2: TextStyle(color: Color(0xFFE1E7FF)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFE1E7FF)),
      dividerColor: const Color(0xFFE1E7FF),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(120, 50),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(
              fontSize: 20,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              color: Color(0xFFE1E7FF),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[500]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
