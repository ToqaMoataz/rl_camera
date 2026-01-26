import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';

import '../../../../../../../Core/Text Syles/text_styles.dart';

class TFLiteDetector extends StatelessWidget {
  const TFLiteDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showMyDialog(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: MainColors.getPrimaryColor(),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text("Detect", style: MainTextStyles.getButtonTextStyle()),
      ),
    );
  }
  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(
          "Sorry, this service is currently unavailable. Please try again later.",
          style: MainTextStyles.getButtonTextStyle(),
        ),
        backgroundColor: MainColors.getBackGroundColor(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK",style: MainTextStyles.getButtonTextStyle(),),
          ),
        ],
      ),
    );
  }
}


