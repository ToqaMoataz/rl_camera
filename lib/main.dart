import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';
import 'package:rl_camera_filters/Core/Text%20Syles/text_styles.dart';

import 'Core/Routes/app_routes.dart';
import 'Core/Routes/generate_routes.dart';
import 'UI/Screens/Camera Screen/View Model/camera_screen_view_model.dart';



late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CameraScreenViewModel()),
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
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: MainColors.getPrimaryColor()
          ),
          backgroundColor:MainColors.getBackGroundColor(),
          titleTextStyle: MainTextStyles.getTitleTextStyle(),
        ),
        scaffoldBackgroundColor: MainColors.getBackGroundColor(),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:MainColors.getBackGroundColor(),
          selectedIconTheme: IconThemeData(
            color: MainColors.getPrimaryColor(),
          ),
          unselectedIconTheme: IconThemeData(
            color: MainColors.getTextPrimaryColor(),
          ),
          selectedLabelStyle: TextStyle(
            color: MainColors.getPrimaryColor(),
          ),
          unselectedLabelStyle: TextStyle(
            color: MainColors.getTextPrimaryColor(),
          ),
          unselectedItemColor: MainColors.getTextPrimaryColor(),
          selectedItemColor: MainColors.getPrimaryColor()
        )
      ),
      initialRoute: Routes.cameraScreenRoute,
      onGenerateRoute:AppRoutesGenerator(cameras: _cameras).generateRoute,
    );
  }
}

