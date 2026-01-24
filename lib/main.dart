import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/Providers/camera_provider.dart';
import 'UI/Screens/Camera Screen/View Model/camera_screen_view_model.dart';
import 'Routes/app_routes.dart';
import 'UI/Screens/Camera Screen/View/Screen/camera_screen.dart';
import 'UI/Screens/Result Screen/result_screen.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CameraScreenViewModel()),
        ChangeNotifierProvider(create: (context) => CameraProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.cameraScreenRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.cameraScreenRoute:
            return MaterialPageRoute(
              builder: (_) => CameraScreen(cameras: _cameras),
            );

          case Routes.resultScreenRoute:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ResultScreen(
                type: args['type'],
                frames: args['frames'],
                scan: args['scan'],
                detectionData: args['detectionData'],
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}

