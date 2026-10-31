import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/book.dart';
import '../widgets/book_card.dart';

const String baseUrl = 'https://6ae4f7db28393034b08e0f2d.mockapi.io';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Book> _books = [];
  final Set<String> _likedIds = {};
  bool _showOnlyFavorites = false;

  bool _isLoading = true;
  String? _error;

  // Контроллеры для полей ввода (теперь их два)
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/books'));
      if (response.statusCode != 200) {
        throw Exception('Статус ${response.statusCode}');
      }
      final decodedBody = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = jsonDecode(decodedBody);

      setState(() {
        _books = jsonList.map((json) => Book.fromJson(json)).toList();
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Метод для отправки POST-запроса
  Future<void> _addBook(String title, String author) async {
    final newBook = Book(
      title: title,
      author: author.isEmpty ? 'Неизвестный автор' : author,
      year: DateTime.now().year,
      category: 'Новинка',
      coverColorValue: 'FF607D8B',
    );

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/books'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(newBook.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }

      final decodedBody = utf8.decode(response.bodyBytes);
      final createdBook = Book.fromJson(jsonDecode(decodedBody));

      setState(() {
        _books.insert(0, createdBook);
      });

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

  // Вызов диалогового окна
  void _showAddBookDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                const Text(
                  'Новая книга',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Поле "Название"
                const Text('Название *', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Война и мир',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),

                // Поле "Автор"
                const Text('Автор', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    hintText: 'Необязательно',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        Navigator.pop(context); 
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
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
                        
                        Navigator.pop(context); 
                        await _addBook(title, author); 
                        
                        _titleController.clear();
                        _authorController.clear();
                      },
                      child: const Text('Добавить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'В каталоге: ${_books.length} • В избранном: ${_likedIds.length}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),

      // Кнопка "+" теперь открывает диалог
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // Кнопка фильтра 
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

          // Список
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Ошибка: $_error', textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchBooks,
                              child: const Text('Обновить'),
                            ),
                          ],
                        ),
                      )
                    : displayedBooks.isEmpty
                        ? const Center(child: Text('Ничего не нашлось'))
                        : ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                              itemCount: displayedBooks.length,
                              itemBuilder: (context, index) {
                                final book = displayedBooks[index];
                                return BookCard(
                                  book: book,
                                  isLiked: _likedIds.contains(book.id),
                                  
                                  onLikeTap: book.id != null 
                                      ? () => _toggleLike(book.id!) 
                                      : () {},
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