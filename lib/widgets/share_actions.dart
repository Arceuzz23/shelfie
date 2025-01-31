import 'package:flutter/material.dart';
import 'package:shelfie/styles/app_styles.dart';
import 'package:shelfie/utils/storage_manager.dart';
import 'package:shelfie/utils/sharing_manager.dart';

class ShareActions extends StatelessWidget {
  final double heightMultiplier;
  final double widthMultiplier;

  const ShareActions({
    super.key,
    required this.heightMultiplier,
    required this.widthMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionColumn(
          'Share',
          'assets/icons/share.png',
              () async {
            final path = await StorageManager.getSavedScreenshotPath();
            await SharingManager.shareToInstagramStory(context, path!);
          },
        ),
        SizedBox(width: 15 * widthMultiplier),
        _buildActionColumn(
          'Download',
          'assets/icons/download.png',
              () async {
            final path = await StorageManager.getSavedScreenshotPath();
            await StorageManager.downloadImageToGallery(path!);
          },
        ),
      ],
    );
  }

  Widget _buildActionColumn(String label, String iconPath, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          iconSize: 90,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          icon: Image.asset(
            iconPath,
            height: 60 * heightMultiplier,
            width: 60 * widthMultiplier,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: ShareScreenStyles.actionLabelStyle,
        ),
      ],
    );
  }
}