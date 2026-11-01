import '../../domain/entities/book.dart';

sealed class BooksState {}

class BooksLoadInProgress extends BooksState {}

class BooksLoadSuccess extends BooksState {
  final List<Book> books;
  final Set<String> likedIds;
  final bool showOnlyFavorites;

  BooksLoadSuccess({
    required this.books,
    required this.likedIds,
    this.showOnlyFavorites = false,
  });

  BooksLoadSuccess copyWith({
    List<Book>? books,
    Set<String>? likedIds,
    bool? showOnlyFavorites,
  }) {
    return BooksLoadSuccess(
      books: books ?? this.books,
      likedIds: likedIds ?? this.likedIds,
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
    );
  }
}

class BooksLoadFailure extends BooksState {
  final String message;
  BooksLoadFailure(this.message);
}