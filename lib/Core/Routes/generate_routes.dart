import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../UI/Screens/Camera Screen/View/Screen/camera_screen.dart';
import '../../UI/Screens/Initial  Screen/welcome_screen.dart';
import '../../UI/Screens/Result Screen/result_screen.dart';

import 'app_routes.dart';

class AppRoutesGenerator {
  final List<CameraDescription> cameras;

  AppRoutesGenerator({required this.cameras});

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.welcomeScreenRoute:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );

      case Routes.cameraScreenRoute:
        return MaterialPageRoute(
          builder: (_) => CameraScreen(cameras: cameras),
        );

      case Routes.resultScreenRoute:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ResultScreen(
            type: args['type'],
            frameResult: args['frameResult'],
            scanResult: args['scan'],
            detectionData: args['detectionData'],
          ),
        );

      default:
        return null;
    }
  }

}