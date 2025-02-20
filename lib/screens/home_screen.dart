import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'mypage_screen.dart';
import 'recommand_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> watchedArtworks = []; // 최근 감상한 작품 리스트 (예제 데이터)

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black), // 뒤로가기 버튼 색상 변경
        title: const Text(
          'ArtChemy',
          style: TextStyle(
            color: Color(0xFF1E40AF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black, size: 40),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyPageScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 작품 감상하기 버튼
            GestureDetector(
              onTap: () async {
                final cameras = await availableCameras(); // 카메라 목록 가져오기
                if (cameras.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen(camera: cameras.first)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('카메라를 찾을 수 없습니다.')),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF171D1B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/avatar.png'), // 임시 이미지
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '작품 감상하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'AI 설명을 들어보세요.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '최근 감상한 작품',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            watchedArtworks.isEmpty
                ? Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '최근 감상한 작품이 없습니다.',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            )
                : SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: watchedArtworks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.image, color: Color(0xFF1E40AF)),
                      title: Text(watchedArtworks[index]),
                      subtitle: const Text('최근 감상한 작품'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 60),

            // 오늘의 명화 추천 버튼
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecommandScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/recommand_img.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '오늘의 명화 추천',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '세계적으로 유명한 명화의 설명을 들어보세요',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
