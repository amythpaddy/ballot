import 'dart:convert';

import 'package:ballot/modelquestiondata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(BallotApp());
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: getBody(context),
      ),
    );
  }

  List<Widget> getBody(BuildContext context) {
    List<Widget> body = List();
    Expanded question = Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          questionData.question,
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        )),
      ),
    );
    List<Widget> options = getOptions(context);
    body.add(question);
    body = body + options;
    return body;
  }

  List<Widget> getOptions(BuildContext context) {
    List<Widget> options = List();
    if (!showGraph) {
      print("showing options");
      for (int i = 0; i < questionData.optionList.length; i++) {
        if (questionData.optionList[i] != null)
          options.add(makeOptionText(questionData.optionList[i], i));
      }
    } else {
      print("showing graph");
      for (int i = 0; i < questionData.optionVotes.length; i++) {
        if (questionData.optionVotes[i] != null) {
          double part = questionData.optionVotes[i] / questionData.totalVotes;
          options.add(makeOptionBar(context, part, i));
        }
      }
    }
    print(options);
    return options;
  }

  Widget makeOptionText(String optionText, int pos) {
    Color bgcolor;

    if ((pos + 1) % 2 == 0)
      bgcolor = Colors.blueGrey[600];
    else
      bgcolor = Colors.blueGrey[400];
    return Container(
      width: double.infinity,
      color: bgcolor,
      child: FlatButton(
        onPressed: () => {
          updateOptionVote(pos),
        },
        child: Center(
          child: Text(
            optionText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void getNextQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response res = await http.post(
      "http://192.168.1.7:3000/getnextquestion",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{"userid": prefs.getString("userid")}),
    );
    print(prefs.getString("userid"));
    if (res.statusCode == 200) {
      print(res.body);
      Map data = jsonDecode(res.body);
      setState(() {});
      questionData.updateData(data);
    } else {
      print("Some error" + res.statusCode.toString());
    }
  }

  void updateOptionVote(int vote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response res = await http.post(
      "http://192.168.1.7:3000/updateoption",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "option": vote,
        "id": questionData.id,
        "userid": prefs.getString("userid")
      }),
    );
    print(res.body);
    setState(() {
      questionData.updateVoteData(jsonDecode(res.body));
      showGraph = true;
    });
  }

  @override
  void initState() {
    getNextQuestion();
  }

  Widget makeOptionBar(BuildContext context, double percent, int pos) {
    Color bgcolor;
    print(MediaQuery.of(context).size.width * percent);
    if ((pos + 1) % 2 == 0)
      bgcolor = Colors.blueGrey[500];
    else
      bgcolor = Colors.blueGrey[400];
    return Container(
      width: double.infinity,
      color: bgcolor,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          AnimatedContainer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.amber, Colors.amber[100]])),
            ),
            width: MediaQuery.of(context).size.width * percent,
            duration: Duration(seconds: 1),
            height: 38,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              questionData.optionList[pos],
              style: TextStyle(fontSize: 16),
            ),
          ),
          Positioned(
              right: 5,
              top: 10,
              child: Text(
                questionData.optionVotes[pos].toString(),
                style: TextStyle(color: Colors.cyan[900], fontSize: 14),
              ))
        ],
      ),
    );
  }
}

bool showGraph = false;
QuestionData questionData = new QuestionData();

class BallotApp extends StatefulWidget {
  // This widget is the root of your application.

  _setUserID() async {
    print("init state called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userid", "randomid");
  }

  @override
  _BallotAppState createState() => _BallotAppState();
}

class _BallotAppState extends State<BallotApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
//        backgroundColor: Colors.black,
        body: SafeArea(child: Body()),
      ),
    );
  }

  @override
  void initState() {
    _setUserID();
  }

  _setUserID() async {
    print("init state called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userid", "randomid");
  }
}
