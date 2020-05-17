import 'dart:math';

import 'package:counterbloc/box_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLoC',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.tealAccent,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _totalDuration = 60;
  BoxBloc _boxBloc;

  @override
  void initState() {
    super.initState();
    _boxBloc = BoxBloc(x: 0.0, y: 0.0, totalSeconds: _totalDuration);
  }

  @override
  void dispose() {
    _boxBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLoC"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: StreamBuilder(
              stream: _boxBloc.scoreObservable,
              builder: (_, snapshot) {
                return Text(
                  snapshot.data.toString(),
                  style: Theme.of(context).textTheme.display2,
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StreamBuilder(
            stream: _boxBloc.timerObservable,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return LinearProgressIndicator(
                  value: snapshot.data / _totalDuration,
                  backgroundColor: Colors.red[50],
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                );
              } else {
                return LinearProgressIndicator(
                  backgroundColor: Colors.red[50],
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                );
              }
            },
          ),
          Expanded(
            child: StreamBuilder(
              stream: _boxBloc.positionObservable,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return GameTarget(
                    alignment: snapshot.data,
                    boxBloc: _boxBloc,
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<Object>(
        stream: _boxBloc.gameStateObservable,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              onPressed: _boxBloc.gameToggle,
              child: snapshot.data ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            );
          } else {
            return Container(width: 0.0, height: 0.0);
          }
        },
      ),
    );
  }
}

class GameTarget extends StatelessWidget {
  final BoxBloc boxBloc;
  final Alignment alignment;

  const GameTarget({Key key, this.boxBloc, this.alignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _size = (Random().nextDouble() + 0.1) * 100;
    return Align(
      alignment: alignment,
      child: SizedBox(
        height: _size,
        width: _size,
        child: GestureDetector(
          onTap: () {
            if (boxBloc.gameON) {
              boxBloc.increaseScore();
            }
          },
          child: Container(
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(width: 2.0, color: ColorUtil.getRandomColor()),
              ),
              color: ColorUtil.getRandomColor(),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorUtil {
  static Color getRandomColor() {
    return Color.fromARGB(
      255,
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
    );
  }
}
