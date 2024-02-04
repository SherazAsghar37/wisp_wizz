import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:wisp_wizz/features/app/theme/colors.dart';
import 'package:wisp_wizz/features/app/helper/dimensions.dart';

//light
ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: TextTheme(
        bodyLarge: TextStyle(
            color: lightPrimaryColor,
            fontSize: Dimensions.height22,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.fade,
            fontFamily: "lato"),
        bodyMedium: TextStyle(
            color: blackColor,
            overflow: TextOverflow.fade,
            fontSize: Dimensions.height17,
            fontFamily: "lato"),
        bodySmall: TextStyle(
            color: greyColor,
            fontSize: Dimensions.height13,
            overflow: TextOverflow.fade,
            fontFamily: "lato")),
    dividerColor: greyColor,
    dividerTheme: DividerThemeData(
      thickness: Dimensions.height1 - 0.8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimaryColor, foregroundColor: whiteColor),
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    primaryColor: lightPrimaryColor,
    primaryColorLight: lightPrimaryColor.withOpacity(0.2),
    primaryColorDark: blackColor,
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

CountryListThemeData countryListThemeData(ThemeData theme) {
  return CountryListThemeData(
    flagSize: 25,
    backgroundColor: theme.colorScheme.background,
    searchTextStyle: theme.textTheme.bodyMedium,

    bottomSheetHeight: 500, // Optional. Country list modal height
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(Dimensions.height10),
      topRight: Radius.circular(Dimensions.height10),
    ),
    //Optional. Styles the search field.
    inputDecoration: InputDecoration(
      contentPadding: const EdgeInsets.all(10.0),
      filled: true,
      fillColor: theme.primaryColorLight,
      hintText: 'Search Country',
      prefixIcon: const Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.height10),
        borderSide: BorderSide(
          color: theme.colorScheme.background,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.height10),
        borderSide: BorderSide(
          color: theme.colorScheme.background,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.height10),
        borderSide: BorderSide(
          color: theme.colorScheme.background,
        ),
      ),
    ),
  );
}
