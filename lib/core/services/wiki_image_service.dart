import 'dart:convert';

import 'package:http/http.dart' as http;

class WikiImageService {
  WikiImageService._();
  static final WikiImageService instance = WikiImageService._();

  final Map<String, String?> _cache = {};

  Future<String?> getImageUrl(String word) async {
    if (_cache.containsKey(word)) return _cache[word];

    try {
      final uri = Uri.parse(
        'https://es.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(word)}',
      );
      final response = await http.get(uri, headers: {
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final thumbnail = data['thumbnail'] as Map<String, dynamic>?;
        final url = thumbnail?['source'] as String?;
        _cache[word] = url;
        return url;
      }
    } catch (_) {}

    _cache[word] = null;
    return null;
  }
}
