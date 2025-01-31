import '../styles/app_styles.dart';

class ShelfieScreenConstants {
  static const defaultTag = "@arceuzz23";
  static const defaultTitle = "MY SHELFIE";
  static const backgroundImage = "assets/images/bkg1.jpg";
  static const shelfImage = "assets/images/shelf.png";

  static const styles = ShelfieScreenStyles();
}

class ShareScreenConstants {
  static const String screenshotPathKey = 'screenshot_path';
  static const String galleryPath = '/storage/emulated/0/Pictures';
}

class BookSelectConstants {
  static const String apiUrl = "https://doomscrolling-poc.vercel.app/books/books_list.json";
  static const int maxBookSelection = 6;
  static const int gridCrossAxisCount = 3;
}
