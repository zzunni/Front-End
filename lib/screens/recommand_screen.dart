import 'package:flutter/material.dart';
import 'recommand_vts_screen.dart';

class RecommandScreen extends StatelessWidget {
  const RecommandScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '오늘의 작품',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // 타이틀 텍스트를 흰색으로 변경
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black, // AppBar도 검정색으로 변경
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.black, // 전체 배경을 검정색으로 변경
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 작품 메인 이미지 (어두운 배경에서 더 돋보이도록)
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/recommand_img.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 반 고흐 초상화 + 작품 제목
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 반 고흐 초상화 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/vangogh.jpg',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),

                // 작품 제목 & 설명
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900], // 어두운 회색 배경
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '별이 빛나는 밤',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // 텍스트 색상 변경
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '빈센트 반 고흐, 1889',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey, // 파란색 강조
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // AI 분석 결과 박스 (다크 모드 스타일)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900], // 어두운 회색 배경
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 분석결과',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // 텍스트 흰색
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '이 작품은 후기 인상주의를 대표하는 걸작으로, '
                          '소용돌이치는 하늘과 밝게 빛나는 별들이 특징적입니다. '
                          '강렬한 감정 표현과 역동적인 붓터치를 통해 '
                          '작가의 내면 세계를 드러내고 있습니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey, // 연한 회색으로 가독성 유지
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 대화하기 버튼 (파란색 강조)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 대화하기 버튼 로직 추가 가능
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RecommandVtsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E40AF), // 버튼 배경 파란색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  '대화하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
