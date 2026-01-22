
import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Screens/Camera%20Screen/Tabs/Smart%20Frame%20Gate/Service/frame_Gate_service.dart';

class SmartFrameGate extends StatelessWidget {
  SmartFrameGate({super.key});
  FrameGateService service=FrameGateService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Start Filtering",
          style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
