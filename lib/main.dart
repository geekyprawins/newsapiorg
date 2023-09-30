import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapi/pages/news_page.dart';
import 'package:newsapi/repositories/news_repo.dart';
import 'package:newsapi/secrets.dart';

import 'blocs/news_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsRepository newsRepository = NewsRepository(apiKey: API_KEY);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NewsBloc(newsRepository),
        child: const NewsPage(),
      ),
    );
  }
}
