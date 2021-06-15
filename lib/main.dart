
import 'package:Pilled/StateWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import "Writing.dart";
import "helpEntryScreen.dart";
import "homeScreen.dart";
import 'writingScreen.dart';
import "writingCreation.dart";
import "writingViewing.dart";
import 'helpScreen.dart';

void main() {

  runApp(StateWidget(
    child: Builder(builder : (context) {


      return MaterialApp(
        initialRoute: "/home",
        routes: {"/home": (context) => homeScreen(),
              "/writingScreen" : (context) => writingScreen(),
              "/writingCreation" : (context) => writingCreationScreen(),
              "/writingViewing" : (context) => writingViewing(),
              "/helpScreen" : (context) => helpScreen(),
              "/helpEntryScreen" : (context) => helpEntryScreen(),
      });
}
    ),
  ));

}


