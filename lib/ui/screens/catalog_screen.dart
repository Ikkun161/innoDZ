import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../widgets/book_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // 1. Храним лайки в Set (как требуют)
  final Set<int> _likedIds = {1, 2}; // По умолчанию пара лайков стоит
  bool _showOnlyFavorites = false; // Фильтр выключен по умолчанию

  // 2. Список книг объявлен вне метода build, как const
  static const List<Book> _books = [
    Book(id: 1, title: 'Мастер и Маргарита', author: 'Михаил Булгаков', year: 1967, category: BookCategory.classic, coverColorValue: 0xFF9E3E37),
    Book(id: 2, title: 'Пикник на обочине', author: 'Аркадий и Борис Стругацкие', year: 1972, category: BookCategory.sciFi, coverColorValue: 0xFF2F7065),
    Book(id: 3, title: '1984', author: 'Джордж Оруэлл', year: 1949, category: BookCategory.drama, coverColorValue: 0xFF3B5B7A),
    Book(id: 4, title: 'Маленький принц', author: 'Антуан де Сент-Экзюпери', year: 1943, category: BookCategory.fantasy, coverColorValue: 0xFFC69C3C),
    Book(id: 5, title: 'Над пропастью во ржи', author: 'Джером Сэлинджер', year: 1951, category: BookCategory.roman, coverColorValue: 0xFF725D84),
    Book(id: 6, title: 'Дюна', author: 'Фрэнк Герберт', year: 1965, category: BookCategory.sciFi, coverColorValue: 0xFFCC7722),
    Book(id: 7, title: 'Гарри Поттер', author: 'Дж. К. Роулинг', year: 1997, category: BookCategory.fantasy, coverColorValue: 0xFF7B1A2C),
    Book(id: 8, title: 'Хоббит', author: 'Дж. Р. Р. Толкин', year: 1937, category: BookCategory.fantasy, coverColorValue: 0xFF3B6B3B),
  ];

  // 3. Метод переключения лайка
  void _toggleLike(int id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 4. Фильтруем список через where (не храним отдельно)
    final displayedBooks = _showOnlyFavorites
        ? _books.where((book) => _likedIds.contains(book.id)).toList()
        : _books;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Каталог книг',
              style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'В избранном: ${_likedIds.length}', // Счётчик
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Переключатель "Только избранные"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showOnlyFavorites = !_showOnlyFavorites;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _showOnlyFavorites ? Colors.red[50] : Colors.transparent,
                      border: Border.all(
                        color: _showOnlyFavorites ? Colors.red[200]! : Colors.grey[400]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 16,
                          color: _showOnlyFavorites ? Colors.red : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Только избранные',
                          style: TextStyle(
                            fontSize: 13,
                            color: _showOnlyFavorites ? Colors.red[800] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Список
          Expanded(
            child: displayedBooks.isEmpty
                ? const Center(child: Text('Ничего не нашлось')) // Заглушка
                : ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: displayedBooks.length,
                      itemBuilder: (context, index) {
                        final book = displayedBooks[index];
                        return BookCard(
                          book: book,
                          isLiked: _likedIds.contains(book.id),
                          onLikeTap: () => _toggleLike(book.id), // Передаем функцию
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}