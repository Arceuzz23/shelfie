import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../constants/app_constants.dart';

class StorageManager {
  static Future<String?> getSavedScreenshotPath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(ShareScreenConstants.screenshotPathKey);
    } catch (e) {
      return null;
    }
  }

  static Future<void> downloadImageToGallery(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return;

    if (await Permission.storage.request().isGranted) {
      final directory = Directory(ShareScreenConstants.galleryPath);
      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }

      final newFilePath = "${ShareScreenConstants.galleryPath}/${file.uri.pathSegments.last}";
      await file.copy(newFilePath);
    }
  }
}