import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(ChessClockApp());

class ChessClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChessClockScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChessClockScreen extends StatefulWidget {
  @override
  _ChessClockScreenState createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends State<ChessClockScreen> {
  Duration player1Time = Duration(minutes: 1); // 1-minute timer for player 1
  Duration player2Time = Duration(minutes: 1); // 1-minute timer for player 2
  Timer? player1Timer;
  Timer? player2Timer;
  bool isPlayer1Turn = true;

  // Function to start player 1's timer
  void startPlayer1Timer() {
    player1Timer?.cancel(); // Stop any previous timers
    player1Timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (player1Time.inSeconds > 0) {
          player1Time = player1Time - Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  // Function to start player 2's timer
  void startPlayer2Timer() {
    player2Timer?.cancel();
    player2Timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (player2Time.inSeconds > 0) {
          player2Time = player2Time - Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  void togglePlayer() {
    if (isPlayer1Turn) {
      player1Timer?.cancel();
      startPlayer2Timer();
    } else {
      player2Timer?.cancel();
      startPlayer1Timer();
    }
    setState(() {
      isPlayer1Turn = !isPlayer1Turn;
    });
  }

  @override
  void dispose() {
    player1Timer?.cancel();
    player2Timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: isPlayer1Turn ? togglePlayer : null, // Only respond if it's player 1's turn
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    formatDuration(player1Time),
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: !isPlayer1Turn ? togglePlayer : null, // Only respond if it's player 2's turn
              child: Container(
                color: Colors.grey,
                child: Center(
                  child: Text(
                    formatDuration(player2Time),
                    style: TextStyle(fontSize: 48, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to format the duration into a readable format (minutes:seconds)
  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
