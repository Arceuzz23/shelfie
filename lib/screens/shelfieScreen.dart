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

class ShelfieScreen extends StatefulWidget {
  const ShelfieScreen({Key? key}) : super(key: key);

  @override
  State<ShelfieScreen> createState() => _ShelfieScreenState();
}

class _ShelfieScreenState extends State<ShelfieScreen> {
  final ScreenshotController screenshotController = ScreenshotController();
  final List<String> myTiles = [
    'assets/images/lamp.png',
    'assets/images/pot.png'
  ];
  final List<String> myTiles1 = [
    'assets/images/clock.png',
    'assets/images/stick_figure.png'
  ];
  String filePath = "";
  bool isCapturing = false;

  @override
  void initState() {
    super.initState();
  }

  final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');

  Future<String?> saveImage(Uint8List bytes) async {
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
      return filePath;
    }
    return null;
  }

  void testSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save a test value
    await prefs.setString('test_key', 'Hello, SharedPreferences!');

    // Retrieve the test value
    String? testValue = prefs.getString('test_key');

    print('Test Value: $testValue'); // Should print "Hello, SharedPreferences!"
  }

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


  @override
  Widget build(BuildContext context) {
    return isCapturing
        ? LoadingScreen()
        : Scaffold(
      body: SafeArea(
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Image.asset("assets/images/bkg1.jpg",
                    fit: BoxFit.fill),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Buttons are displayed only when not capturing
                  if (!isCapturing) buildHeader(context),
                  const SizedBox(height: 50),
                  const Text(
                    "MY SHELFIE",
                    style: TextStyle(
                      fontFamily: "Faster One",
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  const Text(
                    "Follow me on Fable @arceuzz23",
                    style: TextStyle(
                      fontFamily: "Canela",
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildRack(myTiles),
                  buildRack(myTiles1),
                  const SizedBox(height: 100),
                  SizedBox(
                    width: 250,
                    child: FloatingActionButton(
                      onPressed: () async {
                        await screenshotController.capture().then((bytes) async {
                          if(bytes!=null){
                            final filePath1 = await saveImage(bytes as Uint8List);
                            await saveScreenshotPath(filePath1!);
                          }
                        },
                        ).catchError((onError){
                          debugPrint(onError);
                        });

                        final filePath1 = await getSavedScreenshotPath();

                        print(filePath1);
                        if(filePath1 != null)
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Sharescreen(filePath: filePath1)));
                        else{
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(content: Text("Screenshot was not Captured!")),
                          );
                        }
                      },

        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      backgroundColor: const Color(0xFF281e28),
                      child: const Text(
                        "Download",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  )


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BookSelectScreen()));
          },
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text('Customize',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.close, size: 20, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildRack(List<String> tiles) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 170,
            width: 420,
            child: Image.asset("assets/images/rack.png", fit: BoxFit.fitWidth),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 160,
                  width: 400,
                  alignment: Alignment.center,
                  child: ReorderableListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final tile in tiles)
                        Padding(
                          key: ValueKey(tile),
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: 85,
                            child: Image.asset(
                              tile,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) newIndex -= 1;
                        final String tile = tiles.removeAt(oldIndex);
                        tiles.insert(newIndex, tile);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff332732),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.fourRotatingDots(
                color: Colors.white, size: 50),
            const SizedBox(height: 15),
            const Text(
              'Creating Image',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Canela',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
