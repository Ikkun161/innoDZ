import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

import '../../domain/entities/book.dart';
import '../blocs/books_cubit.dart'; 
import '../blocs/books_state.dart'; 

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final coverColor = Color(
      int.tryParse(book.coverColorValue, radix: 16) ?? 0xFF9E9E9E,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          BlocBuilder<BooksCubit, BooksState>(
            builder: (context, state) {
              bool isLiked = false;
              if (state is BooksLoadSuccess) {
                isLiked = state.likedIds.contains(book.id);
              }
              return Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      if (book.id != null) {
                        context.read<BooksCubit>().toggleLike(book.id!);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100), 
            
            // 1. Большая обложка
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                height: 280, 
                decoration: BoxDecoration(
                  color: coverColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    book.title.isNotEmpty ? book.title[0] : '?',
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. Текстовый блок (Название, Автор, Теги)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${book.author} • ${book.year}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),

                  // Теги
                  Wrap(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1), // Светло-бирюзовый
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          book.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1B6A5A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Белая карточка с информацией
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Автор', book.author),
                    const Divider(height: 24),
                    _buildInfoRow('Год', book.year.toString()),
                    const Divider(height: 24),
                    _buildInfoRow('Категория', book.category),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. Описание
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Описание',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Это увлекательная книга в жанре "${book.category}". '
                    'Она рассказывает захватывающую историю, которая точно не оставит '
                    'читателя равнодушным. Погрузитесь в мир, созданный автором ${book.author}.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Отступ снизу
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}