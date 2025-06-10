import 'package:flutter/material.dart';
import 'package:tugas13_flutter/pages/home_page.dart';
import 'package:tugas13_flutter/pages/login_screen.dart';
import 'package:tugas13_flutter/pages/regist_screen.dart';
import 'package:tugas13_flutter/pages/splash_scree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manajemen Buku',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
