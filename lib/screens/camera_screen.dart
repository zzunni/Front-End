import 'package:Art_Teller/screens/personal_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'art_teller_screen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  double _currentZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoomCamera(double zoom) async {
    final maxZoom = await _controller.getMaxZoomLevel();
    final minZoom = await _controller.getMinZoomLevel();
    setState(() {
      _currentZoom = zoom.clamp(minZoom, maxZoom);
    });
    _controller.setZoomLevel(_currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Art Teller", style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xFFD55E00))),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xFFD55E00), size: 40.0),
            onPressed: () {
              // 사용자 정보 화면 이동 기능 추가 가능
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FigmaScreen(),
                ),
              );;
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.remove, color: Color(0xFFD55E00)), onPressed: () => _zoomCamera(_currentZoom - 0.1)),
                Expanded(
                  child: Slider(
                    activeColor: Color(0xFFD55E00),
                    min: 1.0,
                    max: 8.0,
                    value: _currentZoom,
                    onChanged: (value) => _zoomCamera(value),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add, color: Color(0xFFD55E00)), onPressed: () => _zoomCamera(_currentZoom + 0.1)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () async {
                try {
                  final image = await _controller.takePicture();
                  if (!mounted) return;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArtTellerScreen(imagePath: image.path)));
                } catch (e) {
                  print("Error taking picture: $e");
                }
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(color: Color(0xFFD55E00), shape: BoxShape.circle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
