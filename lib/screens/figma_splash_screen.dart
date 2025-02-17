import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camera/camera.dart';
import 'camera_screen.dart';

class FigmaSplashScreen extends StatefulWidget {
  final CameraDescription camera;

  const FigmaSplashScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _FigmaSplashScreenState createState() => _FigmaSplashScreenState();
}

class _FigmaSplashScreenState extends State<FigmaSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 설정 (2초 동안 실행)
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // 0% → 100%로 증가하는 애니메이션
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 애니메이션 시작
    _animationController.forward();

    // 2초 후 자동으로 다음 화면으로 이동
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => CameraScreen(camera: widget.camera),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/MIC_ICON.svg',
            width: 112,
            height: 131,
          ),
          const SizedBox(height: 30),
          const Text(
            'Art Teller',
            style: TextStyle(
              color: Color(0xFFD55E00),
              fontSize: 40,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.25,
            ),
          ),
          const SizedBox(height: 30),
          // 슬라이딩 바 애니메이션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _progressAnimation.value, // 현재 진행 상태 반영
                  backgroundColor: Colors.grey[800], // 배경색
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD55E00)), // 진행색
                  minHeight: 8, // 높이 조절 가능
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
