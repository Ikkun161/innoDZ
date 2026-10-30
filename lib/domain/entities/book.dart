enum BookCategory { roman, classic, fantasy, sciFi, drama }

class Book {
  final int id;
  final String title;
  final String author;
  final int year;
  final BookCategory category;
  final String? description; // Необязательное поле
  final int coverColorValue; 

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.category,
    required this.coverColorValue,
    this.description,
  });
}