import 'dart:ui';
import 'package:flutter/material.dart';

class shelfieScreen_header extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCustomize;
  final VoidCallback onClose;

  const shelfieScreen_header({
    required this.onBack,
    required this.onCustomize,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.white)),
          ),
          iconSize: 40,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
          onPressed: onBack,
        ),
        const Spacer(),
        TextButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.white)),
          ),
          onPressed: onCustomize,
          child: const Text(
            'Customize',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        IconButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.white)),
          ),
          iconSize: 40,
          icon: const Icon(Icons.close, size: 20, color: Colors.white),
          onPressed: onClose,
        ),
      ],
    );
  }
}