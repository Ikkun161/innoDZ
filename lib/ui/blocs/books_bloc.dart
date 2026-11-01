import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book.dart';
import 'books_event.dart';
import 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc() : super(BooksLoadInProgress()) {
    on<BooksLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    BooksLoadRequested event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoadInProgress());

    // emit.forEach подписывается на поток данных из Firestore
    await emit.forEach(
      FirebaseFirestore.instance.collection('books').snapshots(),
      onData: (snapshot) => BooksLoadSuccess(
        snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList(),
      ),
      onError: (error, stackTrace) =>
          BooksLoadFailure('Не удалось загрузить каталог: $error'),
    );
  }
}