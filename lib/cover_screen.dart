import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;
  final bool isGameOver;
  //font
  static var gameFont = GoogleFonts.pressStart2p(
      textStyle: TextStyle(
          color: Colors.green.shade700, letterSpacing: 0, fontSize: 28));

  CoverScreen({required this.hasGameStarted , required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted == true
        ? Container(
      alignment: Alignment(0,-0.5),
      child:  Text(
       isGameOver ?'':'Brick Breaker',
        style: gameFont.copyWith(color: Colors.green.shade200),
      ),
    )
        : Stack(
          children: [
            Container(
              alignment: Alignment(0, -0.5),
              child: Text(
                'Brick Breaker',
                style: gameFont,
              ),
            ),
            Container(
                alignment: Alignment(0, -0.1),
                child: Text(
                  'Tap to play',
                  style: TextStyle(
                    color: Colors.green.shade400,
                  ),
                ),
                ),
          ],
        );
  }
}
