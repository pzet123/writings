import 'package:flutter/material.dart';
import 'package:writings/Writing.dart';

class writingViewing extends StatefulWidget {
  @override
  _writingViewingState createState() => _writingViewingState();
}

class _writingViewingState extends State<writingViewing> {
  @override
  Widget build(BuildContext context) {
    Writing writing = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Writing view"),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child: Column(
          children: [
            SizedBox(height: 12,),
            Text(
                writing.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            ),
            Divider(thickness: 2, height: 5,),
            Text(writing.description),
            Divider(thickness: 4, height: 10,),
            SingleChildScrollView(
              child: Text(
                writing.text,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
