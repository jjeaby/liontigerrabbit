import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class Level1MainPage extends StatefulWidget {
  Level1MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _Level1MainPageState createState() => _Level1MainPageState();
}

class _Level1MainPageState extends State<Level1MainPage> {
  String _question;
  int _questionMaxCount = 10;
  int _questionCount = 0;
  int _correct = 0;
  int _notcorrect = 0;
  TextEditingController _answer = new TextEditingController();

  _readFile() async {
    String text = await rootBundle.loadString('assets/word.txt');
    List wordList = text.split("\n");
    Random random = new Random();
    int randomNumber = random.nextInt(wordList.length - 1);
    setState(() {
      _question = wordList[randomNumber];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _question = "문제";
    _readFile();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "쓰기 연습",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )),
          ),
          Center(
              child: Text(
            "${_questionCount + 1} 번째 문제 : ${_correct} 개 맞음 ${_notcorrect} 개 틀림 ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Container(
              width: 300,
              height: 100,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                ), //             <--- BoxDecoration here
                child: Center(
                  child: Text(
                    _question,
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
              ),
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 150,
                  child: TextField(
                      controller: _answer,
                      maxLength: 15,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 58,
                  child: RaisedButton(
                      child: Text('OK', style: TextStyle(fontSize: 26)),
                      onPressed: () {
                        setState(() {
                          if (_answer.text.trim() != "") {
                            _questionCount++;

                            if (_answer.text == _question) {
                              _correct++;
                            } else {
                              _notcorrect++;
                            }

                            if (_correct + _notcorrect == _questionMaxCount) {
                              _questionCount = 10;
                              _showDialog(
                                  "점수", "${_correct} 개 맞음 ${_notcorrect} 개 틀림");
                              _answer.text = "";
                              _questionCount = 0;
                              _correct = 0;
                              _notcorrect = 0;

                            } else {
                              _answer.text = "";
                              _readFile();
                            }
                          }
                        });
                      }),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDialog(title, message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
