import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelfie/screens/bookSelectScreen.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shelfie/screens/shareScreen.dart';

// Main class for the ShelfieScreen widget
class ShelfieScreen extends StatefulWidget {
  final List<String> selectedBooks; // List of books selected by the user

  const ShelfieScreen({super.key, required this.selectedBooks});

  @override
  State<ShelfieScreen> createState() => _ShelfieScreenState();
}

class _ShelfieScreenState extends State<ShelfieScreen> {
  // Controller to capture the screenshot
  final ScreenshotController screenshotController = ScreenshotController();

  // Variables to hold books for the top and bottom rows of the shelf
  late List<String> _topRowBooks = [];
  late List<String> _bottomRowBooks = [];

  @override
  void initState() {
    super.initState();
    // Split the selected books into top and bottom rows
    _topRowBooks = widget.selectedBooks.sublist(0, 3);
    _bottomRowBooks = widget.selectedBooks.sublist(3, 6);
    print('Selected Books: ${widget.selectedBooks}');
  }

  // Variables for managing state and UI elements
  String filePath = "";
  bool isCapturing = false; // Indicates if a screenshot is being captured
  bool isEditing = false; // Indicates if the title text is being edited
  bool isEditingTag = false; // Indicates if the tag is being edited
  String tag = "@arceuzz23"; // Default tag text
  TextEditingController controller = TextEditingController();
  String text = "MY SHELFIE"; // Default title text

  // Generate a timestamp for unique file names
  final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');

  // Save the screenshot image to the local storage
  Future<String?> saveImage(Uint8List bytes) async {
    final name = 'screenshot_$time';

    // Request storage permission
    await Permission.storage.request();

    // Capture the screenshot
    final Uint8List? image = (await screenshotController.capture());

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'shelfie_${DateTime.now().millisecondsSinceEpoch}.png';
      final String filePath = join(directory.path, fileName);
      final File file = File(filePath);

      // Save the image to the file
      await file.writeAsBytes(image);
      print('Screenshot saved at: $filePath');
      return filePath;
    }
    return null;
  }

  // Save the screenshot file path to SharedPreferences
  Future<void> saveScreenshotPath(String filePath) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool success = await prefs.setString('screenshot_path', filePath);

      if (success) {
        print('Screenshot Path Saved: $filePath');
      } else {
        print('Failed to save screenshot path!');
      }
    } catch (e) {
      print('Error Saving Path: $e');
    }
  }

  // Retrieve the saved screenshot file path from SharedPreferences
  Future<String?> getSavedScreenshotPath() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? path = prefs.getString('screenshot_path');

      if (path != null) {
        print('Retrieved Screenshot Path: $path');
      } else {
        print('No Screenshot Path Found!');
      }

      return path;
    } catch (e) {
      print('Error Retrieving Path: $e');
      return null;
    }
  }

  // Update the position of books in the top row
  void _updateTopRow(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final String item = _topRowBooks.removeAt(oldIndex);
      _topRowBooks.insert(newIndex, item);
    });
  }

  // Update the position of books in the bottom row
  void _updateBottomRow(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final String item = _bottomRowBooks.removeAt(oldIndex);
      _bottomRowBooks.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightMultiplier = MediaQuery.of(context).size.height/949.3333333333334;
    double widthMultiplier = MediaQuery.of(context).size.width/448;
    return Stack(
      children: [
        Scaffold(
          body: Screenshot(
            controller: screenshotController,
            child: Stack(
              children: [

                // Background image of the screen
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset("assets/images/bkg1.jpg", fit: BoxFit.fill),
                ),

                // Main content of the screen
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30*heightMultiplier,
                    ),
                    // Header with navigation buttons
                    Visibility(
                      visible: !isCapturing,
                      maintainSize: false,
                      child: buildHeader(context),
                    ),
                    const SizedBox(height: 30),

                    // Title editing feature
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      child: isEditing
                          ? SizedBox(
                        height: 90*heightMultiplier,
                        width: 350*widthMultiplier,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Colors.white,
                          autocorrect: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Faster One",
                            color: Colors.white,
                            fontSize: 40,
                          ),
                          controller: controller,
                          autofocus: true,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white38,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white38,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (newText) {
                            setState(() {
                              text = newText;
                              isEditing = false;
                            });
                          },
                          onTapOutside: (newText){
                            setState(() {
                              isEditing = false;
                            });
                          },
                        ),
                      )
                          : Text(
                        text,
                        style: TextStyle(
                          fontFamily: "Faster One",
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    // Row to display the text and an editable tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Static text prompting users to follow
                        const Text(
                          "Follow me on Fable ",
                          style: TextStyle(
                            fontFamily: "Canela",
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        // Editable tag logic with GestureDetector to toggle editing state
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditingTag = true; // Enables tag editing
                            });
                          },
                          child: isEditingTag
                              ? SizedBox(
                            height: 57*heightMultiplier,
                            width: 150*widthMultiplier,
                            child: TextFormField(
                              // TextFormField for editing the tag
                              textAlignVertical: TextAlignVertical.center,
                              cursorColor: Colors.white,
                              autocorrect: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Canela",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              controller: controller, // Controller for input text
                              autofocus: true,
                              decoration: InputDecoration(
                                // Styling for the TextFormField borders
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white38,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white38,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              onFieldSubmitted: (newText) {
                                // Save the new tag text and exit editing mode
                                setState(() {
                                  tag = newText;
                                  isEditingTag = false;
                                });
                              },
                              onTapOutside: (newtext) {
                                // Exit editing mode when tapping outside
                                setState(() {
                                  isEditingTag = false;
                                });
                              },
                            ),
                          )
                              : Text(
                            // Display the current tag when not editing
                            tag,
                            style: TextStyle(
                              fontFamily: "Canela",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Add spacing when capturing is in progress
                    Visibility(
                      visible: isCapturing, // Visibility depends on capturing state
                      maintainSize: false,
                      child: SizedBox(height: 30*heightMultiplier),
                    ),
                   SizedBox(height: 30*heightMultiplier), // Additional spacing

                    // Build the top row of the rack with books
                    buildRack(_topRowBooks, _updateTopRow,heightMultiplier,widthMultiplier),
                    SizedBox(height: 10*heightMultiplier,), // Spacing between top and bottom racks

                    // Build the bottom row of the rack with books
                    buildRack(_bottomRowBooks, _updateBottomRow,heightMultiplier,widthMultiplier),

                     SizedBox(height: 100*heightMultiplier), // Spacing before the button

                    // Floating Action Button to capture screenshot
                    Visibility(
                      visible: !isCapturing, // Only visible when not capturing
                      maintainSize: false,
                      child: SizedBox(
                        width: 250*widthMultiplier,
                        child: FloatingActionButton(
                          onPressed: () async {
                            setState(() {
                              isCapturing = true; // Set capturing state to true
                            });

                            await Future.delayed(Duration(milliseconds: 100));

          // Delays the execution for 100 milliseconds to ensure all animations or UI updates are completed before capturing the screenshot.

                            try {
                              // Attempt to capture a screenshot using the screenshotController.
                              final bytes = await screenshotController.capture();

                              if (bytes != null) {
                                // If the screenshot was successfully captured, save it to a file.
                                final filePath1 = await saveImage(bytes);

                                if (filePath1 != null) {
                                  // If the file path is valid, save it for future reference.
                                  await saveScreenshotPath(filePath1);

                                  setState(() {
                                    // Set the capturing state to false to indicate the process is complete.
                                    isCapturing = false;
                                  });

                                  // Navigate to the Sharescreen widget, passing the file path and selected books as arguments.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Sharescreen(
                                        filePath: filePath1,
                                        selectedBooks: widget.selectedBooks,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                // If no bytes were captured, show an error message and reset the capturing state.
                                setState(() {
                                  isCapturing = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Screenshot was not Captured!")),
                                );
                              }
                            } catch (error) {
                              // Catch and handle any errors that occur during the screenshot process.
                              setState(() {
                                isCapturing = false;
                              });
                              debugPrint(error.toString()); // Log the error to the console.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error capturing screenshot")),
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                            // Define a rounded rectangular shape for the button with a corner radius of 40.
                            borderRadius: BorderRadius.circular(40),
                          ),
                          backgroundColor: const Color(0xFF281e28),
          // Set the button's background color to a dark shade.

                          child: const Text(
                            "Download",
                            // Button label text styled with custom font, color, and weight.
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Canela",
                            ),
                          ),
                        ),
                      ),
                    )
                  ]
                )],
                ),
            ),
          ),
        if (isCapturing)
        // Display a loading overlay when the capturing state is true.
          Positioned.fill(
            child: Material(
              child: Container(
                color: Color(0xff332732),
                // Background color for the loading overlay.
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                        // Display a loading animation while the screenshot is being processed.
                        color: Colors.white,
                        size: 50,
                      ),
                       SizedBox(height: 15*heightMultiplier),
                      // Add spacing below the animation.
                      const Text(
                        'Creating Image',
                        // Display a message to indicate the process of creating an image.
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'Canela',
                        ),
                        semanticsLabel: 'Creating Image',
                        // Accessibility label for the text.
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
/// Builds the header widget containing navigation buttons and customization options.
Widget buildHeader(BuildContext context) {
  return Row(
    children: [
      // Icon button to navigate back to the previous screen.
      IconButton(
        // Sets the border style for the button.
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(color: Colors.white)),
        ),
        // Sets the size of the button icon.
        iconSize: 40,
        // Defines the icon (left arrow) with its size and color.
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
        // Callback function triggered when the button is pressed.
        onPressed: () {
          // Navigates to the BookSelectScreen.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookSelectScreen()),
          );
        },
      ),

      // Spacer widget to create flexible space between child widgets.
      const Spacer(),

      // Text button for customization options.
      TextButton(
        // Sets the border style for the button.
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(color: Colors.white)),
        ),
        // Callback function triggered when the button is pressed.
        onPressed: () {
          // Functionality for customization can be added here.
        },
        // Text displayed on the button with style settings.
        child: const Text(
          'Customize',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),

      // Icon button to close the screen or navigate back.
      IconButton(
        // Sets the border style for the button.
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(color: Colors.white)),
        ),
        // Sets the size of the button icon.
        iconSize: 40,
        // Defines the icon (close icon) with its size and color.
        icon: const Icon(Icons.close, size: 20, color: Colors.white),
        // Callback function triggered when the button is pressed.
        onPressed: () {
          // Navigates to the BookSelectScreen.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookSelectScreen()),
          );
        },
      ),
    ],
  );
}


/// Builds a rack UI component that displays a list of tiles as a reorderable horizontal list.
Widget buildRack(List<String> tiles, Function(int, int) onReorder,double heightMultiplier, double widthMultiplier) {
  return Stack(
    children: [
      // Aligns the rack background image to the center.
      Align(
        alignment: Alignment.center,
        child: Container(
          // Aligns the image at the bottom of the container.
          alignment: Alignment.bottomCenter,
          height: 170*heightMultiplier, // Height of the rack background.
          width: 420*widthMultiplier,  // Width of the rack background.
          // Displays the rack image asset.
          child: Image.asset("assets/images/shelf.png", fit: BoxFit.fitWidth),
        ),
      ),
      // Row widget to display the tiles over the rack image.
      Row(
        children: [
          // Adds spacing to the left side of the tiles.
          SizedBox(width: 70*widthMultiplier),
          // Container for the reorderable list of tiles.
          SizedBox(
            height: 160*heightMultiplier, // Height of the list view matching the rack's design.
            width: 330*widthMultiplier,  // Width of the list view area.
            child: ReorderableListView(
              scrollDirection: Axis.horizontal, // Makes the list scroll horizontally.
              onReorder: onReorder, // Callback triggered when the items are reordered.
              children: [
                // Loops through the `tiles` list to create individual tiles.
                for (int i = 0; i < tiles.length; i++)
                  Padding(
                    // Key is required for ReorderableListView to track the tiles' state.
                    key: ValueKey(tiles[i] + i.toString()),
                    padding: const EdgeInsets.all(5.0), // Spacing around each tile.
                    child: SizedBox(
                      width: 95*widthMultiplier, // Fixed width for each tile.
                      child: ClipRRect(
                        // Rounds the corners of the tile for a clean design.
                        borderRadius: BorderRadius.circular(15),
                        // Displays the tile image from a network URL.
                        child: Image.network(
                          tiles[i],
                          fit: BoxFit.cover, // Ensures the image covers the entire tile area.
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

class LoadingScreen extends StatefulWidget {
  // List of books selected by the user
  final List<String> selectedBooks;
  const LoadingScreen({super.key, required this.selectedBooks});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // Path to the background image that needs to be preloaded
  final String _backgroundImagePath = 'assets/images/bkg1.jpg';

  /// Preloads the specified background image into memory to ensure smooth transitions.
  Future<void> preloadImage(BuildContext context) async {
    final image = AssetImage(_backgroundImagePath);
    await precacheImage(image, context); // Caches the image to avoid flickering during rendering.
  }

  @override
  void initState() {
    super.initState();
    preloadImage(this.context); // Start preloading the image as soon as the widget initializes.
  }

  @override
  Widget build(BuildContext context) {
    double heightMultiplier = MediaQuery.of(context).size.height/949.3333333333334;
    double widthMultiplier = MediaQuery.of(context).size.width/448;
    return Scaffold(
      body: FutureBuilder(
        // Simulate a delay (or replace with actual data fetching if required).
        future: Future.delayed(Duration(seconds: 5)),
        builder: (context, snapshot) {
          // While the future is still pending, show the loading animation.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Positioned.fill(
              child: Material(
                child: Container(
                  color: Color(0xff332732), // Background color for the loading screen.
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display a loading animation with a specified style.
                        LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.white,
                          size: 50, // Size of the loading animation.
                        ),
                         SizedBox(height: 15*heightMultiplier),
                        // Descriptive text to inform the user about the process.
                        const Text(
                          'Creating your Shelfie',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Canela',
                          ),
                          semanticsLabel: 'Creating Image', // For accessibility support.
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          // Once the future completes, navigate to the next screen.
          else if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ShelfieScreen(selectedBooks: widget.selectedBooks),
                ),
              );
            });
            return Container(); // Empty container while transitioning to the next screen.
          } else {
            // Fallback for any unexpected connection state.
            return Container();
          }
        },
      ),
    );
  }
}
