import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shelfie/screens/shareScreen.dart';
import 'package:shelfie/widgets/shelfieScreen_header.dart';
import '../constants/app_constants.dart';
import '../utils/screenshot_manager.dart';
import '../widgets/rack.dart';
import '../widgets/editable_text.dart';
import '../widgets/loading_overlay.dart';
import 'bookSelectScreen.dart';


class ShelfieScreen extends StatefulWidget {
  final List<String> selectedBooks;

  const ShelfieScreen({super.key, required this.selectedBooks});

  @override
  State<ShelfieScreen> createState() => _ShelfieScreenState();
}

class _ShelfieScreenState extends State<ShelfieScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController textController = TextEditingController();

  late List<String> _topRowBooks;
  late List<String> _bottomRowBooks;

  bool isCapturing = false;
  bool isEditing = false;
  bool isEditingTag = false;
  String tag = ShelfieScreenConstants.defaultTag;
  String text = ShelfieScreenConstants.defaultTitle;

  @override
  void initState() {
    super.initState();
    _initializeBooks();
  }

  void _initializeBooks() {
    _topRowBooks = widget.selectedBooks.sublist(0, 3);
    _bottomRowBooks = widget.selectedBooks.sublist(3, 6);
  }

  void _updateTopRow(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex -= 1;
      final item = _topRowBooks.removeAt(oldIndex);
      _topRowBooks.insert(newIndex, item);
    });
  }

  void _updateBottomRow(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex -= 1;
      final item = _bottomRowBooks.removeAt(oldIndex);
      _bottomRowBooks.insert(newIndex, item);
    });
  }



  Future<void> _captureAndSaveScreenshot() async {
    setState(() => isCapturing = true);
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final Uint8List? bytes = await screenshotController.capture();

      if (bytes == null) {
        _showErrorSnackBar("Screenshot was not captured!");
        return;
      }

      // Explicitly create a new Uint8List from bytes
      final Uint8List convertedBytes = Uint8List.fromList(bytes);

      final filePath = await ScreenshotHelper.saveImage(convertedBytes, screenshotController);
      if (filePath != null) {
        await ScreenshotHelper.saveScreenshotPath(filePath);
        _navigateToShareScreen(filePath);
      }
    } catch (error) {
      _showErrorSnackBar("Error capturing screenshot");
      debugPrint(error.toString());
    } finally {
      setState(() => isCapturing = false);
    }
  }


  void _navigateToShareScreen(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShareScreen(
          filePath: filePath,
          selectedBooks: widget.selectedBooks,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(ShelfieScreenConstants.backgroundImage, fit: BoxFit.fill),
    );
  }

  Widget _buildTitle(double heightMultiplier, double widthMultiplier) {
    return CustomEditableText(
      text: text,
      style: ShelfieScreenConstants.styles.titleStyle,
      isEditing: isEditing,
      width: 350 * widthMultiplier,
      height: 90 * heightMultiplier,
      onTap: () => setState(() => isEditing = true),
      onSubmitted: (newText) => setState(() {
        text = newText;
        isEditing = false;
      }),
    );
  }
  Widget _buildTagRow(double heightMultiplier, double widthMultiplier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Follow me on Fable ",
          style: ShelfieScreenConstants.styles.tagStyle.copyWith(fontWeight: FontWeight.normal),
        ),
        CustomEditableText(
          text: tag,
          style: ShelfieScreenConstants.styles.tagStyle,
          isEditing: isEditingTag,
          width: 150 * widthMultiplier,
          height: 57 * heightMultiplier,
          onTap: () => setState(() => isEditingTag = true),
          onSubmitted: (newText) => setState(() {
            tag = newText;
            isEditingTag = false;
          }),
        ),
      ],
    );
  }

  Widget _buildDownloadButton(double heightMultiplier, double widthMultiplier) {
    return Visibility(
      visible: !isCapturing,
      maintainSize: false,
      child: SizedBox(
        width: 250 * widthMultiplier,
        child: FloatingActionButton(
          onPressed: _captureAndSaveScreenshot,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          backgroundColor: const Color(0xFF281e28),
          child: Text(
            "Download",
            style: ShelfieScreenConstants.styles.buttonTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(double heightMultiplier, double widthMultiplier) {
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            _buildBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30 * heightMultiplier),
                Visibility(
                  visible: !isCapturing,
                  maintainSize: false,
                  child: shelfieScreen_header(
                    onBack: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookSelectScreen()),
                    ),
                    onCustomize: () {
                      // Add customization logic
                    },
                    onClose: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookSelectScreen()),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTitle(heightMultiplier, widthMultiplier),
                _buildTagRow(heightMultiplier, widthMultiplier),
                SizedBox(height: isCapturing ? 30 * heightMultiplier : 0),
                SizedBox(height: 30 * heightMultiplier),
                BookRack(
                  books: _topRowBooks,
                  onReorder: _updateTopRow,
                  heightMultiplier: heightMultiplier,
                  widthMultiplier: widthMultiplier,
                ),
                SizedBox(height: 10 * heightMultiplier),
                BookRack(
                  books: _bottomRowBooks,
                  onReorder: _updateBottomRow,
                  heightMultiplier: heightMultiplier,
                  widthMultiplier: widthMultiplier,
                ),
                SizedBox(height: 100 * heightMultiplier),
                _buildDownloadButton(heightMultiplier, widthMultiplier),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightMultiplier = size.height / 949.3333333333334;
    final widthMultiplier = size.width / 448;

    return Stack(
      children: [
        _buildMainContent(heightMultiplier, widthMultiplier),
        if (isCapturing) LoadingOverlay(heightMultiplier: heightMultiplier),
      ],
    );
  }
}

