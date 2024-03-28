import 'package:flutter/material.dart';
import 'dart:ui';

class YouWin extends StatelessWidget {
  const YouWin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/YouWin.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5), // Adjust the blur intensity as needed
                child: Container(
                  color: Colors.black.withOpacity(
                      0), // This is necessary to enable the blur effect
                ),
              ),
            ),
            Center(
              child: Text(
                "You Win!!!",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
