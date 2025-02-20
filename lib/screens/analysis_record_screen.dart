import 'package:flutter/material.dart';
import 'dart:io';
import '../services/tts_service.dart';
import '../services/mock_artwork_service.dart';
import '../services/artwork_model.dart';
import 'vts_screen.dart';

class AnalysisRecordScreen extends StatefulWidget {
  final int artworkId;

  const AnalysisRecordScreen({Key? key, required this.artworkId}) : super(key: key);

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisRecordScreen> {
  final TTSService ttsService = TTSService();
  final MockArtworkService artworkService = MockArtworkService();
  ArtworkModel? artwork;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArtwork();
  }

  Future<void> _loadArtwork() async {
    try {
      final loadedArtwork = await artworkService.getArtworkById(widget.artworkId);
      setState(() {
        artwork = loadedArtwork;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading artwork: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _speak(String text) async {
    await ttsService.speak(text);
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 3.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(artwork?.imagePath ?? ''),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteArtwork() async {
    try {
      await artworkService.deleteArtwork(widget.artworkId);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('작품 삭제 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (artwork == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('작품을 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '분석기록',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 작품 이미지
              GestureDetector(
                onTap: _showImageDialog,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    artwork!.imagePath,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 작품 정보
              GestureDetector(
                onTap: () => _speak('${artwork!.title}, ${artwork!.artist}, ${artwork!.year}'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1E40AF)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artwork!.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${artwork!.artist}, ${artwork!.year}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // AI 분석 결과
              GestureDetector(
                onTap: () => _speak(artwork!.aiAnalysis),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1E40AF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'AI 분석기록',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add_circle),
                            color: const Color(0xFF1E40AF),
                            onPressed: () {
                              // Add functionality
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        artwork!.aiAnalysis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 버튼들
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _deleteArtwork,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text('삭제하기', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VtsScreen(
                              imagePath: artwork!.imagePath,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('대화기록', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}