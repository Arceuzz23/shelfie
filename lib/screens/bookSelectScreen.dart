


import 'package:flutter/material.dart';
import '../models/book_selection_state.dart';
import '../services/book_service.dart';
import '../utils/api_exception.dart';
import '../widgets/book_grid.dart';
import '../widgets/error_display.dart';
import '../widgets/loading_screen.dart';
import '../widgets/search_bar.dart';

class BookSelectScreen extends StatefulWidget {
  const BookSelectScreen({super.key});

  @override
  State<BookSelectScreen> createState() => _BookSelectScreenState();
}

class _BookSelectScreenState extends State<BookSelectScreen> {
  final TextEditingController _bookSearchController = TextEditingController();
  final BookService _bookService = BookService();
  late BookSelectionState _state;

  @override
  void initState() {
    super.initState();
    _state = BookSelectionState(
      bookList: [],
      filteredBookList: [],
      selectedBooks: [],
      selectedBookTitles: [],
      selectedCount: 0,
      isLoading: false,
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _state = _state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorDetails: null,
    ));

    try {
      final books = await _bookService.fetchBooks();
      final List<Map<String, dynamic>> typedBooks = books.cast<Map<String, dynamic>>().toList();

      if (mounted) {
        setState(() {
          _state = _state.copyWith(
            bookList: typedBooks,
            filteredBookList: typedBooks,
            selectedBooks: List.generate(typedBooks.length, (index) => false),
            selectedBookTitles: List.generate(typedBooks.length, (index) => ""),
            isLoading: false,
          );
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _state = _state.copyWith(
            isLoading: false,
            errorMessage: e.message,
            errorDetails: e.details,
          );
        });
      }
    }
  }
  void _handleBookSelection(int filteredIndex) {
    final bookIndex = _state.bookList.indexOf(_state.filteredBookList[filteredIndex]);
    final newSelectedBooks = List<bool>.from(_state.selectedBooks);
    int newSelectedCount = _state.selectedCount;

    if (newSelectedBooks[bookIndex]) {
      newSelectedBooks[bookIndex] = false;
      newSelectedCount--;
    } else if (newSelectedCount < 6) {
      newSelectedBooks[bookIndex] = true;
      newSelectedCount++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("You must select exactly 6 books."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _state = _state.copyWith(
        selectedBooks: newSelectedBooks,
        selectedCount: newSelectedCount,
      );
    });
  }

  void _searchBooks(String query) {
    setState(() {
      _state = _state.copyWith(
        filteredBookList: _state.bookList.where((book) {
          return book['title'].toString().toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    });
  }

  Future<List<String>> _getSelectedBooks() async {
    final selectedTitles = <String>[];
    for (int i = 0; i < _state.selectedBooks.length; i++) {
      if (_state.selectedBooks[i]) {
        selectedTitles.add(_state.bookList[i]['cover_url']);
      }
    }
    return selectedTitles;
  }

  @override
  Widget build(BuildContext context) {
    if (_state.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F0EB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_state.errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F0EB),
        body: SafeArea(
          child: ErrorDisplay(
            message: _state.errorMessage!,
            details: _state.errorDetails,
            onRetry: _initializeData,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                IconButton(
                  iconSize: 40,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Let's build your Shelfie!",
                  style: TextStyle(
                    fontFamily: "Canela",
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Pick exactly 6 books or TV shows that you love the most to create a Shelfie as unique as you are!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                CustomSearchBar(
                  controller: _bookSearchController,
                  onSearch: _searchBooks,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BookGrid(
                    filteredBookList: _state.filteredBookList,
                    bookList: _state.bookList,
                    selectedBooks: _state.selectedBooks,
                    onBookSelected: _handleBookSelection,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (_state.selectedCount != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("You need to select exactly 6 books to proceed."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      final selectedBooks = await _getSelectedBooks();
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingScreen(selectedBooks: selectedBooks),
                          ),
                        );
                      }
                    },

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    backgroundColor: const Color(0xFF281e28),
                    child: const Text(
                      "Create my shelfie",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Canela",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
