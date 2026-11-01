import '../../domain/entities/book.dart';

sealed class BooksState {}

// 1. Идет загрузка
class BooksLoadInProgress extends BooksState {}

// 2. Данные успешно загружены
class BooksLoadSuccess extends BooksState {
  final List<Book> books;
  BooksLoadSuccess(this.books);
}

// 3. Произошла ошибка
class BooksLoadFailure extends BooksState {
  final String message;
  BooksLoadFailure(this.message);
}