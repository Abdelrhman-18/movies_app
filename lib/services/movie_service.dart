import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  static const String baseUrl =
      'https://yts.gg/api/v2/list_movies.json';

  Future<List<dynamic>> getMovies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['movies'] ?? [];
    } else {
      throw Exception('Failed to load movies');
    }
  }
}