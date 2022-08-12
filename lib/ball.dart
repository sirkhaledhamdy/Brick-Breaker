import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  final bool isGameOver;
  final bool hasGameStarted;
  MyBall({required this.ballY , required this.ballX ,required this.isGameOver , required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted ? Container(
      alignment: Alignment(ballX,ballY),
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: isGameOver ? Colors.green.shade300 : Colors.green.shade700,
          shape: BoxShape.circle,
        ),
      ),
    ) : Container(
      alignment: Alignment(ballX , ballY),
      child: AvatarGlow(
        endRadius: 60.0,
        child: Material(
          elevation: 8.0,
          shape: CircleBorder(
          ),
          child: CircleAvatar(
            backgroundColor: Colors.green[100],
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              width: 20,
              height: 20,
            ),
            radius: 10.0,
          ),
        ),
      ),
    );
  }
}
