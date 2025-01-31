import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenshotHelper {
  static Future<String?> saveImage(Uint8List bytes, ScreenshotController controller) async {
    final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
    final name = 'screenshot_$time';

    await Permission.storage.request();
    final image = await controller.capture();

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'shelfie_${DateTime.now().millisecondsSinceEpoch}.png';
      final String filePath = join(directory.path, fileName);
      final File file = File(filePath);

      await file.writeAsBytes(image);
      return filePath;
    }
    return null;
  }

  static Future<void> saveScreenshotPath(String filePath) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('screenshot_path', filePath);
    } catch (e) {
      print('Error Saving Path: $e');
    }
  }

  static Future<String?> getSavedScreenshotPath() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('screenshot_path');
    } catch (e) {
      print('Error Retrieving Path: $e');
      return null;
    }
  }
}