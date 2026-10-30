import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isLiked;
  final VoidCallback onLikeTap; 

  const BookCard({
    super.key,
    required this.book,
    required this.isLiked,
    required this.onLikeTap,
  });

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
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${book.author} • ${book.year}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    book.category.name.toUpperCase(), // Выводим название enum
                    style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    return Stack(
      children: [
        Container(
          width: 70,
          height: 100,
          decoration: BoxDecoration(
            color: Color(book.coverColorValue),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
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
        // Слой 3: Кнопка-лайк с колбэком
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: onLikeTap, 
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey[400],
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}