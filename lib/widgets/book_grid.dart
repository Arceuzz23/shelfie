import 'package:flutter/material.dart';
import 'book_tile.dart';

class BookGrid extends StatelessWidget {
  final List<dynamic> filteredBookList;
  final List<dynamic> bookList;
  final List<bool> selectedBooks;
  final Function(int) onBookSelected;

  const BookGrid({
    Key? key,
    required this.filteredBookList,
    required this.bookList,
    required this.selectedBooks,
    required this.onBookSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return filteredBookList.isNotEmpty
        ? GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 1,
        childAspectRatio: 0.6,
      ),
      itemCount: filteredBookList.length,
      itemBuilder: (context, index) {
        return BookTile(
          imagePath: filteredBookList[index]['cover_url'],
          title: filteredBookList[index]['title'],
          isSelected: selectedBooks[bookList.indexOf(filteredBookList[index])],
          onSelected: () => onBookSelected(index),
        );
      },
    )
        : const Center(
      child: Text("No books found."),
    );
  }
}
