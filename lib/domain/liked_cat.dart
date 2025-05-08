import '../models/cat.dart';

class LikedCat {
  final Cat cat;
  final DateTime likedAt;
  const LikedCat({required this.cat, required this.likedAt});

  Map<String, dynamic> toJson() => {
    'cat': cat.toJson(),
    'likedAt': likedAt.toIso8601String(),
  };
}
