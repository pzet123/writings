import 'package:flutter/material.dart';
import 'package:writings/Writing.dart';

class writingCreationScreen extends StatefulWidget {
  @override
  _writingCreationScreenState createState() => _writingCreationScreenState();
}

class _writingCreationScreenState extends State<writingCreationScreen> {
  @override
  Widget build(BuildContext context) {
    List<Writing> writings = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Writing creation"),
      ),
      body: Column(
        children: [
          Text(writings[0].text),
          Divider(),
          Text(writings[0].description),
        ],
      )
    );
  }
}
