import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/entities/book.dart';

class BooksRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Получаем поток книг
  Stream<List<Book>> getBooks() {
    return _firestore.collection('books').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
    });
  }

  // Получаем поток лайков текущего пользователя
  Stream<Set<String>> getUserLikes() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value({});

    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data()?.containsKey('favorites') == true) {
        final list = doc.data()!['favorites'] as List<dynamic>;
        return list.map((e) => e.toString()).toSet();
      }
      return <String>{};
    });
  }

  // Добавляем книгу
  Future<void> addBook(Book book) async {
    await _firestore.collection('books').add(book.toJson());
  }

  // Ставим/снимаем лайк в базе
  Future<void> toggleLike(String bookId, bool isLiked) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userDoc = _firestore.collection('users').doc(uid);
    await userDoc.set({
      'favorites': isLiked 
          ? FieldValue.arrayRemove([bookId]) 
          : FieldValue.arrayUnion([bookId])
    }, SetOptions(merge: true));
  }
}