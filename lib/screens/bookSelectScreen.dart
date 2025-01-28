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
        selectedBooks = List.generate(books.length, (index) => false); // Initialize selection state for each book
        isLoading = false;
      });
      return books;
    }
    setState(() {
      isLoading = false;
    });
    return null;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                IconButton(
                  iconSize: 40,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black),
                  onPressed: () {},
                ),
                SizedBox(
                  height: 10,
                ),
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
                TextField(
                  style: const TextStyle(fontSize: 16),
                  controller: bookSearchController,
                  onChanged: (value) {
                    searchBooks(value); // Call search function
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Search for books and TV shows",
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 35,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Color(0xFFF5F0EB),
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                  child: filteredBookList.isNotEmpty
                      ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 1,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: filteredBookList.length,
                    itemBuilder: (context, index) {
                      int bookIndex = bookList.indexOf(filteredBookList[index]);
                      return BookTile(
                        imagePath: filteredBookList[index]['cover_url'],
                        title: filteredBookList[index]['title'],
                        isSelected: selectedBooks[bookIndex],
                        onSelected: () => handleBookSelection(bookIndex),
                      );
                    },
                  )
                      : const Center(
                    child: Text("No books found."),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (selectedCount != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("You need to select exactly 6 books to proceed."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ShelfieScreen()));
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    backgroundColor: const Color(0xFF281e28),
                    child: const Text(
                      "Create my shelfie",
                      style: TextStyle(
                        fontSize: 16,
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
    return Column(
      children: [
        GestureDetector(
          onTap: onSelected,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: isSelected
                ? Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 180.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.green.shade800,
                      width: 4,
                    ),
                  ),
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    height: 160.0,
                    width: 120.0,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade100,
                    size: 30,
                  ),
                ),
              ],
            )
                : Image.network(
              imagePath,
              fit: BoxFit.cover,
              height: 180.0,
              width: 150.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
