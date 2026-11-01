import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String? id;
  final String title;
  final String author;
  final int year;
  final String category;
  final String coverColorValue;

  const Book({
    this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.category,
    required this.coverColorValue,
  });

  // Для Firebase
  factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Book(
      id: doc.id, // ID берем из документа
      title: data['title'] ?? 'Без названия',
      author: data['author'] ?? 'Неизвестен',
      year: data['year'] is int ? data['year'] : int.tryParse(data['year'].toString()) ?? 0,
      category: data['category'] ?? 'Разное',
      coverColorValue: data['coverColor'] ?? 'FF9E9E9E',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'category': category,
      'coverColor': coverColorValue,
    };
  }
}