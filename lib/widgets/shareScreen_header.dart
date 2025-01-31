import 'dart:ui';
import 'package:flutter/material.dart';

class shareScreen_header extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onClose;

  const shareScreen_header({
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
          ),
          iconSize: 40,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black),
          onPressed: onBack,
        ),
        const Spacer(),
        IconButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.black)),
          ),
          iconSize: 40,
          icon: const Icon(Icons.close, size: 20, color: Colors.black),
          onPressed: onClose,
        ),
      ],
    );
  }
}