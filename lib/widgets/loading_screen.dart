import 'package:flutter/material.dart';
import '../screens/shelfieScreen.dart';
import '../widgets/loading_overlay.dart';

class LoadingScreen extends StatefulWidget {
  final List<String> selectedBooks;

  const LoadingScreen({
    Key? key,
    required this.selectedBooks,
  }) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToShelfieScreen();
  }

  Future<void> _navigateToShelfieScreen() async {
    // Simulate loading time - replace with actual image generation logic
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShelfieScreen(
            selectedBooks: widget.selectedBooks,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightMultiplier = MediaQuery.of(context).size.height/949.3333333333334;

    return Scaffold(
      body: LoadingOverlay(heightMultiplier: heightMultiplier),
    );
  }
}