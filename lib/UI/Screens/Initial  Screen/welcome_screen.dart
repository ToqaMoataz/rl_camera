import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Core/Routes/app_routes.dart';
import 'package:rl_camera_filters/Core/Text%20Syles/text_styles.dart';
import 'package:rl_camera_filters/UI/Components/button_card.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Spacer(flex: 3),
            Text(
              "Welcome to\nSmart Camera",
              textAlign: TextAlign.start,
              style: MainTextStyles.getHeadingTextStyle(),
            ),
            Spacer(flex: 3),
            ButtonCard(
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.cameraScreenRoute);
              },
              buttonText: "Start Camera",
            ),
          ],
        ),
      ),
    );
  }
}
