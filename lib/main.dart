
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:writings/Writing.dart';
import 'package:writings/homeScreen.dart';
import 'writingScreen.dart';
import 'package:writings/writingCreation.dart';
import 'package:writings/writingViewing.dart';

void main() => runApp(new MaterialApp(
  initialRoute: "/home",
  routes: {"/home": (context) => homeScreen(),
          "/writingScreen" : (context) => writingScreen(),
          "/writingCreation" : (context) => writingCreationScreen(),
          "/writingViewing" : (context) => writingViewing(),
  },
));



