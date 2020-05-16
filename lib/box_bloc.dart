import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BoxBloc {
  double initialX = 0;
  double initialY = 0;
  int score = 0;
  bool gameON = false;
  BehaviorSubject<Widget> _subjectBox;
  BehaviorSubject<bool> _subjectGame;
  BehaviorSubject<int> _subjectScore;

  BoxBloc({this.initialX, this.initialY}) {
    _subjectBox = BehaviorSubject.seeded(_drawBox());
    _subjectGame = BehaviorSubject.seeded(false);
    _subjectScore = BehaviorSubject.seeded(0);
  }

  Stream<Widget> get boxObservable => _subjectBox.stream;

  Stream<bool> get gameObservable => _subjectGame.stream;

  Stream<int> get scoreObservable => _subjectScore.stream;

  void gameToggle() async {
    if (this.gameON) {
      gameON = false;
      _subjectGame.sink.add(false);
    } else {
      gameON = true;
      score = 0;
      _subjectScore.sink.add(score);
      _subjectGame.sink.add(true);
      while (gameON) {
        initialY = (Random().nextDouble() * 2) - 1;
        initialX = (Random().nextDouble() * 2) - 1;
        await Future.delayed(
          Duration(milliseconds: (Random().nextInt(10) + 3) * 100),
          () => _subjectBox.sink.add(_drawBox()),
        );
      }
    }
  }

  Widget _drawBox() {
    double _size = (Random().nextDouble() + 0.1) * 100;
    return Align(
      alignment: Alignment(initialX, initialY),
      child: SizedBox(
        height: _size,
        width: _size,
        child: GestureDetector(
          onTap: () {
            if (gameON) {
              score++;
              _subjectScore.sink.add(score);
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
