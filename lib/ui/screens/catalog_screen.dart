import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import '../../domain/entities/book.dart';
import '../blocs/books_bloc.dart';
import '../blocs/books_event.dart';
import '../blocs/books_state.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _addBook(String title, String author, String category) async {
    final List<String> colors = [
      'FF9E3E37', 'FF2F7065', 'FF3B5B7A', 'FFC69C3C',
      'FF725D84', 'FFCC7722', 'FF7B1A2C', 'FF3B6B3B',
    ];
    final randomColor = colors[Random().nextInt(colors.length)];

    final newBook = Book(
      title: title,
      author: author.isEmpty ? 'Неизвестный автор' : author,
      year: DateTime.now().year,
      category: category.isEmpty ? 'Разное' : category,
      coverColorValue: randomColor,
    );

    try {
      // Добавляем в Firestore. Bloc сам заметит изменение и обновит список.
      await FirebaseFirestore.instance.collection('books').add(newBook.toJson());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Книга добавлена!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Новая книга', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  const Text('Название *', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Война и мир',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Автор', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      hintText: 'Необязательно',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Категория', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      hintText: 'Например: Фантастика',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),

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
                          
                          Navigator.pop(context); 
                          
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
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _showOnlyFavorites = !_showOnlyFavorites),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: _showOnlyFavorites ? primaryColor : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: _showOnlyFavorites ? primaryColor : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Только избранные',
                          style: TextStyle(
                            fontSize: 13,
                            color: _showOnlyFavorites ? primaryColor : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Список через BlocBuilder (ЗАМЕНИЛИ STREAMBUILDER)
          Expanded(
            child: BlocBuilder<BooksBloc, BooksState>(
              builder: (context, state) {
                // 1. Состояние загрузки
                if (state is BooksLoadInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Состояние ошибки
                if (state is BooksLoadFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Отправляем событие загрузки заново
                              context.read<BooksBloc>().add(BooksLoadRequested());
                            },
                            child: const Text('Обновить'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. Состояние с данными
                if (state is BooksLoadSuccess) {
                  final books = state.books;
                  
                  // Применяем локальный фильтр
                  final displayedBooks = _showOnlyFavorites
                      ? books.where((book) => _likedIds.contains(book.id)).toList()
                      : books;

                  if (displayedBooks.isEmpty) {
                    return const Center(child: Text('Ничего не нашлось'));
                  }

                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                      itemCount: displayedBooks.length,
                      itemBuilder: (context, index) {
                        final book = displayedBooks[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsScreen(book: book),
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
                }

                // Заглушка, если состояние неизвестно
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}