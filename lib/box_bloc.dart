import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BoxBloc {
  double x = 0;
  double y = 0;
  int score = 0;
  bool gameON = false;
  BehaviorSubject<Widget> _subjectBox;
  BehaviorSubject<bool> _subjectGame;
  BehaviorSubject<int> _subjectScore;

  BoxBloc({this.x, this.y}) {
    _subjectBox = BehaviorSubject.seeded(_drawBox());
    _subjectGame = BehaviorSubject.seeded(false);
    _subjectScore = BehaviorSubject.seeded(0);
  }

  Stream<Widget> get boxObservable => _subjectBox.stream;

  Stream<bool> get gameObservable => _subjectGame.stream;

  Stream<int> get scoreObservable => _subjectScore.stream;

  void gameToggle() async {
    if (this.gameON) {
      _stopGame();
    } else {
      _startGame();
      while (gameON) {
        await Future.delayed(
          Duration(milliseconds: (Random().nextInt(10) + 3) * 100),
          () => _subjectBox.sink.add(_drawBox()),
        );
      }
    }
  }

  void _increaseScore() {
    score++;
    _subjectScore.sink.add(score);
  }

  void _resetScore() {
    score = 0;
    _subjectScore.sink.add(score);
  }

  void _stopGame() {
    gameON = false;
    _subjectGame.sink.add(false);
  }

  void _startGame() {
    _resetScore();
    gameON = true;
    _subjectGame.sink.add(true);
  }

  Widget _drawBox() {
    y = (Random().nextDouble() * 2) - 1;
    x = (Random().nextDouble() * 2) - 1;
    double _size = (Random().nextDouble() + 0.1) * 100;
    return Align(
      alignment: Alignment(x, y),
      child: SizedBox(
        height: _size,
        width: _size,
        child: GestureDetector(
          onTap: () {
            if (gameON) {
              _increaseScore();
            }
          },
          child: Container(
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: Color.fromARGB(
                255,
                Random().nextInt(256),
                Random().nextInt(256),
                Random().nextInt(256),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dispose() {
    _subjectBox.close();
    _subjectGame.close();
    _subjectScore.close();
  }
}
