import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Sharescreen extends StatefulWidget {
  final String filePath;
  const Sharescreen({super.key, required this.filePath});

  @override
  State<Sharescreen> createState() => _SharescreenState();
}

class _SharescreenState extends State<Sharescreen> {

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




  Future<void>downloadImageFromFilePath(String filePath) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      print("File does not exist.");
      return;
    }

    if (await Permission.storage.request().isGranted) {
      final galleryPath = '/storage/emulated/0/Pictures';
      final directory = Directory(galleryPath);

      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }

      final newFilePath = "$galleryPath/${file.uri.pathSegments.last}";
      await file.copy(newFilePath);

      print("Image saved successfully to gallery: $newFilePath");
    } else {
      print("Storage permission denied.");
    }
  }




  @override
  void initState() {
    if(widget.filePath!="")
    print(widget.filePath);
    else
      print("filePath empty");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30,15,8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 70,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 30, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 40,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    icon: const Icon(Icons.close, size: 30, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 50,),
              Container(
                height: 550,
                width: 280,
                child: widget.filePath.isNotEmpty
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(File(widget.filePath), fit: BoxFit.fill,))  // Display the screenshot
                    : const Text('No screenshot available'),
              ),
              SizedBox(height: 10,),
              Text("Be sure to tag us!",
              style: TextStyle(
                fontFamily: "Canela",
                fontSize: 15,
              ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                        iconSize: 90,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        icon: Image.asset("assets/icons/instagram.png",height: 60,width: 60,),
                        onPressed: () {},
                      ),
                      Text("Stories",
                        style: TextStyle(
                          fontFamily: "Canela",
                          fontSize: 15,
                        ),),
                    ],
                  ),
                  SizedBox(width: 15,),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 90,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        icon: Image.asset("assets/icons/tiktok.png",height: 60,width: 60,),
                        onPressed: () {},
                      ),
                      Text("TikTok",
                        style: TextStyle(
                          fontFamily: "Canela",
                          fontSize: 15,
                        ),),
                    ],
                  ),SizedBox(width: 15,),
                  Column(
                    children: [
                      IconButton(
                        iconSize: 90,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                        icon: Image.asset("assets/icons/download.png",height: 60,width: 60,),
                        onPressed: () async {
                          final filePath = await getSavedScreenshotPath();
                          await downloadImageFromFilePath(filePath!);
                        },
                      ),
                      Text("Download",
                        style: TextStyle(
                          fontFamily: "Canela",
                          fontSize: 15,
                        ),),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),  // Handle case if no screenshot exists
      ),
    );
  }
}

