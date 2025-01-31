class BookSelectionState {
  final List<Map<String, dynamic>> bookList;
  final List<Map<String, dynamic>> filteredBookList;
  final List<bool> selectedBooks;
  final List<String> selectedBookTitles;
  final int selectedCount;
  final bool isLoading;
  final String? errorMessage;
  final String? errorDetails;

  BookSelectionState({
    required this.bookList,
    required this.filteredBookList,
    required this.selectedBooks,
    required this.selectedBookTitles,
    required this.selectedCount,
    required this.isLoading,
    this.errorMessage,
    this.errorDetails,
  });

  BookSelectionState copyWith({
    List<Map<String, dynamic>>? bookList,
    List<Map<String, dynamic>>? filteredBookList,
    List<bool>? selectedBooks,
    List<String>? selectedBookTitles,
    int? selectedCount,
    bool? isLoading,
    String? errorMessage,
    String? errorDetails,
  }) {
    return BookSelectionState(
      bookList: bookList ?? this.bookList,
      filteredBookList: filteredBookList ?? this.filteredBookList,
      selectedBooks: selectedBooks ?? this.selectedBooks,
      selectedBookTitles: selectedBookTitles ?? this.selectedBookTitles,
      selectedCount: selectedCount ?? this.selectedCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorDetails: errorDetails,
    );
  }
}