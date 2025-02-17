import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailPage extends StatelessWidget {
  final String date;

  const DetailPage({super.key, required this.date});

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
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 🔹 "나의 미술관" + 아이콘
          Positioned(
            left: width * 0.05,
            top: height * 0.02,
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

          // 🔹 중앙 정렬된 콘텐츠
          Positioned(
            top: height * 0.1,
            left: (width - 218) / 2,
            child: Container(
              width: 218,
              height: 39,
              decoration: BoxDecoration(
                color: Color(0xFFD55E00),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFD55E00), width: 1),
              ),
              child: Center(
                child: Text(
                  date,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // 🔹 SVG 이미지들 (중앙 배치)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icon_pictop.svg',
                  width: width * 0.5,
                  height: width * 0.5,
                ),
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/icon_picbot.svg',
                  width: width * 0.5,
                  height: width * 0.5,
                ),
              ],
            ),
          ),


          // 🔹 "더보기" 버튼 (중앙 정렬)
          Positioned(
            bottom: height * 0.02,
            left: (width - 100) / 2,
            child: Container(
              width: 100,
              height: 39,
              decoration: ShapeDecoration(
                color: Color(0xFFD55E00),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Color(0xFFD55E00)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Center(
                child: Text(
                  '더보기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
