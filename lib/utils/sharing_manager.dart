import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class SharingManager {
  static Future<void> shareToInstagramStory(BuildContext context, String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file not found');
      }

      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin = box!.localToGlobal(Offset.zero) & box.size;

      await Share.shareXFiles(
        [XFile(imagePath)],
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}