import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_screen.dart';
import 'login_screen.dart';
import 'recommand_screen.dart';

class HomeScreen extends StatelessWidget {
  final CameraDescription camera;

  const HomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> watchedArtworks = []; // 최근 감상한 작품 리스트 (예제 데이터)

    return Scaffold(
      appBar: AppBar(
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
                MaterialPageRoute(builder: (context) => LoginScreen()),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen(camera: camera)),
                );
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
                      radius: 30,
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

            // 최근 감상한 작품 목록
            watchedArtworks.isEmpty
                ? Container(
              width: double.infinity,
              height: 300, // 기본 높이 유지
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
              height: 300, // 리스트도 동일한 높이 적용
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
                // 추천 명화 페이지로 이동할 로직 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecommandScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 130, // 버튼 높이 설정
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/recommand_img.png'), // 배경 이미지
                    fit: BoxFit.cover, // 전체 배경 채우기
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
