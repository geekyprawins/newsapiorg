import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapi/models/news_model.dart';

class NewsRepository {
  final String apiKey;

  NewsRepository({required this.apiKey});

  Future<List<NewsModel>> fetchNews(String category) async {
    final apiUrl = 'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final articles = jsonData['articles'] as List<dynamic>;
      return articles.map((article) {
        return NewsModel(
          title: article['title'] ?? 'No Title',
          description: article['description'] ?? 'No Description',
          urlToImage: article['urlToImage'] ?? 'https://picsum.photos/100/100',
        );
      }).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
