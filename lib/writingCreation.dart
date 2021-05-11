import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:writings/Writing.dart';

class writingCreationScreen extends StatefulWidget {
  @override
  _writingCreationScreenState createState() => _writingCreationScreenState();
}

class _writingCreationScreenState extends State<writingCreationScreen> {
  @override

  String importance = "Normal";

  TextEditingController titleInputController = new TextEditingController();
  TextEditingController descriptionInputController = new TextEditingController();
  TextEditingController textInputController = new TextEditingController();



  Widget build(BuildContext context) {
    Map writingsMap = ModalRoute.of(context).settings.arguments;
    List<Writing> writings = writingsMap["writings"];
    HashSet tags = writingsMap["tags"];
    Map tagCheckValues = writingsMap["tagCheckValues"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Writing creation"),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        color: Colors.blueGrey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField( //TODO: Limit input size on each of the text boxes.
              controller: titleInputController,
              decoration: InputDecoration(
                labelText: "Title"
              ),
            ),
            TextField(
              controller: descriptionInputController,
              decoration: InputDecoration(
                labelText: "Description"
              ),
            ),
            TextField(
              controller: textInputController,
              decoration: InputDecoration(
                labelText: "Text"
              ),
            ),
            DropdownButton(
              hint: Text("Importance"),
              icon: Icon(Icons.assessment),
              value: importance,
              items: ["Normal", "Medium", "High", "Red pill"].map((importanceValue) {
                  return DropdownMenuItem(
                      value: importanceValue,
                      child: Text(importanceValue,
                      style: TextStyle(
                        color: Colors.black,
                      ),),
                  );
                }).toList(),
              onChanged: (value) {
                setState(() {
                  importance = value;
                });
              },
            ),
            Expanded(
              child: ListView(
                children: tags.map((tag) {
                  return CheckboxListTile(
                      value: tagCheckValues[tag],
                      onChanged: (newValue) {
                        setState(() {
                          tagCheckValues[tag] = newValue;
                        });
                      },
                      title: Text(tag),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Set selectedTags = new Set();
          for(String key in tagCheckValues.keys){
            if(tagCheckValues[key] == true){
              selectedTags.add(key);
            }
          }
          writings.add(new Writing(titleInputController.text, descriptionInputController.text, textInputController.text, DateTime.now(), importance, selectedTags));
          Navigator.pop(context);
        },
        child: Icon(Icons.double_arrow_sharp),
      ),
    );
  }
}
