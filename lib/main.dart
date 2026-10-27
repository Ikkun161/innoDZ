import 'package:flutter/material.dart';

void main() {
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}

// Модель данных
class Book {
  final String title;
  final String author;
  final int year;
  final List<String> tags;
  final Color coverColor;

  Book({
    required this.title,
    required this.author,
    required this.year,
    required this.tags,
    required this.coverColor,
  });
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Данные книг (8 штук)
    final List<Book> books = [
      Book(title: 'Мастер и Маргарита', author: 'Михаил Булгаков', year: 1967, tags: ['Роман', 'Классика'], coverColor: const Color(0xFF9E3E37)),
      Book(title: 'Пикник на обочине', author: 'Аркадий и Борис Стругацкие', year: 1972, tags: ['Фантастика'], coverColor: const Color(0xFF2F7065)),
      Book(title: '1984', author: 'Джордж Оруэлл', year: 1949, tags: ['Антиутопия', 'Классика'], coverColor: const Color(0xFF3B5B7A)),
      Book(title: 'Маленький принц', author: 'Антуан де Сент-Экзюпери', year: 1943, tags: ['Сказка'], coverColor: const Color(0xFFC69C3C)),
      Book(title: 'Над пропастью во ржи', author: 'Джером Сэлинджер', year: 1951, tags: ['Роман'], coverColor: const Color(0xFF725D84)),
      Book(title: 'Дюна', author: 'Фрэнк Герберт', year: 1965, tags: ['Фантастика'], coverColor: const Color(0xFFCC7722)),
      Book(title: 'Гарри Поттер и философский камень', author: 'Дж. К. Роулинг', year: 1997, tags: ['Фэнтези'], coverColor: const Color(0xFF7B1A2C)),
      Book(title: 'Хоббит, или Туда и обратно', author: 'Дж. Р. Р. Толкин', year: 1937, tags: ['Фэнтези'], coverColor: const Color(0xFF3B6B3B)),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Каталог книг',
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(book: books[index]);
        },
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCover(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Защита от overflow
                ),
                const SizedBox(height: 2),
                Text(
                  '${book.author} • ${book.year}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Защита от overflow
                ),
                const SizedBox(height: 8),
                
                // Теги (Wrap)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: book.tags.map((tag) => _buildTag(tag)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Обложка (Stack)
  Widget _buildCover() {
    return Stack(
      children: [
        // Слой 1: Цветной фон
        Container(
          width: 70,
          height: 100,
          decoration: BoxDecoration(
            color: book.coverColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // Слой 2: Первая буква по центру
        Positioned.fill(
          child: Center(
            child: Text(
              book.title[0],
              style: const TextStyle(
                fontSize: 36, 
                fontWeight: FontWeight.w400, 
                color: Colors.white54,
              ),
            ),
          ),
        ),
        // Слой 3: Иконка лайка 
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.red, 
              size: 14,
            ),
          ),
        ),
      ],
    );
  }

  // Плашка тега
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
      ),
    );
  }
}