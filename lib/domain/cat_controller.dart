import 'dart:math';
import 'package:flutter/material.dart';
import '../data/cat_service.dart';
import '../data/cat_local_storage.dart';
import '../domain/liked_cat.dart';
import '../models/cat.dart';
import '../di/service_locator.dart';

class CatController with ChangeNotifier {
  static const int _bufferSize = 5;

  final CatService _catService = getIt();
  final CatLocalStorage _local = getIt();

  final List<Cat> _cats = [];
  final List<LikedCat> _likedCats = [];
  final Set<String> _dislikedUrls = {};

  bool _isLoading = false;
  bool _hasError = false;
  int _likesCount = 0;

  List<Cat> get cats => List.unmodifiable(_cats);
  List<LikedCat> get likedCats => List.unmodifiable(_likedCats);
  int get likesCount => _likesCount;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> initialize() async {
    _setError(false);
    _setLoading(true);

    final storedLikes = await _local.getLikedCats();
    _likedCats.addAll(storedLikes);
    _likesCount = _likedCats.length;

    final storedDislikes = await _local.getDislikedUrls();
    _dislikedUrls.addAll(storedDislikes);

    final allCached = await _local.getCachedCats();
    final unseen =
        allCached.where((cat) {
          final url = cat.imageUrl;
          return !_likedCats.any((l) => l.cat.imageUrl == url) &&
              !_dislikedUrls.contains(url);
        }).toList();

    unseen.shuffle(Random());
    _cats
      ..clear()
      ..addAll(unseen);
    notifyListeners();

    await _fillBuffer();

    _setLoading(false);
  }

  Future<void> _fillBuffer() async {
    while (_cats.length < _bufferSize && !_hasError) {
      try {
        final cat = await _catService.fetchRandomCat();
        if (cat != null && !_cats.any((c) => c.imageUrl == cat.imageUrl)) {
          _cats.add(cat);
          notifyListeners();
        } else {
          break;
        }
      } catch (_) {
        _setError(true);
        break;
      }
    }
  }

  Future<void> loadMore() async {
    _setError(false);
    _setLoading(true);
    await _fillBuffer();
    _setLoading(false);
  }

  void handleSwipe(bool liked) {
    if (_cats.isEmpty) return;
    final cat = _cats.removeAt(0);

    if (liked) {
      final likedCat = LikedCat(cat: cat, likedAt: DateTime.now());
      _likedCats.add(likedCat);
      _likesCount++;
      _local.addLikedCat(likedCat);
    } else {
      _dislikedUrls.add(cat.imageUrl);
      _local.addDislikedUrl(cat.imageUrl);
    }
    notifyListeners();

    if (_cats.length <= 2) _fillBuffer();
  }

  void removeLikedCat(LikedCat liked) {
    _likedCats.remove(liked);
    _likesCount = _likedCats.length;
    _local.removeLikedCat(liked);
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(bool v) {
    _hasError = v;
    notifyListeners();
  }
}
