import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cat.dart';
import 'cat_local_storage.dart';
import 'package:http/http.dart' as http;

class CatService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1';
  static const int _maxRetries = 3;
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;
  final String _apiKey = dotenv.env['CAT_API_KEY'] ?? '';

  final CatLocalStorage _local;

  CatService({http.Client? client, required CatLocalStorage local})
    : _client = client ?? http.Client(),
      _local = local;

  Future<Cat?> fetchRandomCat() async {
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        final response = await _client
            .get(
              Uri.parse('$_baseUrl/images/search?has_breeds=1'),
              headers: _apiKey.isEmpty ? {} : {'x-api-key': _apiKey},
            )
            .timeout(_timeout);
        final cat = _handleResponse(response);
        if (cat != null) await _local.addCat(cat);
        return cat;
      } catch (_) {
        if (attempt == _maxRetries - 1) rethrow;
      }
      await Future.delayed(Duration(seconds: 1 << attempt));
    }
    return null;
  }

  Cat? _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final cat = _parseJson(response.body);
      if (cat != null) _local.addCat(cat);
      return cat;
    }
    throw Exception('Failed to load cat');
  }

  Future<List<Cat>> fetchCachedCats() => _local.getCachedCats();

  Cat? _parseJson(String jsonString) {
    try {
      final data = jsonDecode(jsonString) as List;
      if (data.isEmpty) return null;
      return Cat.fromJson(data.first);
    } catch (_) {
      return null;
    }
  }
}
