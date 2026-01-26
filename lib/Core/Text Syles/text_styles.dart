import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';

class MainTextStyles{
  static TextStyle getBasicTextStyle(Color color){
    return GoogleFonts.roboto(
      fontSize: 20,
      color: color,
      fontWeight: FontWeight.w500,

    );
  }

  static TextStyle getTitleTextStyle(){
    return GoogleFonts.roboto(
      fontSize: 28,
      color: MainColors.getPrimaryColor(),
      fontWeight: FontWeight.w600,

    );
  }

  static TextStyle getButtonTextStyle(){
    return GoogleFonts.roboto(
      fontSize: 25,
      color: MainColors.getTextPrimaryColor(),
      fontWeight: FontWeight.w400,

    );
  }

  static TextStyle getHeadingTextStyle(){
    return GoogleFonts.roboto(
      fontSize: 50,
      color: MainColors.getPrimaryColor(),
      fontWeight: FontWeight.w900,

    );
  }
}