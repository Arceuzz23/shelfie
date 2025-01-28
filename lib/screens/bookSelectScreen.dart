import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shelfie/screens/shelfieScreen.dart';

class BookSelectScreen extends StatefulWidget {
  const BookSelectScreen({super.key});

  @override
  State<BookSelectScreen> createState() => _BookSelectScreenState();
}

class _BookSelectScreenState extends State<BookSelectScreen> {
  TextEditingController bookSearchController = TextEditingController();

  bool isLoading = false;
  int selectedCount = 0; // Counter for selected books
  List<dynamic> bookList = [];
  List<dynamic> filteredBookList = []; // Holds the filtered list after search
  List<bool> selectedBooks = []; // Track selection state of books
  List<String> selectedBookTitles = []; // Track selected book titles

  Future<List<dynamic>?> fetchData() async {
    String apiUrl = "https://doomscrolling-poc.vercel.app/books/books_list.json";
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var books = data['data']['books'];
      setState(() {
        bookList = books; // Update the bookList with fetched data
        filteredBookList = books; // Set filtered list to all books initially
        selectedBooks = List.generate(books.length, (
            index) => false); // Initialize selection state for each book
        selectedBookTitles = List.generate(
            books.length, (index) => ""); // Initialize selected book titles
        isLoading = false;
      });
      return books;
    }
    setState(() {
      isLoading = false;
    });
    return null;
  }

  Future<void> getSelectedBooks() async {
    // Iterate through the selected books to map their titles
    for (int i = 0; i < selectedBooks.length; i++) {
      selectedBookTitles[i] =
      bookList[i]['title']; // Assign the title of each book from the book list
    }

    print(selectedBookTitles); // Debug: Print the list of selected book titles
    print(
        selectedBooks); // Debug: Print the list of selected books (boolean flags or identifiers)

    // Update the `selectedBookTitles` list to retain only the titles of selected books
    for (int i = 0; i < selectedBooks.length; i++) {
      if (selectedBooks[i] != false) {
        selectedBookTitles[i] =
        selectedBookTitles[i]; // Retain the title if the book is selected
      } else {
        selectedBookTitles[i] =
        ""; // Clear the title if the book is not selected
      }
    }

    // Replace book titles with their corresponding cover URLs for selected books
    for (int i = 0; i < selectedBooks.length; i++) {
      if (selectedBookTitles[i] == bookList[i]['title']) {
        selectedBookTitles[i] =
        bookList[i]['cover_url']; // Replace the title with the cover URL
      }
    }

    // Remove any empty strings from the `selectedBookTitles` list to clean up unselected books
    selectedBookTitles.removeWhere((item) => item.isEmpty);
  }

  @override
  void initState() {
    super.initState();
    initializeData(); // Fetch data asynchronously
  }

  void initializeData() async {
    await fetchData();
  }

  // Handles book selection logic
  void handleBookSelection(int index) {
    setState(() {
      print(selectedBooks);
      if (selectedBooks[index]) {
        selectedBooks[index] = false;
        selectedCount--;
      } else {
        if (selectedCount >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("You must select exactly 6 books."),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          selectedBooks[index] = true;
          selectedCount++;
        }
      }
    });
  }

  // Search books based on query
  void searchBooks(String query) {
    setState(() {
      filteredBookList = bookList.where((book) {
        return book['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightMultiplier = MediaQuery.of(context).size.height/949.3333333333334;
    double widthMultiplier = MediaQuery.of(context).size.width/448;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      // Sets a light background color for the screen.
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            // Adds horizontal padding to the content.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Aligns children to the left.
              children: [
                SizedBox(
                  height: 10*heightMultiplier, // Adds vertical spacing.
                ),
                IconButton(
                  iconSize: 40, // Sets the size of the back button icon.
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors
                        .white), // Gives a white background to the button.
                  ),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20,
                      color: Colors.black), // Back arrow icon.
                  onPressed: () {}, // Defines behavior when the button is pressed.
                ),
                SizedBox(
                  height: 10*heightMultiplier, // Adds spacing below the back button.
                ),
                const Text(
                  "Let's build your Shelfie!", // Primary heading.
                  style: TextStyle(
                    fontFamily: "Canela", // Custom font for the title.
                    fontSize: 45,
                    fontWeight: FontWeight.bold, // Bold style for emphasis.
                  ),
                ),
                 SizedBox(height: 8*heightMultiplier),
                // Adds spacing below the heading.
                const Text(
                  "Pick exactly 6 books or TV shows that you love the most to create a Shelfie as unique as you are!",
                  // Subtitle providing instructions.
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54, // Lighter color for less emphasis.
                  ),
                ),
                SizedBox(height: 16*heightMultiplier),
                // Adds spacing before the search bar.
                TextField(
                  style: const TextStyle(fontSize: 16),
                  // Custom text style for the input.
                  controller: bookSearchController,
                  // Controller to manage the input text.
                  onChanged: (value) {
                    searchBooks(
                        value); // Calls a function to filter books based on the input value.
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    // Fills the search box with white.
                    filled: true,
                    hintText: "Search for books and TV shows",
                    // Placeholder text inside the search bar.
                    prefixIcon: const Icon(
                      Icons.search, // Search icon inside the bar.
                      size: 35,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      // Adds rounded corners when focused.
                      borderSide: const BorderSide(
                        color: Colors.black, // Black border for focus state.
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      // Adds rounded corners by default.
                      borderSide: const BorderSide(
                        color: Color(0xFFF5F0EB),
                        // Matches the background color.
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          40), // General rounded border.
                    ),
                  ),
                ),
              SizedBox(height: 16*heightMultiplier),
                // Adds spacing before the book grid.
               // Displays a loading spinner if data is loading.
                     Expanded(
                  child: filteredBookList.isNotEmpty
                      ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Displays 3 items per row.
                      crossAxisSpacing: 15, // Spacing between columns.
                      mainAxisSpacing: 1, // Spacing between rows.
                      childAspectRatio: 0.6, // Adjusts the size ratio of grid items.
                    ),
                    itemCount: filteredBookList.length,
                    // Number of items to display.
                    itemBuilder: (context, index) {
                      int bookIndex = bookList.indexOf(
                          filteredBookList[index]); // Finds the index of the book in the main list.
                      return BookTile(
                        imagePath: filteredBookList[index]['cover_url'],
                        // Passes the book cover URL.
                        title: filteredBookList[index]['title'],
                        // Passes the book title.
                        isSelected: selectedBooks[bookIndex],
                        // Checks if the book is selected.
                        onSelected: () =>
                            handleBookSelection(
                                bookIndex), // Handles selection toggle.
                      );
                    },
                  )
                      : const Center(
                    child: Text(
                        "No books found."), // Displays a message if no books match the search.
                  ),
                ),
                 SizedBox(height: 16*heightMultiplier),
                // Adds spacing before the submit button.
                SizedBox(
                  width: double.infinity,
                  // Makes the button stretch to full width.
                  child: FloatingActionButton(
                    onPressed: () async {
                      await getSelectedBooks(); // Fetches the selected books.
                      if (selectedCount != 6) {
                        // Validates if exactly 6 books are selected.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            // Red background for error message.
                            content: Text(
                                "You need to select exactly 6 books to proceed."),
                            // Error message text.
                            duration: Duration(
                                seconds: 2), // How long the message is shown.
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoadingScreen(
                                    selectedBooks: selectedBookTitles), // Navigates to the loading screen with selected books.
                          ),
                        );
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          40), // Adds rounded corners to the button.
                    ),
                    backgroundColor: const Color(0xFF281e28),
                    // Sets a dark purple color for the button.
                    child: const Text(
                      "Create my shelfie", // Button label.
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700, // Bold style for emphasis.
                        fontFamily: "Canela", // Custom font for the button text.
                        color: Colors.white, // White text for contrast.
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10*heightMultiplier),
                // Adds spacing below the button.
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class BookTile extends StatelessWidget {
  final String imagePath; // URL for the book or TV show's cover image.
  final String title; // Title of the book or TV show.
  final bool isSelected; // Indicates whether this tile is selected or not.
  final VoidCallback onSelected; // Callback function triggered when the tile is tapped.

  const BookTile({
    required this.imagePath,
    required this.title,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double heightMultiplier = MediaQuery.of(context).size.height/949.3333333333334;
    double widthMultiplier = MediaQuery.of(context).size.width/448;
    return Column(
      children: [
        GestureDetector(
          onTap: onSelected, // Allows tapping to select or deselect the tile.
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0), // Ensures rounded corners for the image.
            child: isSelected
                ? Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(5), // Adds padding inside the container.
                  height: 180.0*heightMultiplier,
                  width: 150.0*widthMultiplier,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0), // Matches the corner radius of the tile.
                    border: Border.all(
                      color: Colors.green.shade800, // Green border to indicate selection.
                      width: 4, // Thickness of the selection border.
                    ),
                  ),
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover, // Ensures the image covers the container without distortion.
                    height: 160.0*heightMultiplier,
                    width: 120.0*widthMultiplier,
                  ),
                ),
                Positioned(
                  top: 8, // Positions the checkmark icon near the top-right corner.
                  right: 8,
                  child: Icon(
                    Icons.check_circle, // Icon to show the selection state.
                    color: Colors.green.shade100, // Lighter green to contrast with the border.
                    size: 30, // Size of the checkmark icon.
                  ),
                ),
              ],
            )
                : Image.network(
              imagePath, // Displays the image when the tile is not selected.
              fit: BoxFit.cover, // Ensures proper scaling of the image.
              height: 180.0*heightMultiplier,
              width: 150.0*widthMultiplier,
            ),
          ),
        ),
       SizedBox(height: 8*heightMultiplier), // Adds spacing below the tile for better visual separation.
      ],
    );
  }
}
