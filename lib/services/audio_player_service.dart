import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  Future<String> getAudioFilePath() async {
    Directory? directory = await getExternalStorageDirectory();
    return directory != null ? "${directory.path}/summer-time-299270.mp3" : "/storage/emulated/0/Download/summer-time-299270.mp3";
  }

  void playSound() async {
    try {
      String path = await getAudioFilePath();
      await _audioPlayer.setSource(DeviceFileSource(path));
      await _audioPlayer.resume();
      _isPlaying = true;
    } catch (e) {
      print("❌ 오디오 재생 실패: $e");
    }
  }

  void pauseSound() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  void seekBy(Duration offset) async {
    Duration? currentPosition = await _audioPlayer.getCurrentPosition();
    if (currentPosition != null) {
      await _audioPlayer.seek(currentPosition + offset);
    }
  }

  bool isPlaying() => _isPlaying;

  void dispose() {
    _audioPlayer.dispose();
  }
}
