import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/Providers/camera_provider.dart';
import 'Providers/tab_management_provider.dart';
import 'Routes/app_routes.dart';
import 'Screens/Camera Screen/Screen/camera_screen.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TabManagementProvider()),
        ChangeNotifierProvider(create: (context) => CameraProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          Routes.cameraScreenRoute : (context) => CameraScreen(cameras: _cameras,),
          //Routes.resultScreenRoute: (context) => ResultScreen(),
        },
        initialRoute: Routes.cameraScreenRoute,

    );
  }
}
