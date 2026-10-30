
enum BookCategory {
  roman('Роман'),
  classic('Классика'),
  fantasy('Фэнтези'),
  sciFi('Фантастика'),
  drama('Драма');

  final String displayName; 
  const BookCategory(this.displayName); 
}

class Book {
  final int id;
  final String title;
  final String author;
  final int year;
  final BookCategory category;
  final String? description; 
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