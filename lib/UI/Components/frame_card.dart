import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';
import 'package:rl_camera_filters/Core/Text%20Syles/text_styles.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/Model/frame_model.dart';

class FrameCard extends StatelessWidget {
  final FrameModel frame;

  const FrameCard({super.key, required this.frame});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MainColors.getPrimaryColor()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                frame.frame,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Brightness: ${frame.brightnessScore.toStringAsFixed(3)}",
            style: MainTextStyles.getBasicTextStyle(
              MainColors.getPrimaryColor(),
            ),
          ),
          Text(
            "Sharpness: ${frame.blurScore.toStringAsFixed(3)}",
            style: MainTextStyles.getBasicTextStyle(
              MainColors.getPrimaryColor(),
            ),
          ),
          Text(
            "Motion: ${frame.shakeScore.toStringAsFixed(3)}",
            style: MainTextStyles.getBasicTextStyle(
              MainColors.getPrimaryColor(),
            ),
          ),
        ],
      ),
    );
  }
}
