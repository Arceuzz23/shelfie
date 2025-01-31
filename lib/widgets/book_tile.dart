import 'package:flutter/material.dart';

class BookTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isSelected;
  final VoidCallback onSelected;

  const BookTile({
    required this.imagePath,
    required this.title,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: isSelected ? Border.all(color: Colors.green, width: 4) : null,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(imagePath, fit: BoxFit.cover, height: 180, width: 120),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.check_circle, color: Colors.green, size: 30),
            ),
        ],
      ),
    );
  }
}
