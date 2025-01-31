import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class BookRack extends StatelessWidget {
  final List<String> books;
  final Function(int, int) onReorder;
  final double heightMultiplier;
  final double widthMultiplier;

  const BookRack({
    required this.books,
    required this.onReorder,
    required this.heightMultiplier,
    required this.widthMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildRackBackground(),
        _buildBooksList(),
      ],
    );
  }

  Widget _buildRackBackground() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: 170 * heightMultiplier,
        width: 420 * widthMultiplier,
        child: Image.asset(ShelfieScreenConstants.shelfImage, fit: BoxFit.fitWidth),
      ),
    );
  }

  Widget _buildBooksList() {
    return Row(
      children: [
        SizedBox(width: 70 * widthMultiplier),
        SizedBox(
          height: 160 * heightMultiplier,
          width: 330 * widthMultiplier,
          child: ReorderableListView(
            scrollDirection: Axis.horizontal,
            onReorder: onReorder,
            children: books.asMap().entries.map((entry) {
              return _buildBookTile(entry.value, entry.key);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBookTile(String bookUrl, int index) {
    return Padding(
      key: ValueKey('$bookUrl$index'),
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: 95 * widthMultiplier,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(bookUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
