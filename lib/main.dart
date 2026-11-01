import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/books_repository.dart';
import 'ui/blocs/books_cubit.dart'; 
import 'ui/screens/auth_screen.dart';
import 'ui/screens/catalog_screen.dart';

// Твой фирменный цвет
const Color primaryBrandColor = Color(0xFF1B6A5A);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CatalogApp());
}

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Убирает ленточку DEBUG в углу
      debugShowCheckedModeBanner: false, 
      
      // Возвращаем твою цветовую тему
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        primaryColor: primaryBrandColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBrandColor,
          primary: primaryBrandColor,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBrandColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return BlocProvider(
              create: (_) => BooksCubit(BooksRepository())..load(),
              child: const CatalogScreen(),
            );
          }
          return const AuthScreen();
        },
      ),
    );
  }
}