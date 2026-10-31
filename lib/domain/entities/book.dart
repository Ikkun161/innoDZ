class Book {
  final String? id; // Теперь ID строка и может быть null (для новых книг)
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

  
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString(), // На всякий случай переводим в строку
      title: json['title'] ?? 'Без названия',
      author: json['author'] ?? 'Неизвестен',
      year: json['year'] is int ? json['year'] : int.tryParse(json['year'].toString()) ?? 0,
      category: json['category'] ?? 'Разное',
      coverColorValue: json['coverColor'] ?? 'FFCCCCCC',
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