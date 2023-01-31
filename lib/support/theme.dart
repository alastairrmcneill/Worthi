import 'package:flutter/material.dart';
import 'package:moolah/models/account_model.dart';

class MyThemes {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: MyColors.background,
      appBarTheme: const AppBarTheme(color: MyColors.blueAccent, foregroundColor: MyColors.lightAccent, centerTitle: true),
      textTheme: const TextTheme(
        headline1: TextStyle(color: MyColors.lightAccent),
        headline2: TextStyle(color: MyColors.lightAccent),
        headline3: TextStyle(color: MyColors.lightAccent),
        headline4: TextStyle(color: MyColors.lightAccent),
        headline5: TextStyle(color: MyColors.lightAccent),
        headline6: TextStyle(color: MyColors.lightAccent),
        bodyText1: TextStyle(color: MyColors.lightAccent),
        bodyText2: TextStyle(color: MyColors.lightAccent),
        button: TextStyle(color: MyColors.lightAccent),
        caption: TextStyle(color: MyColors.lightAccent),
        overline: TextStyle(color: MyColors.lightAccent),
        subtitle1: TextStyle(color: MyColors.lightAccent),
        subtitle2: TextStyle(color: MyColors.lightAccent),
      ),
      iconTheme: const IconThemeData(color: MyColors.lightAccent),
      dividerColor: MyColors.lightAccent,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(MyColors.blueAccent),
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
              color: MyColors.lightAccent,
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
          borderSide: const BorderSide(color: MyColors.redAccent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MyColors.redAccent, width: 2),
        ),
      ),
    );
  }
}

class MyColors {
  static const Color background = Color(0xFF363844);
  static const Color darkAccent = Color.fromARGB(255, 47, 48, 62);
  static const Color lightAccent = Color.fromARGB(255, 225, 231, 255);
  static const Color lightAccentDarker = Color.fromARGB(255, 184, 186, 194);
  static const Color blueAccent = Color(0xFF3C99D9);
  static const Color redAccent = Color.fromARGB(255, 210, 64, 58);
  static const Color greenAccent = Colors.green;
  static final Map<String, Color> accountColors = {
    AccountTypes.bank: Colors.amber,
    AccountTypes.credit: Colors.teal,
    AccountTypes.investment: Color.fromARGB(255, 197, 34, 34),
    AccountTypes.loan: Colors.blue,
    AccountTypes.pension: Colors.purple,
  };
  static final Map<String, Color> accountAccentColors = {
    AccountTypes.bank: Color.fromARGB(255, 185, 115, 4),
    AccountTypes.credit: Colors.tealAccent,
    AccountTypes.investment: Color.fromARGB(255, 237, 115, 115),
    AccountTypes.loan: Color.fromARGB(255, 3, 29, 156),
    AccountTypes.pension: Color.fromARGB(255, 231, 97, 254),
  };
}
