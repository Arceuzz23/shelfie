import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shelfie/screens/shelfieScreen.dart';
import 'package:shelfie/widgets/share_actions.dart';
import 'package:shelfie/styles/app_styles.dart';

import '../widgets/shareScreen_header.dart';

class ShareScreen extends StatefulWidget {
  final String filePath; // Path of the captured screenshot
  final List<String> selectedBooks; // List of selected books

  const ShareScreen({
    super.key,
    required this.filePath,
    required this.selectedBooks
  });

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final heightMultiplier = screenSize.height / 949.3333333333334;
    final widthMultiplier = screenSize.width / 448;

    return Scaffold(
      backgroundColor: ShareScreenStyles.backgroundColor,
      body: Center(
        child: Padding(
          padding: ShareScreenStyles.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Header with back and close actions
              shareScreen_header(
                onBack: () => _navigateToShelfie(context),
                onClose: () => _navigateToShelfie(context),
              ),
              SizedBox(height: 50 * heightMultiplier),
              // Screenshot preview display
              _buildScreenshotPreview(heightMultiplier, widthMultiplier),
              SizedBox(height: 10 * heightMultiplier),
              // Text asking users to tag the app
              const Text(
                "Be sure to tag us!",
                style: ShareScreenStyles.taglineStyle,
              ),
              SizedBox(height: 30 * heightMultiplier),
              // Share actions for social media sharing
              ShareActions(
                heightMultiplier: heightMultiplier,
                widthMultiplier: widthMultiplier,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display the screenshot preview
  Widget _buildScreenshotPreview(double heightMultiplier, double widthMultiplier) {
    return SizedBox(
      height: 550 * heightMultiplier,
      width: 280 * widthMultiplier,
      child: widget.filePath.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          File(widget.filePath), // Display image from the file path
          fit: BoxFit.fill,
        ),
      )
          : const Text('No screenshot available'), // Fallback text if no screenshot
    );
  }

  // Navigate back to the ShelfieScreen with the selected books
  void _navigateToShelfie(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShelfieScreen(selectedBooks: widget.selectedBooks),
      ),
    );
  }
}
