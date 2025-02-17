import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'detail_page..dart';


void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const FigmaScreen(),
    );
  }
}

class FigmaScreen extends StatelessWidget {
  const FigmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Art Teller',
          style: TextStyle(
            color: Color(0xFFD55E00),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          // 🔹 사용자 정보 (유저 박스)
          Positioned(
            left: 130,
            top: 80,
            child: Container(
              width: 170,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF211B1B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이콘과 텍스트 사이 간격 조정
                children: [
                  Expanded( // 아이콘이 가능한 위쪽에 배치되도록 함
                    child: SvgPicture.asset(
                      'assets/icon_userbox.svg',
                      width: 130,
                      height: 150,
                    ),
                  ),
                  Padding( // 텍스트를 아래쪽에 배치
                    padding: const EdgeInsets.only(bottom: 12), // 적절한 여백 추가
                    child: const Text(
                      '패기3팀',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          // 🔹 "나의 미술관"
          Positioned(
            left: width * 0.1,
            top: height * 0.4,
            child: Row(
              children: [
                const Text(
                  '나의 미술관',
                  style: TextStyle(
                    color: Color(0xFFD55E00),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  'assets/icon_book.svg',
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),

          // 🔹 날짜 목록 (조금 아래로 내림)
          Positioned(
            right: width * 0.1,
            top: height * 0.50, // ⬇ 기존보다 조금 아래로 이동
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildButton(context, '2025. 02. 12'),
                _buildButton(context, '2025. 02. 09'),
                _buildButton(context, '2025. 02. 07'),
              ],
            ),
          ),

          // 🔹 "더보기" 버튼 (중앙 하단)
          Positioned(
            bottom: height * 0.05,
            left: width * 0.5 - 60,
            child: _buildSmallButton(context, '더보기'),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 180,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(date: text),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD55E00),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton(BuildContext context, String text) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD55E00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
