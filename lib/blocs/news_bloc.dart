import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsapi/models/news_model.dart';
import '../repositories/news_repo.dart';

// Events
abstract class NewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNewsEvent extends NewsEvent {
  final String category;

  FetchNewsEvent({required this.category});

  @override
  List<Object> get props => [category];
}

// States
abstract class NewsState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {
  final List<NewsModel> articles;

  NewsLoadedState({required this.articles});

  @override
  List<Object> get props => [articles];
}

class NewsErrorState extends NewsState {}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;
  NewsBloc(this.newsRepository) : super(NewsInitialState()) {
    on<FetchNewsEvent>((event, emit) async {
      emit(NewsLoadingState());
      try {
        final articles = await newsRepository.fetchNews(event.category);
        emit(NewsLoadedState(articles: articles));
      } catch (e) {
        emit(NewsErrorState());
      }
    });
  }
}
