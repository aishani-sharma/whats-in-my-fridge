import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2C4CE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'WHATS IN\nMY FRIDGE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PixelFont',
                fontSize: 24,
                color: const Color(0xFF3D1F0D),
                height: 1.8,
              ),
            ),

            const SizedBox(height: 60),

            // Button
            GestureDetector(
              onTap: () {
                // navigation goes here later
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F3),
                  border: Border.all(
                    color: const Color(0xFF5C3317),
                    width: 3,
                  ),
                ),
                child: Text(
                  'START COOKING',
                  style: TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 12,
                    color: const Color(0xFF5C3317),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}