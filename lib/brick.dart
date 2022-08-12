import 'package:flutter/material.dart';

class BrickScreen extends StatelessWidget {
  final brickHeight;
  final brickWidth;
  final brickX;
  final brickY;
  final bool brickBroken;
  BrickScreen(
      {this.brickWidth,
      this.brickHeight,
      this.brickX,
      this.brickY,
      required this.brickBroken});



  @override
  Widget build(BuildContext context) {
    return brickBroken == true
        ? Container(
    )
        : Container(
            alignment: Alignment((2*brickX+brickWidth)/(2-brickWidth), brickY),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: MediaQuery.of(context).size.height * brickHeight / 2,
                width: MediaQuery.of(context).size.width * brickWidth / 2,
                color: Colors.green.shade700,
              ),
            ),
          );
  }
}
