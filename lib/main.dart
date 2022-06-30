import 'dart:async';
import 'dart:io' show Platform ;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'CMSPages/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      // home: DBTestPage(),
      home: splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}