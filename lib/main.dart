import 'package:ballot/login.dart';
import 'package:ballot/startvoting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => BallotApp(),
    '/login': (context) => LoginPage(),
    '/startvoting': (context) => StartVoting()
  }));
}

class BallotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (pref.getString("userid").isEmpty) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 2),
            pageBuilder: (_, __, ___) => LoginPage(),
          ),
        );
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StartVoting()));
      }
    });
    return Scaffold(
      backgroundColor: Color(0xFF08162D),
      body: SafeArea(
        child: Center(
          child: Hero(
            tag: 'app_icon_transition',
            child: Image.asset('assets/images/img_splash_screen.png'),
          ),
        ),
      ),
    );
  }
}
