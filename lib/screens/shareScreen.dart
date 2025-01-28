import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Used for managing storage permissions.
import 'package:share_plus/share_plus.dart'; // Used for sharing files and content.
import 'dart:io'; // Provides file operations.
import 'package:shared_preferences/shared_preferences.dart'; // For storing and retrieving persistent data.
import 'package:shelfie/screens/shelfieScreen.dart'; // Importing the ShelfieScreen class.

class Sharescreen extends StatefulWidget {
  final String filePath; // Path to the screenshot file to be shared.
  final List<String> selectedBooks; // List of books selected for the shelfie.

  const Sharescreen({super.key, required this.filePath, required this.selectedBooks});

  @override
  State<Sharescreen> createState() => _SharescreenState();
}

class _SharescreenState extends State<Sharescreen> {

  /// Retrieves the saved screenshot path from shared preferences.
  /// Returns the saved path as a string, or `null` if no path is found.
  Future<String?> getSavedScreenshotPath() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance(); // Access shared preferences.
      String? path = prefs.getString('screenshot_path'); // Retrieve the stored screenshot path.

      if (path != null) {
        print('Retrieved Screenshot Path: $path'); // Logs the retrieved path.
      } else {
        print('No Screenshot Path Found!'); // Logs if no path is found.
      }

      return path; // Return the path if it exists, or null otherwise.
    } catch (e) {
      print('Error Retrieving Path: $e'); // Logs any errors encountered during retrieval.
      return null;
    }
  }

  /// Saves the image from the provided file path to the gallery.
  /// Checks storage permissions and creates the target directory if necessary.
  Future<void> downloadImageFromFilePath(String filePath) async {
    final file = File(filePath); // Creates a File object for the provided path.

    if (!file.existsSync()) {
      print("File does not exist."); // Logs if the file does not exist.
      return;
    }

    // Requests storage permissions and proceeds only if granted.
    if (await Permission.storage.request().isGranted) {
      final galleryPath = '/storage/emulated/0/Pictures'; // Target directory for saving the image.
      final directory = Directory(galleryPath);

      if (!directory.existsSync()) {
        await directory.create(recursive: true); // Creates the directory if it doesn't exist.
      }

      final newFilePath = "$galleryPath/${file.uri.pathSegments.last}"; // Generates the new file path.
      await file.copy(newFilePath); // Copies the file to the new location.

      print("Image saved successfully to gallery: $newFilePath"); // Logs success message.
    } else {
      print("Storage permission denied."); // Logs if storage permissions are not granted.
    }
  }

  @override
  void initState() {
    // Logs the file path if it is not empty; otherwise, logs that it is empty.
    if (widget.filePath != "") {
      print(widget.filePath); // Logs the provided file path.
    } else {
      print("filePath empty"); // Logs if no file path is provided.
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightMultiplier = MediaQuery.of(context).size.height/949.3333333333334;
    double widthMultiplier = MediaQuery.of(context).size.width/448;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB), // Sets the background color of the screen.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 8), // Adds padding around the content.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Aligns the column's children to the top.
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spreads the buttons evenly across the row.
                children: [
                  // Back button to navigate back to the Shelfie screen.
                  IconButton(
                    iconSize: 70, // Increases the clickable area size.
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white), // Sets button background color.
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 30, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShelfieScreen(selectedBooks: widget.selectedBooks)),
                      ); // Navigates to the Shelfie screen.
                    },
                  ),
                  // Close button to navigate back to the Shelfie screen.
                  IconButton(
                    iconSize: 40,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    icon: const Icon(Icons.close, size: 30, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShelfieScreen(selectedBooks: widget.selectedBooks)),
                      ); // Navigates to the Shelfie screen.
                    },
                  ),
                ],
              ),
               SizedBox(height: 50*heightMultiplier), // Adds spacing between the row and the image.
              SizedBox(
                height: 550*heightMultiplier, // Sets the height of the container for the screenshot.
                width: 280*widthMultiplier, // Sets the width of the container for the screenshot.
                child: widget.filePath.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Adds rounded corners to the screenshot.
                  child: Image.file(
                    File(widget.filePath), // Displays the screenshot from the file path.
                    fit: BoxFit.fill, // Ensures the image fills the container without distortion.
                  ),
                )
                    : const Text('No screenshot available'), // Placeholder text if no screenshot exists.
              ),
              SizedBox(height: 10*heightMultiplier), // Adds spacing between the image and the text.
              const Text(
                "Be sure to tag us!", // Encourages users to tag in their posts.
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: "Canela",
                  fontSize: 18,
                ),
              ),
               SizedBox(height: 30*heightMultiplier), // Adds spacing before the row of action buttons.
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centers the action buttons horizontally.
                children: [
                  Column(
                    children: [
                      // Share button to share the screenshot to Instagram Story.
                      IconButton(
                        iconSize: 90,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.white),
                        ),
                        icon: Image.asset(
                          "assets/icons/share.png", // Uses a custom share icon image.
                          height: 60*heightMultiplier,
                          width: 60*widthMultiplier,
                        ),
                        onPressed: () async {
                          final imagePath = await getSavedScreenshotPath(); // Retrieves the saved screenshot path.
                          await InstagramStoryShare.shareToInstagramStory(context, imagePath!); // Shares the screenshot.
                        },
                      ),
                      const Text(
                        "Share", // Label for the share button.
                        style: TextStyle(
                          fontFamily: "Canela",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 15*widthMultiplier), // Adds spacing between the Share and Download buttons.
                  Column(
                    children: [
                      // Download button to save the screenshot to the gallery.
                      IconButton(
                        iconSize: 90,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.white),
                        ),
                        icon: Image.asset(
                          "assets/icons/download.png", // Uses a custom download icon image.
                          height: 60*heightMultiplier,
                          width: 60*widthMultiplier,
                        ),
                        onPressed: () async {
                          final filePath = await getSavedScreenshotPath(); // Retrieves the saved screenshot path.
                          await downloadImageFromFilePath(filePath!); // Saves the screenshot to the gallery.
                        },
                      ),
                      const Text(
                        "Download", // Label for the download button.
                        style: TextStyle(
                          fontFamily: "Canela",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class InstagramStoryShare {
  // Static method to share an image to Instagram Story or other apps using the share_plus package.
  static Future<void> shareToInstagramStory(BuildContext context, String imagePath) async {
    try {
      // Create a File object from the provided image path.
      final file = File(imagePath);

      // Check if the file exists at the specified path.
      if (!await file.exists()) {
        throw Exception('Image file not found'); // Throw an exception if the file doesn't exist.
      }

      // Retrieve the RenderBox to determine the position and size of the widget.
      // This is used to display the share sheet at the correct position.
      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin = box != null
          ? box.localToGlobal(Offset.zero) & box.size // Get the position and size of the widget.
          : null;

      // Use the Share.shareXFiles method from the share_plus package to share the image.
      await Share.shareXFiles(
          [XFile(imagePath)], // Share the image as an XFile object.
          sharePositionOrigin: sharePositionOrigin, // Provide the position for the share sheet.
          subject: '', // Optional: Add a subject to the shared content (empty here).
          text: '' // Optional: Add accompanying text to the shared content (empty here).
      );
    } catch (e) {
      // If an error occurs, display an AlertDialog to inform the user of the issue.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'), // Title of the error dialog.
          content: Text(e.toString()), // Display the error message.
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog when "OK" is pressed.
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
