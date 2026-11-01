import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/books_repository.dart';
import '../../domain/entities/book.dart';
import 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final BooksRepository _repository;
  StreamSubscription? _booksSub;
  StreamSubscription? _likesSub;

  // Флаг фильтра и лайки теперь живут прямо в Cubit
  bool _showOnlyFavorites = false;

  BooksCubit(this._repository) : super(BooksLoadInProgress());

  void load() {
    emit(BooksLoadInProgress());
    _booksSub?.cancel();
    _likesSub?.cancel();

    List<Book> currentBooks = [];
    Set<String> currentLikes = {};

    void emitState() {
      if (isClosed) return;
      emit(BooksLoadSuccess(
        books: currentBooks,
        likedIds: currentLikes,
        showOnlyFavorites: _showOnlyFavorites,
      ));
    }

    _booksSub = _repository.getBooks().listen((books) {
      currentBooks = books;
      emitState();
    }, onError: (e) => emit(BooksLoadFailure('Ошибка загрузки: $e')));

    _likesSub = _repository.getUserLikes().listen((likes) {
      currentLikes = likes;
      emitState();
    }, onError: (e) => emit(BooksLoadFailure('Ошибка лайков: $e')));
  }

  void toggleLike(String bookId) async {
    if (state is BooksLoadSuccess) {
      final currentState = state as BooksLoadSuccess;
      final isLiked = currentState.likedIds.contains(bookId);
      
      final newLikedIds = Set<String>.from(currentState.likedIds);
      if (isLiked) {
        newLikedIds.remove(bookId);
      } else {
        newLikedIds.add(bookId);
      }
      emit(currentState.copyWith(likedIds: newLikedIds));
      
      try {
        await _repository.toggleLike(bookId, isLiked);
      } catch (e) {
        emit(currentState); // Откат при ошибке
      }
    }
  }

  void toggleFilter() {
    _showOnlyFavorites = !_showOnlyFavorites;
    if (state is BooksLoadSuccess) {
      final currentState = state as BooksLoadSuccess;
      emit(currentState.copyWith(showOnlyFavorites: _showOnlyFavorites));
    }
  }

  Future<void> addBook(Book book) async {
    try {
      await _repository.addBook(book);
    } catch (e) {
      // Обработка ошибки
    }
  }

  @override
  Future<void> close() {
    _booksSub?.cancel();
    _likesSub?.cancel();
    return super.close();
  }
}