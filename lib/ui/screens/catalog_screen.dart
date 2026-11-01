import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:math';

import '../../domain/entities/book.dart';
import '../widgets/book_card.dart';
import 'auth_screen.dart';
import 'book_details_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<String> _likedIds = {};
  bool _showOnlyFavorites = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // Поток данных из Firestore (объявляем вне build)
  final Stream<QuerySnapshot<Map<String, dynamic>>> _booksStream =
      FirebaseFirestore.instance.collection('books').snapshots();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _addBook(String title, String author, String category) async {
    // Список красивых цветов для обложек
    final List<String> colors = [
      'FF9E3E37',
      'FF2F7065',
      'FF3B5B7A',
      'FFC69C3C',
      'FF725D84',
      'FFCC7722',
      'FF7B1A2C',
      'FF3B6B3B',
    ];
    // Выбираем случайный цвет
    final randomColor = colors[Random().nextInt(colors.length)];

    final newBook = Book(
      title: title,
      author: author.isEmpty ? 'Неизвестный автор' : author,
      year: DateTime.now().year,
      category: category.isEmpty
          ? 'Разное'
          : category, // Если пусто, ставим "Разное"
      coverColorValue: randomColor, // Используем случайный цвет
    );

    try {
      await FirebaseFirestore.instance
          .collection('books')
          .add(newBook.toJson());

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Книга добавлена!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  void _toggleLike(String id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  void _showAddBookDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            // Добавили скролл, чтобы окно не ломалось на маленьких экранах
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Новая книга',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Поле Название
                  const Text(
                    'Название *',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Война и мир',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Поле Автор
                  const Text(
                    'Автор',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      hintText: 'Необязательно',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // НОВОЕ Поле Категория
                  const Text(
                    'Категория',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      hintText: 'Например: Фантастика',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Кнопки
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _titleController.clear();
                          _authorController.clear();
                          _categoryController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Отмена'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          if (_titleController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Введите название')),
                            );
                            return;
                          }
                          final title = _titleController.text;
                          final author = _authorController.text;
                          final category = _categoryController.text;

                          Navigator.pop(context); // Закрываем диалог

                          // Передаем все три параметра
                          await _addBook(title, author, category);

                          _titleController.clear();
                          _authorController.clear();
                          _categoryController.clear();
                        },
                        child: const Text('Добавить'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Каталог книг',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Счетчик избранного теперь считается динамически (упрощенно)
            Text(
              'В избранном: ${_likedIds.length}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            tooltip: 'Выйти',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // Фильтр
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      setState(() => _showOnlyFavorites = !_showOnlyFavorites),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: _showOnlyFavorites
                            ? primaryColor
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: _showOnlyFavorites
                              ? primaryColor
                              : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Только избранные',
                          style: TextStyle(
                            fontSize: 13,
                            color: _showOnlyFavorites
                                ? primaryColor
                                : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Список через StreamBuilder
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _booksStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Каталог пуст. Добавьте книгу!'),
                  );
                }

                // Превращаем документы в модели
                final books = docs
                    .map((doc) => Book.fromFirestore(doc))
                    .toList();

                // Применяем фильтр
                final displayedBooks = _showOnlyFavorites
                    ? books
                          .where((book) => _likedIds.contains(book.id))
                          .toList()
                    : books;

                if (displayedBooks.isEmpty) {
                  return const Center(child: Text('Ничего не нашлось'));
                }

                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(overscroll: false),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 80,
                    ),
                    itemCount: displayedBooks.length,
                    itemBuilder: (context, index) {
                      final book = displayedBooks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailsScreen(book: book),
                            ),
                          );
                        },
                        child: BookCard(
                          book: book,
                          isLiked: _likedIds.contains(book.id),
                          onLikeTap: book.id != null
                              ? () => _toggleLike(book.id!)
                              : () {},
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
