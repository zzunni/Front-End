import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize();
    }
    return _isInitialized;
  }

  Future<String?> startListening() async {
    if (!await initialize()) {
      throw Exception('Failed to initialize speech recognition');
    }

    String recognizedText = '';
    await _speech.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
      },
      localeId: 'ko-KR', // Korean language support
    );

    // Wait for speech recognition to complete
    await Future.delayed(const Duration(seconds: 5));
    await _speech.stop();

    return recognizedText.isNotEmpty ? recognizedText : null;
  }
}