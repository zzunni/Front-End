import 'package:flutter/material.dart';
import 'dart:io';
import '../services/mock_artwork_service.dart';
import '../services/artwork_model.dart';
import '../services/conversation_model.dart'; // 대화 기록 모델 추가
import '../services/tts_service.dart';

class VtsRecordScreen extends StatefulWidget {
  final String imagePath;

  const VtsRecordScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _VtsRecordScreenState createState() => _VtsRecordScreenState();
}

class _VtsRecordScreenState extends State<VtsRecordScreen> {
  final MockArtworkService artworkService = MockArtworkService();
  final TTSService ttsService = TTSService();
  List<ConversationModel> conversations = [];
  bool isLoading = true;
  ArtworkModel? artwork;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  // TTS로 텍스트 읽기 메서드 추가
  Future<void> _speak(String text) async {
    await ttsService.speak(text);
  }

  Future<void> _loadConversations() async {
    try {
      // 이미지 경로를 통해 작품 정보 찾기
      final artworkFromPath = await artworkService.getArtworkByImagePath(widget.imagePath);
      if (artworkFromPath != null) {
        // 작품 ID를 통해 해당 작품과의 대화 기록 불러오기
        final conversationHistory = await artworkService.getConversationsByArtworkId(artworkFromPath.id);
        setState(() {
          artwork = artworkFromPath;
          conversations = conversationHistory;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading conversations: $e');
      setState(() {
        isLoading = false;
      });
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
        appBar: AppBar(
          title: const Text('대화기록'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('작품 정보를 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '대화기록',
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
      body: Column(
        children: [
          // 작품 이미지 표시
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              artwork!.imagePath,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // 대화 기록 목록
          Expanded(
            child: conversations.isEmpty
                ? const Center(child: Text('대화 기록이 없습니다.'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _buildMessageBubble(conversation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ConversationModel conversation) {
    final isUser = conversation.isUserMessage;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(  // GestureDetector로 감싸서 탭 이벤트 처리
        onTap: () => _speak(conversation.message),  // 탭하면 TTS 실행
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUser
                ? const Color(0xFF1E40AF) // 사용자 메시지는 파란색
                : Colors.white,           // AI 메시지는 흰색
            borderRadius: BorderRadius.circular(12),
            border: isUser
                ? null
                : Border.all(color: Colors.grey[300]!),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            conversation.message,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}