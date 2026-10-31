import 'package:flutter/material.dart';
import 'ui/screens/catalog_screen.dart';

// Тот самый цвет из макета (тёмно-бирюзовый)
const Color primaryBrandColor = Color(0xFF1B6A5A); 

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
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Светло-серый фон
        primaryColor: primaryBrandColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBrandColor,
          primary: primaryBrandColor,
        ),
        useMaterial3: true,
        // Настраиваем кнопки по умолчанию
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBrandColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        // Настраиваем кнопку "+" (FloatingActionButton)
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryBrandColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: const CatalogScreen(),
    );
  }
}