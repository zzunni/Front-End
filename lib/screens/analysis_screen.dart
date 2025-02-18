import 'package:flutter/material.dart';
import 'dart:io';
import 'vts_screen.dart';

class AnalysisScreen extends StatelessWidget {
  final String imagePath;

  const AnalysisScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // ✅ 배경색 변경
      appBar: AppBar(
        title: const Text(
          'AI 작품분석',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black), // ✅ 검정색으로 변경
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F5), // ✅ 앱바 배경색 변경
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 촬영한 이미지 표시
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // 작품 이름 및 작가
            Container(
              width: double.infinity, // ✅ 사진과 같은 너비
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white, // ✅ 배경색을 흰색으로 변경
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12), // ✅ 높이를 살짝 증가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '그림이름', // 임시 값
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // ✅ 검정색으로 변경
                    ),
                    SizedBox(height: 4),
                    Text(
                      '작가이름', // 임시 값
                      style: TextStyle(fontSize: 14, color: Color(0xFF1E40AF)), // ✅ 색상 #1E40AF으로 변경
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // AI 분석 결과
            Container(
              width: double.infinity, // ✅ 사진과 같은 너비
              height: 250, // ✅ 사진과 같은 높이
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF1E40AF), width: 1.5), // ✅ 테두리 색상 변경
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI 분석결과',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // ✅ 검정색으로 변경
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      '인공지능의 분석 결과입니다.', // 임시 값
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 감상 저장 기능 (추후 구현)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF), // ✅ 버튼 색 변경
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('감상 저장하기', style: TextStyle(color: Colors.white)),
                ),
                OutlinedButton(
                  onPressed: () {
                    // 대화 기능 (추후 구현)
                    // ✅ VtsScreen으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VtsScreen(imagePath: imagePath)),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E40AF), // ✅ 글씨 색 변경
                    side: const BorderSide(color: Color(0xFF1E40AF)), // ✅ 테두리 색 변경
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('대화하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
