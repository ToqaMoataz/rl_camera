import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';
import 'package:rl_camera_filters/UI/Components/button_card.dart';

import '../../../../../../../Core/Text Syles/text_styles.dart';

class TFLiteDetector extends StatelessWidget {
  const TFLiteDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonCard(onTap: (){showMyDialog(context);}, buttonText: "Detect");
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


