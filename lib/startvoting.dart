import 'dart:convert';

import 'package:ballot/modelquestiondata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartVoting extends StatefulWidget {
  @override
  _StartVotingState createState() => _StartVotingState();
}

class _StartVotingState extends State<StartVoting> {
  QuestionData questionData;
  bool _fetchingData = true;
  bool _showVotes = false;

  /*var _question =
      'In the end of Inception is Cobb Still dreaming or is that all real?';
  var _option1 = 'He was dreaming all through the movie.';
  var _option2 = 'No, He was really back home';
  var _option3 =
      'His dreams were his reality, so yes it was real, but still a dream.';
  var _option4 = 'I was not able to understand any thing';*/

  @override
  void initState() {
    questionData = QuestionData();
    print(questionData.option1);
    getNextQuestion();
  }

  void getNextQuestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Response res = await post(
      "http://192.168.1.2:3000/getnextquestion",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{"userid": pref.getString("userid")}),
    );
    print(res.body);
    setState(() {
      questionData.updateData(jsonDecode(res.body));
      _fetchingData = false;
    });
  }

  void postVoteFromUser(int option) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Response res = await post(
      "http://192.168.1.2:3000/updateoption",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "userid": pref.getString("userid"),
        "questionid": questionData.id,
        "option": option
      }),
    );
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    if (_fetchingData) {
      return MaterialApp(
          home: SafeArea(
              child: Scaffold(
                  backgroundColor: Color(0xFF08162D),
                  body: Center(child: CircularProgressIndicator()))));
    } else
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xFF08162D),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 79, left: 53, right: 53),
                    child: Text(
                      questionData.question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontFamily: 'Comfortaa',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 35),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                    color: Color(0xFFE7DCDC),
                  ),
                  child: Column(
                    children: [
                      OptionCard(
                        this,
                        option: questionData.option1,
                        position: 0,
                      ),
                      OptionCard(
                        this,
                        option: questionData.option2,
                        position: 1,
                      ),
                      OptionCard(
                        this,
                        option: questionData.option3,
                        position: 2,
                      ),
                      OptionCard(
                        this,
                        option: questionData.option4,
                        position: 3,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}

class OptionCard extends StatelessWidget {
  const OptionCard(
    _StartVotingState startVotingState, {
    Key key,
    @required String option,
    @required int position,
  })  : _option = option,
        _position = position,
        _startVotingState = startVotingState,
        super(key: key);

  final String _option;
  final int _position;
  final _StartVotingState _startVotingState;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        _startVotingState.postVoteFromUser(_position);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _option,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFAF2727),
                  fontFamily: 'Coustard'),
            ),
          ),
        ),
      ),
    );
  }
}

voteForOption(int position) async {}
