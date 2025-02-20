//diary_screen
import 'package:Art_Chat/services/artwork_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../services/date_select_service.dart';
import '../services/stt_service.dart';
import '../widgets/diary_dialog.dart';
import 'analysis_record_screen.dart';
import 'mypage_screen.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime selectedDate = DateTime.now();
  String _searchText = "찾으시는 작품 있으세요?";
  bool _isListening = false; // 음성 인식 상태를 추적하는 변수 추가
  final SpeechRecognitionService _speechService = SpeechRecognitionService();
  final DiaryService _diaryService = DiaryService();
  List<ArtworkModel> _artworks = [];

  @override
  void initState() {
    super.initState();
    _loadArtworks();
  }

  Future<void> _loadArtworks() async {
    try {
      final artworks = await _diaryService.getArtworksByDate(selectedDate);
      setState(() {
        _artworks = artworks;
      });
    } catch (e) {
      print('Error loading artworks: $e');
      // You might want to show an error dialog here
    }
  }

  void _changeDate(bool isNext) {
    setState(() {
      selectedDate = isNext
          ? selectedDate.add(const Duration(days: 1))
          : selectedDate.subtract(const Duration(days: 1));
      _loadArtworks();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _loadArtworks();
      });
    }
  }

  Future<void> _startSpeechRecognition() async {
    try {
      setState(() {
        _isListening = true;
        _searchText = "듣고있어요...";
      });

      final recognizedText = await _speechService.startListening();

      setState(() {
        _isListening = false;
        _searchText = recognizedText ?? "찾으시는 작품 있으세요?";
      });

      if (recognizedText != null) {
        final artwork = await _diaryService.findArtworkByTitle(recognizedText);
        if (artwork != null) {
          setState(() {
            selectedDate = artwork.date;
          });
          await _loadArtworks();
        } else {
          if (mounted) {
            DiaryDialogs.showArtworkNotFoundDialog(context);
          }
        }
      }
    } catch (e) {
      print('Speech recognition error: $e');
      setState(() {
        _isListening = false;
        _searchText = "찾으시는 작품 있으세요?";
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('오류'),
            content: const Text('음성 인식 중 오류가 발생했습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyPageScreen()),
            );
          },
        ),
        title: const Text(
          "감상 일기",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _changeDate(false),
                  child: SvgPicture.asset(
                    'assets/left_icon.svg',
                    width: 14,
                    height: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text(
                      DateFormat('yyyy.MM.dd').format(selectedDate),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: SvgPicture.asset(
                        'assets/calender_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _changeDate(true),
                  child: SvgPicture.asset(
                    'assets/right_icon.svg',
                    width: 14,
                    height: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _artworks.map((artwork) => _buildArtworkCard(
                  context,
                  artwork.imagePath,
                  artwork.title,
                  artwork.id,
                )).toList(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _searchText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _startSpeechRecognition,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening
                            ? Colors.red
                            : const Color(0xFF1E40AF),
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworkCard(BuildContext context, String imagePath, String title, int artworkId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisRecordScreen(artworkId: artworkId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1E40AF),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}