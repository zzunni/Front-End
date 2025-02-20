//artwork_service

import 'package:mysql1/mysql1.dart';
import 'database_config.dart';

class Artwork {
  final int id;
  final String title;
  final String artist;
  final String year;
  final String imagePath;
  final String aiAnalysis;

  Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.imagePath,
    required this.aiAnalysis,
  });

  factory Artwork.fromRow(ResultRow row) {
    return Artwork(
      id: row['id'],
      title: row['title'],
      artist: row['artist'],
      year: row['year'],
      imagePath: row['image_path'],
      aiAnalysis: row['ai_analysis'],
    );
  }
}

class ArtworkService {
  Future<Artwork?> getArtworkById(int id) async {
    final conn = await DatabaseConfig.getConnection();
    try {
      final results = await conn.query(
          'SELECT * FROM artworks WHERE id = ?',
          [id]
      );

      if (results.isEmpty) return null;
      return Artwork.fromRow(results.first);
    } finally {
      await conn.close();
    }
  }

  Future<void> deleteArtwork(int id) async {
    final conn = await DatabaseConfig.getConnection();
    try {
      await conn.query('DELETE FROM artwork_records WHERE artwork_id = ?', [id]);
      await conn.query('DELETE FROM artworks WHERE id = ?', [id]);
    } finally {
      await conn.close();
    }
  }
}