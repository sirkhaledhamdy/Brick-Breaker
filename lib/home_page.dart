import 'dart:async';

import 'package:booking_app/brick.dart';
import 'package:booking_app/cover_screen.dart';
import 'package:booking_app/game_over.dart';
import 'package:booking_app/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ball.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { UP, DOWN , LEFT , RIGHT }

class _HomePageState extends State<HomePage> {
  //ball variables
  double ballX = 0.0;
  double ballY = 0.0;
  double ballXincrements = 0.008;
  double ballYincrements = 0.008;
  var ballYDirection = Direction.DOWN;
  var ballXDirection = Direction.LEFT;

  //player variables
  double playerX = -0.2;
  double playerWidth = 0.5;


  //gameSettings variables
  bool hasGameStarted = false;
  bool isGameOver = false;
  bool isGameSuccess = false;


  // brick variables
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4; // out of 2
  static double brickHeight = 0.05; // out of 2
  static double brickGap = 0.01;
  static int numberOfBricksInRow = 4;

  static double wallGap = 0.5 * (2-numberOfBricksInRow * brickWidth - (numberOfBricksInRow-1)*brickGap);
  List MyBricks = [
    // [x,y , brocken = true / false ]
    [firstBrickX + 0 *(brickWidth + brickGap)  , firstBrickY , false],
    [firstBrickX + 1 * (brickWidth + brickGap) , firstBrickY , false],
    [firstBrickX + 2 * (brickWidth + brickGap) , firstBrickY , false],
    [firstBrickX + 3 * (brickWidth + brickGap) , firstBrickY , false],
  ];
  //start Game
  startGame() {
    hasGameStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      //move ball
      moveBall();
      //update ball Direction
      updateDirection();
      //check to see if game is over
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }else{
        isGameSuccess = true;
      }
      // check if the brick hit
      checkForBrokenBricks();
    });
  }

  //ball move
  moveBall() {
    setState(() {

      //move horizontally
      if (ballXDirection == Direction.LEFT) {
      ballX -= ballXincrements;
      } else if (ballXDirection == Direction.RIGHT) {
      ballX += ballXincrements;
      }
      //move vertically
      if (ballYDirection == Direction.DOWN) {
        ballY += ballYincrements;
      } else if (ballYDirection == Direction.UP) {
        ballY -= ballYincrements;
      }
    });
  }

  //player move left
  moveLeft() {
    setState(() {
      if (!(playerX - 0.07 < -1)) {
        playerX -= 0.07;
      }
    });
  }

//player move right
  moveRight() {
    setState(() {
      if (!(playerX + playerWidth > .95)) {
        playerX += 0.07;
      }
    });
  }

//Update the direction of the ball
  updateDirection() {
    setState(() {

      //ball goes up when it touch the player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = Direction.UP;
        // ball goes down when it hits the brick
      } else if (ballY <= -1) {
        ballYDirection = Direction.DOWN;
      }
      // ball goes left when it hit the right wall
      if(ballX >= 1){
        ballXDirection = Direction.LEFT;
        // ball goes right when it hits the left wall
      } else if(ballX <= -1){
        ballXDirection = Direction.RIGHT;
      }

    });
  }

  // game over check
  isPlayerDead() {
    // player die if he reach bottom.
    if (ballY >= 1) {
      return true;
    } else {
      return false;
    }
  }

  // check for broken bricks
  checkForBrokenBricks() {
    //check for ball hit of the brick
    for(int i=0; i < MyBricks.length; i++){
      if (ballX >= MyBricks[i][0] &&
          ballX <= MyBricks[i][0] + brickWidth &&
          ballY <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;
          //since brick is broken , update the direction  of the brick.
          // based on which side of the brick is touched
          // to do this , calculate the distance of the ball from each of the 4 sides
          // the smallest is the side of the ball

          double leftSideDistance = (MyBricks[i][0] - ballX).abs();
          double rightSideDistance = (MyBricks[i][0]+ brickWidth - ballX).abs();
          double topSideDistance = (MyBricks[i][1] - ballY).abs();
          double bottomSideDistance = (MyBricks[i][1] + brickHeight - ballY).abs();
          String min = findMin(leftSideDistance , rightSideDistance ,topSideDistance , bottomSideDistance);
          switch (min) {
            case 'left' :
              ballXDirection = Direction.LEFT;
              break;
            case 'right' :
              ballXDirection = Direction.RIGHT;
              break;
            case 'top' :
              ballYDirection = Direction.UP;
              break;
            case 'bottom' :
              ballYDirection = Direction.DOWN;
              break;
          }
        });
    }
    }
  }

  //returns the smallest side distance
  String findMin(double a , double b , double c , double d){
    List<double> myList = [
      a,
      b,
      c,
      d,
    ];

    double currentMin = a;
    for(int i = 0; i < myList.length; i++){
      if(myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }
    if ((currentMin - a).abs() < 0.01){
      return 'left';
    }else if ((currentMin - b).abs() < 0.01){
      return 'right';
    }else if ((currentMin - c).abs() < 0.01){
      return 'top';
    }else if ((currentMin - d).abs() < 0.01) {
      return 'right';
    }
    return '';
  }

  //reset game
  resetGame(){
    setState(() {
      playerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;

      MyBricks = [
        // [x,y , brocken = true / false ]
        [firstBrickX + 0 *(brickWidth + brickGap)  , firstBrickY , false],
        [firstBrickX + 1 * (brickWidth + brickGap) , firstBrickY , false],
        [firstBrickX + 2 * (brickWidth + brickGap) , firstBrickY , false],
        [firstBrickX + 3 * (brickWidth + brickGap) , firstBrickY , false],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          int sensitivity = 1;
          if (details.delta.dx > sensitivity/20) {
            moveRight();
          } else if (details.delta.dx < sensitivity/20) {
            moveLeft();
          }
        },
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.green.shade100,
          body: Center(
            child: Stack(
              children: [
                //tap to play
                CoverScreen(hasGameStarted: hasGameStarted , isGameOver: isGameOver,),
                // game over
                GameOverScreen(isGameOver: isGameOver , function: resetGame,),
                //ball
                MyBall(ballY: ballY, ballX: ballX , hasGameStarted : hasGameStarted , isGameOver: isGameOver,),
                //player
                MyPlayer(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),
                // bricks
                BrickScreen(
                  brickX: MyBricks[0][0],
                  brickY: MyBricks[0][1],
                  brickBroken: MyBricks[0][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,

                ),
                BrickScreen(
                  brickX: MyBricks[1][0],
                  brickY: MyBricks[1][1],
                  brickBroken: MyBricks[1][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,

                ),
                BrickScreen(
                  brickX: MyBricks[2][0],
                  brickY: MyBricks[2][1],
                  brickBroken: MyBricks[2][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                ),
                BrickScreen(
                  brickX: MyBricks[3][0],
                  brickY: MyBricks[3][1],
                  brickBroken: MyBricks[3][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
