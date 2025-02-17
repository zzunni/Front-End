import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'services/permission_service.dart';
import 'screens/figma_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  await requestPermission();

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: FigmaSplashScreen(camera: camera), // ✅ 초기 화면을 FigmaSplashScreen으로 설정
    );
  }
}
