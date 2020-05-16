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
  BoxBloc _boxBloc = BoxBloc(initialX: 0.0, initialY: 0.0);

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
            padding: const EdgeInsets.only(right:16.0),
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          StreamBuilder(
            stream: _boxBloc.boxObservable,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<Object>(
        stream: _boxBloc.gameObservable,
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
