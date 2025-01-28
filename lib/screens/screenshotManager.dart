import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelfie/screens/bookSelectScreen.dart';
import 'package:screenshot/screenshot.dart';

class ScreenshotManager extends StatefulWidget {
  const ScreenshotManager({super.key});

  @override
  State<ScreenshotManager> createState() => _ScreenshotManagerState();
}

class _ScreenshotManagerState extends State<ScreenshotManager> {

  final ScreenshotController screenshotController = ScreenshotController();
  final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');

  Future<void> saveImage(Uint8List bytes) async {
    final name = 'screenschot_$time';
    await Permission.storage.request();
    final Uint8List? image = (await screenshotController.capture()) as Uint8List?;
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'shelfie_${DateTime
          .now()
          .millisecondsSinceEpoch}.png';
      final String filePath = join(directory.path, fileName);
      final File file = File(filePath);
      await file.writeAsBytes(image as List<int>);
      print('Screenshot saved at: $filePath');
    }
  }
  Future<void> saveScreenshotPath(String filePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('screenshot_path', filePath);
  }
  Future<String?> getSavedScreenshotPath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('screenshot_path');
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
