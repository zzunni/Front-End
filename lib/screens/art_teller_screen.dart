import 'package:flutter/material.dart';
import 'dart:io';
import '../../services/audio_player_service.dart';
import '../widgets/Interpretation_dialog.dart';
import '../widgets/language_selection_dialog.dart';

class ArtTellerScreen extends StatefulWidget {
  final String imagePath;

  ArtTellerScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ArtTellerScreenState createState() => _ArtTellerScreenState();
}

class _ArtTellerScreenState extends State<ArtTellerScreen> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  bool _isPlaying = false;

  void _toggleSound() {
    if (_isPlaying) {
      _audioPlayerService.pauseSound();
    } else {
      _audioPlayerService.playSound();
    }

    // 상태 변경은 한 번만 수행
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekBy(Duration duration) {
    _audioPlayerService.seekBy(duration);
  }

  void _startRecording() {
    print("🎤 녹음 시작!"); // 실제 녹음 로직 추가 예정
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
        title: const Text(
          'Art Teller',
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
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
                onPressed: () => _seekBy(Duration(seconds: -5)),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 60.0,
                  color: Colors.orange,
                ),
                onPressed: _toggleSound, // 상태 변경을 한 번만 수행
              ),
              IconButton(
                icon: Icon(Icons.forward_5, size: 60.0, color: Colors.orange),
                onPressed: () => _seekBy(Duration(seconds: 5)),
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _startRecording, // 녹음 기능 분리
            child: Icon(
              Icons.mic,
              color: Colors.orange,
              size: 60,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
