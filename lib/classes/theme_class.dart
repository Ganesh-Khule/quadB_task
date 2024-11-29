import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme => _light;
  static ThemeData get darkTheme => _dark;

  static final ThemeData _light = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      // backgroundColor: Colors.amber,
      selectedItemColor: Colors.black
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: Colors.amber,
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    useMaterial3: true,
    primarySwatch: Colors.amber,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      backgroundColor: Colors.amber,
    ),
    brightness: Brightness.light,
  );

  static final ThemeData _dark = ThemeData(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        backgroundColor: Colors.red,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    useMaterial3: true,
    primarySwatch: Colors.red,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: true,
      backgroundColor: Colors.red,
    ),
    brightness: Brightness.dark,
  );
}
