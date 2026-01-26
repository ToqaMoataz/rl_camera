import 'package:flutter/material.dart';

import '../Colors/main_colors.dart';
import '../Text Syles/text_styles.dart';

class AppTheme {
  static final ThemeData theme=ThemeData(
      appBarTheme:  AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: MainColors.getPrimaryColor()
        ),
        backgroundColor:MainColors.getBackGroundColor(),
        titleTextStyle: MainTextStyles.getTitleTextStyle(),
      ),
      scaffoldBackgroundColor: MainColors.getBackGroundColor(),
      bottomNavigationBarTheme:  BottomNavigationBarThemeData(
          backgroundColor:MainColors.getBackGroundColor(),
          selectedIconTheme: IconThemeData(
            color: MainColors.getPrimaryColor(),
          ),
          unselectedIconTheme: IconThemeData(
            color: MainColors.getTextPrimaryColor(),
          ),
          selectedLabelStyle: TextStyle(
            color: MainColors.getPrimaryColor(),
          ),
          unselectedLabelStyle: TextStyle(
            color: MainColors.getTextPrimaryColor(),
          ),
          unselectedItemColor: MainColors.getTextPrimaryColor(),
          selectedItemColor: MainColors.getPrimaryColor()
      )
  );
}