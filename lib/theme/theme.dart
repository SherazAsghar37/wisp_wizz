import 'package:flutter/material.dart';
import 'package:wisp_wizz/core/utils/colors.dart';
import 'package:wisp_wizz/core/utils/dimensions.dart';

//light
ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: lightPrimaryColor,
            fontSize: Dimensions.height22,
            fontWeight: FontWeight.bold,
            fontFamily: "lato"),
        bodyMedium: TextStyle(
            color: blackColor,
            fontSize: Dimensions.height17,
            fontFamily: "lato"),
        bodySmall: TextStyle(
            color: lightTextColor,
            fontSize: Dimensions.height10,
            fontFamily: "lato")),
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    primaryColor: lightPrimaryColor,
    primaryColorLight: lightPrimaryColor.withOpacity(0.2),
    colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        background: whiteColor,
        primary: greyColor,
        secondary: lightSecondaryColor));
//dark
ThemeData darkTheme = ThemeData(
    textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.height22,
            fontFamily: "lato"),
        bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: Dimensions.height17,
            fontFamily: "lato"),
        bodySmall: TextStyle(
            color: dlightTextColor,
            fontSize: Dimensions.height10,
            fontFamily: "lato")),
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColorDark: dContainerGradDark,
    primaryColorLight: dContainerGradLight,
    shadowColor: dShadowColorDark,
    primaryColor: dShadowColorlight,
    colorScheme: const ColorScheme.light(
        brightness: Brightness.dark,
        background: dBackgroundColor,
        primary: dPrimaryColor,
        secondary: dlightTextColor));
