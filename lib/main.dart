import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'interpretation_dialog.dart';
import 'language_selection_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


Future<void> requestPermission() async {
  if (await Permission.storage.request().isGranted) {
    print("✅ 파일 접근 권한 허용됨");
  } else {
    print("❌ 파일 접근 권한 거부됨. 설정에서 허용해주세요.");
  }
}

void main() async {
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
      home: CameraScreen(camera: camera),
    );
  }
}

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
        title: const Text("Art Teller", style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.orange),
            onPressed: () {
              // 사용자 정보 화면 이동 기능 추가 가능
              print("사용자 아이콘 클릭됨");
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.orange),
                  onPressed: () => _zoomCamera(_currentZoom - 0.1),
                ),
                Expanded(
                  child: Slider(
                    activeColor: Colors.orange,
                    min: 1.0,
                    max: 8.0,
                    value: _currentZoom,
                    onChanged: (value) => _zoomCamera(value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.orange),
                  onPressed: () => _zoomCamera(_currentZoom + 0.1),
                ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtTellerScreen(imagePath: image.path),
                    ),
                  );
                } catch (e) {
                  print("Error taking picture: $e");
                }
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArtTellerScreen extends StatefulWidget {
  final String imagePath;

  ArtTellerScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ArtTellerScreenState createState() => _ArtTellerScreenState();
}

class _ArtTellerScreenState extends State<ArtTellerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String audioFilePath = "/storage/emulated/0/Download/summer-time-299270.mp3"; // 로컬 파일 경로

  Future<String> getAudioFilePath() async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      return "${directory.path}/summer-time-299270.mp3";
    } else {
      return "/storage/emulated/0/Download/summer-time-299270.mp3"; // 기본 경로
    }
  }

  void _playSound() async {
    try {
      String path = await getAudioFilePath();
      await _audioPlayer.setSource(DeviceFileSource(path));
      await _audioPlayer.resume();
      print("✅ 오디오 재생 시작");
    } catch (e) {
      print("❌ 오디오 재생 실패: $e");
    }
  }


  void _pauseSound() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _seekBy(Duration offset) async {
    Duration? currentPosition = await _audioPlayer.getCurrentPosition();
    if (currentPosition != null) {
      await _audioPlayer.seek(currentPosition + offset);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // 오디오 플레이어 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 40.0, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Art Teller',
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.orange)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, size: 40.0, color: Colors.orange),
            onPressed: () => print("저장되었습니다."),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => InterpretationDialog.build(context),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text("해설 선택", style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => LanguageSelectionDialog(),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text("언어 선택", style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Image.file(File(widget.imagePath), width: double.infinity, fit: BoxFit.cover),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_5, size: 60.0, color: Colors.orange),
                onPressed: () => _seekBy(Duration(seconds: -5)), // 5초 뒤로 이동
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 60.0,
                  color: Colors.orange,
                ),
                onPressed: () {
                  if (_isPlaying) {
                    _pauseSound();
                  } else {
                    _playSound();
                  }
                  setState(() {
                    _isPlaying = !_isPlaying; // 상태 변경
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_5, size: 60.0, color: Colors.orange),
                onPressed: () => _seekBy(Duration(seconds: 5)), // 5초 앞으로 이동
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _playSound,
            child: Icon(
              Icons.mic,
              color: Colors.orange,
              size: 60,
            ),
          ),
        ],
      ),
    );
  }
}

