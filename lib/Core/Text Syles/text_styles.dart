import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';

class MainTextStyles{
  static TextStyle getBasicTextStyle(Color color){
    return TextStyle(
      fontSize: 20,
      color: color,
      fontWeight: FontWeight.w500,

    );
  }

  static TextStyle getTitleTextStyle(){
    return TextStyle(
      fontSize: 28,
      color: MainColors.getPrimaryColor(),
      fontWeight: FontWeight.w600,

    );
  }
  static TextStyle getButtonTextStyle(){
    return TextStyle(
      fontSize: 16,
      color: MainColors.getTextPrimaryColor(),
      fontWeight: FontWeight.w400,

    );
  }
}