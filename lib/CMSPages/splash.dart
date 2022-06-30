import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ParentComplaint.dart';
import 'log_in_screen.dart';

class  splash extends StatefulWidget{
  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<splash> {
  startTime() async {
    var _duration = Duration(seconds: 3);

    return Timer(_duration, navigationPage);

  }

  Future<void> navigationPage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final read_value = prefs.getString(key) ?? 0;
    Navigator.of(context).pop();
     if(read_value==0){
       Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
     }else{
       Navigator.push(context, MaterialPageRoute(builder: (context) => ParentComplaint()));
     }

  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/punjab.png',
                width: 200,
                height: 200,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }





