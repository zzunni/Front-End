// mock_artwork_service 실제 서버 응답을 시뮬레이션 하기 위한 작업
import 'artwork_model.dart';


class MockArtworkService {
  static final List<ArtworkModel> _mockArtworks = [
    ArtworkModel(
      id: 1,
      title: '별이 빛나는 밤',
      artist: '빈센트 반 고흐',
      year: '1889',
      imagePath: 'assets/pictop.png',
      aiAnalysis: '이 작품은 후기 인상주의의 대표작으로, 소용돌이치는 별들과 함께 하늘과 땅이 역동적으로 표현되어 있습니다. 강렬한 감정 표현과 대담한 붓질로 작가의 내면 세계를 표현하고 있습니다.',
      date: DateTime(2025, 2, 19),
    ),
    ArtworkModel(
      id: 2,
      title: '사이프러스가 있는 밀밭',
      artist: '빈센트 반 고흐',
      year: '1889',
      imagePath: 'assets/picbot.png',
      aiAnalysis: '황금빛 밀밭과 어두운 사이프러스 나무의 대비가 인상적인 작품입니다. 자연의 생명력과 역동성이 고흐 특유의 붓터치로 표현되어 있습니다.',
      date: DateTime(2025, 2, 19),
    ),
  ];

  Future<List<ArtworkModel>> getArtworksByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockArtworks.where((artwork) =>
    artwork.date.year == date.year &&
        artwork.date.month == date.month &&
        artwork.date.day == date.day
    ).toList();
  }

  Future<ArtworkModel?> findArtworkByTitle(String title) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockArtworks.firstWhere((artwork) => artwork.title == title);
    } catch (e) {
      return null;
    }
  }

  Future<ArtworkModel?> getArtworkById(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockArtworks.firstWhere((artwork) => artwork.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteArtwork(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockArtworks.removeWhere((artwork) => artwork.id == id);
  }
}
