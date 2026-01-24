import 'package:flutter/material.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/Model/frame_model.dart';

class FrameCard extends StatelessWidget {
  final FrameModel frame;
  const FrameCard({super.key,required this.frame});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.deepPurple
        ),
      ),
      child: Column(
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
          Text("Brightness: ${frame.brightnessScore.toStringAsFixed(3)}", style: style()),
          Text("Sharpness: ${frame.blurScore.toStringAsFixed(3)}", style: style()),
          Text("Motion: ${frame.shakeScore.toStringAsFixed(3)}", style: style()),
        ],
      )


    );
  }
  TextStyle style(){
    return TextStyle(
      fontSize: 12,
      color: Colors.deepPurple,
      fontWeight: FontWeight.w400,
    );
  }
}
