import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/news_bloc.dart';
import '../widgets/news_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final List<String> categories = [
    'business',
    'technology',
    'health',
    'science',
    'sports',
  ];

  @override
  Widget build(BuildContext context) {
    final newsBloc = BlocProvider.of<NewsBloc>(context);
    String selectedCategory = categories[0]; // Default category

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select a category',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              ),
              style: const TextStyle(fontSize: 16.0, color: Colors.black), // Text style
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  newsBloc.add(FetchNewsEvent(category: selectedCategory));
                }
              },
            ),
          ),
          BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state is NewsInitialState) {
                return const Center(
                  child: Text('Select a category to fetch news.'),
                );
              } else if (state is NewsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is NewsLoadedState) {
                final articles = state.articles;
                return Expanded(
                  child: ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return NewsCard(
                        title: article.title,
                        description: article.description,
                        imageUrl: article.urlToImage,
                      );
                    },
                  ),
                );
              } else if (state is NewsErrorState) {
                return const Center(
                  child: Text('Failed to load news.'),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newsBloc.add(FetchNewsEvent(category: selectedCategory));
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}