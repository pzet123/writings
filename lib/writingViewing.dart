import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:writings/Writing.dart';

class writingViewing extends StatefulWidget {
  @override
  _writingViewingState createState() => _writingViewingState();
}
//TODO: In order to allow for editing writings, create a button which will pass the current writing information to the writing creation screen allowing the user to modify it.
class _writingViewingState extends State<writingViewing> {
  @override
  Widget build(BuildContext context) {
    Writing writing = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(writing.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.grey[100],
        ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(
        color: Colors.blueGrey[200],
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ListView(
                  children: [
                    SizedBox(height: 8,),
                    Text(writing.description,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 18
                        )),
                    Divider(thickness: 4,
                      height: 12,
                      color: Colors.blueGrey[700],
                    ),
                    Text(
                    writing.text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ]
                ),
              ),
            ),
            Divider(thickness: 3, height: 5,),
            Container(
              color: Colors.blueGrey,
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child:
                  Text("Importace level: " + writing.importance,
                  style: TextStyle(fontSize: 18),)),
                  Divider(thickness: 2, color: Colors.white,),
                  Center(child:
                  Text(writing.dateOfWriting.toString().substring(0, 16),
                      style: TextStyle(fontSize: 18))),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
