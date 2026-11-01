import '../../domain/entities/book.dart';

sealed class BooksEvent {}

class BooksLoadRequested extends BooksEvent {}

class BookLikeToggled extends BooksEvent {
  final String bookId;
  BookLikeToggled(this.bookId);
}

class FilterToggled extends BooksEvent {}

class BookAdded extends BooksEvent {
  final Book book;
  BookAdded(this.book);
}