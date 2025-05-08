import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cat.dart';
import '../domain/liked_cat.dart';

const _kCatsKey = 'cached_cats';
const _kLikedCatsKey = 'liked_cats';
const _kDislikedKey = 'disliked_urls';

class CatLocalStorage {
  Future<void> addLikedCat(LikedCat liked) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kLikedCatsKey) ?? <String>[];
    list.add(
      jsonEncode({
        'cat': liked.cat.toJson(),
        'likedAt': liked.likedAt.toIso8601String(),
      }),
    );
    await prefs.setStringList(_kLikedCatsKey, list);
  }

  Future<void> removeLikedCat(LikedCat liked) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kLikedCatsKey) ?? <String>[];
    list.removeWhere((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return (map['cat'] as Map)['url'] == liked.cat.imageUrl;
    });
    await prefs.setStringList(_kLikedCatsKey, list);
  }

  Future<List<LikedCat>> getLikedCats() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kLikedCatsKey) ?? <String>[];
    return list.map((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return LikedCat(
        cat: Cat.fromJson(map['cat'] as Map<String, dynamic>),
        likedAt: DateTime.parse(map['likedAt'] as String),
      );
    }).toList();
  }

  Future<void> addDislikedUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kDislikedKey) ?? <String>[];
    list.add(url);
    await prefs.setStringList(_kDislikedKey, list);
  }

  Future<List<String>> getDislikedUrls() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kDislikedKey) ?? <String>[];
  }

  Future<void> addCat(Cat cat) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kCatsKey) ?? <String>[];
    list.insert(0, jsonEncode(cat.toJson()));
    if (list.length > 30) list.removeLast();
    await prefs.setStringList(_kCatsKey, list);
  }

  Future<List<Cat>> getCachedCats() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kCatsKey) ?? <String>[];

    final seen = <String>{};
    final result = <Cat>[];

    for (final entry in raw.reversed) {
      final map = jsonDecode(entry) as Map<String, dynamic>;
      final cat = Cat.fromJson(map);
      if (seen.add(cat.imageUrl)) {
        result.add(cat);
      }
    }
    return result;
  }
}
