import 'package:flutter/material.dart';
import 'package:shelfie/screens/bookSelectScreen.dart';
import 'package:shelfie/screens/shelfieScreen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookSelectScreen(),
    );
  }
}



