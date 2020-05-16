import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BoxBloc {
  double x = 0;
  double y = 0;
  int score = 0;
  int totalSeconds = 60;
  bool gameON = false;
  StreamSubscription _timer;
  BehaviorSubject<Widget> _subjectBox;
  BehaviorSubject<bool> _subjectGame;
  BehaviorSubject<int> _subjectScore;
  BehaviorSubject<int> _subjectTimer;

  BoxBloc({this.x, this.y,this.totalSeconds}) {
    _subjectBox = BehaviorSubject.seeded(_drawBox());
    _subjectGame = BehaviorSubject.seeded(false);
    _subjectScore = BehaviorSubject.seeded(0);
    _subjectTimer = BehaviorSubject.seeded(this.totalSeconds);
  }

  Stream<Widget> get boxObservable => _subjectBox.stream;

  Stream<bool> get gameObservable => _subjectGame.stream;

  Stream<int> get scoreObservable => _subjectScore.stream;

  Stream<int> get timerObservable => _subjectTimer.stream;

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
    _stopTimer();
  }

  void _startGame() {
    _resetScore();
    gameON = true;
    _subjectGame.sink.add(true);
    _startTimer(Duration(seconds: totalSeconds));
  }

  void _startTimer(Duration totalDuration){
    _timer = CountdownTimer(totalDuration, Duration(seconds: 1)).listen((data){
    })..onData((data){
      _subjectTimer.sink.add(data.remaining.inSeconds);
    })..onDone((){
      _stopGame();
    });
  }

  void _stopTimer(){
    _timer.cancel();
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
    _subjectTimer.close();
  }
}
