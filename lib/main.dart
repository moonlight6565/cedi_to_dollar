import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// Entry point of the Currency Converter application.
void main() {
  runApp(const MyApp());
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CediDollar Converter',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
       home: const HomePage(),
    );
  }
}

