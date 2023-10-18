import 'package:flutter/material.dart';

class MyTheme {
  static Color primaryColor = Color(0xff5d9beb);
  static Color limeColor = Color(0xffDFECDB);
  static Color whiteColor = Color(0xffFFFFFF);
  static Color blackColor = Color(0xff363636);
  static Color redColor = Color(0xffEC4B4B);
  static Color greenColor = Color(0xff61E757);
  static Color greyColor = Color(0xffb0b0b0);
  static Color darkNavyColor = Color(0xff141922);

  ///white in dark
  static Color darkBlackColor = Color(0xff060E1E);
  static ThemeData lightTheme = ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        // selectedLabelStyle: ,   3shan aghyr f shakl el label
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        titleSmall: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w300,
          color: whiteColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: primaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: blackColor,
        ),
        displayLarge: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        iconSize: 30,
        shape: StadiumBorder(
          side: BorderSide(
            color: whiteColor,
            width: 4,
          ),
        ),
      ));
  static ThemeData darkTheme = ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        // selectedLabelStyle: ,   3shan aghyr f shakl el label
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
        titleSmall: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w300,
          color: whiteColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: primaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: whiteColor,
        ),
        displayLarge: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        iconSize: 30,
        shape: StadiumBorder(
          side: BorderSide(
            color: whiteColor,
            width: 4,
          ),
        ),
      ));
}
