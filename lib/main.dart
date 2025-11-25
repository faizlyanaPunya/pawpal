import 'package:flutter/material.dart';
import 'views/splashpage.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        // colorScheme: ColorScheme.fromSeed(seedColor:  Colors.black),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 87, 152, 154),
          foregroundColor: Colors.white,
        ),
      ),
      home: Splashpage(),
    );
  }
}
