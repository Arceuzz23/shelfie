import 'package:flutter/material.dart';


class ShareScreenStyles {
  static const backgroundColor = Color(0xFFF5F0EB);
  static const screenPadding = EdgeInsets.fromLTRB(15, 30, 15, 8);

  static const taglineStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: "Canela",
    fontSize: 18,
  );

  static const actionLabelStyle = TextStyle(
    fontFamily: "Canela",
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );
}

class ShelfieScreenStyles {
  const  ShelfieScreenStyles();

  final titleStyle = const TextStyle(
    fontFamily: "Faster One",
    color: Colors.white,
    fontSize: 40,
  );

  final tagStyle = const TextStyle(
    fontFamily: "Canela",
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  final buttonTextStyle = const TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontFamily: "Canela",
  );
}

class BookSelectScreenStyles {
  // Colors
  static const backgroundColor = Color(0xFFF5F0EB);
  static const errorColor = Colors.red;
  static final selectedBorderColor = Colors.green.shade800;
  static final selectedCheckColor = Colors.green.shade100;

  // Text Styles
  static const titleStyle = TextStyle(
    fontFamily: "Canela",
    fontSize: 45,
    fontWeight: FontWeight.bold,
  );

  static const subtitleStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  // Messages
  static const shelfieTitle = "Let's build your Shelfie!";
  static const shelfieInstructions =
      "Pick exactly 6 books or TV shows that you love the most to create a Shelfie as unique as you are!";
  static const maxBooksError = "You must select exactly 6 books.";
  static const exactBooksError = "You need to select exactly 6 books to proceed.";

  // Padding
  static const screenPadding = EdgeInsets.symmetric(horizontal: 16.0);
}
