import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingOverlay extends StatelessWidget {
  final double heightMultiplier;

  const LoadingOverlay({required this.heightMultiplier});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        child: Container(
          color: Color(0xff332732),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 50,
                ),
                SizedBox(height: 15 * heightMultiplier),
                const Text(
                  'Creating Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Canela',
                  ),
                  semanticsLabel: 'Creating Image',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}