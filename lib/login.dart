import 'dart:convert';

import 'package:ballot/startvoting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _newuser = false;
  bool _autovalidate = false;

  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF08162D),
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Hero(
                    tag: 'app_icon_transition',
                    child: Image.asset(
                      'assets/images/img_splash_screen.png',
                      height: 227,
                      width: 134,
                    ),
                  ),
                ),
                AnimatedContainer(
                    duration: Duration(seconds: 1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 36, fontFamily: 'Comfortaa'),
                          ),
                        ),
                        WidgetEnterData(
                            showThis: true,
                            hintText: 'Enter Your Email ID',
                            controller: emailController),
                        WidgetEnterData(
                          showThis: _newuser,
                          hintText: 'Enter Your Age',
                        ),
                        WidgetEnterData(
                          showThis: _newuser,
                          hintText: 'Enter Your Gender',
                        )
                      ],
                    )),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                  ),
                  child: FlatButton(
                    onPressed: getLoginStatus,
                    child: Text(
                      'SignIn',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Comfortaa'),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }

  void getLoginStatus() async {
    if (!_newuser) {
      http.Response res = await http.post(
        "http://192.168.1.2:3000/getuser",
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{"emailid": emailController.text}),
      );
      if (res.statusCode == 200) {
//      print(res.body);
        Map data = jsonDecode(res.body);
        if (!data["userstatus"]) {
          setState(() {
            _newuser = true;
          });
        } else {
          SharedPreferences pref = await SharedPreferences.getInstance();
          print(data);
          pref.setString("userid", data["userid"]);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StartVoting()));
        }
      } else {
        print("Some error" + res.statusCode.toString());
      }
    }
  }
}

class WidgetEnterData extends StatelessWidget {
  const WidgetEnterData(
      {Key key, @required this.showThis, this.hintText, this.controller})
      : super(key: key);
  final bool showThis;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainAnimation: true,
      maintainState: true,
      maintainSize: false,
      visible: showThis,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: controller,
          autovalidate: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            hintText: hintText,
          ),
          style: TextStyle(fontFamily: 'Comfortaa'),
        ),
      ),
    );
  }
}
