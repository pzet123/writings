import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:writings/Writing.dart';

class writingCreationScreen extends StatefulWidget {
  @override
  _writingCreationScreenState createState() => _writingCreationScreenState();
}

class _writingCreationScreenState extends State<writingCreationScreen> {
  @override

  String importance = "Medium";
  HashSet tags;
  Map tagCheckValues = new Map();

  TextEditingController titleInputController = new TextEditingController();
  TextEditingController descriptionInputController = new TextEditingController();
  TextEditingController textInputController = new TextEditingController();
  TextEditingController newTagController = new TextEditingController();

  @override
  void dispose(){
    titleInputController.dispose();
    descriptionInputController.dispose();
    textInputController.dispose();
    newTagController.dispose();
    super.dispose();
  }

  createNewTagWindow(BuildContext context){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("New tag"),
        content: TextField(controller: newTagController,),
        actions: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  tags.add(newTagController.text);
                  tagCheckValues[newTagController.text] = false;
                  Navigator.pop(context);
                });
      },
          child: Text("Submit"),
          )
        ],
      );
    });
  }

  createNewInputAlertWindow(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Invalid Input"),
        content: Text("One or more of the text fields have been left blank"),
      );
    });
  }

  void fillWritingInformation(Writing writing, ){
    titleInputController.text = writing.title;
    descriptionInputController.text = writing.description;
    textInputController.text = writing.text;
    importance = writing.importance;
  }



  Widget build(BuildContext context) {
    Map writingsMap = ModalRoute.of(context).settings.arguments;
    bool editingWriting = writingsMap["editingWriting"];
    Writing writingToEdit = writingsMap["writingToEdit"];
    tags = writingsMap["tags"];
    tagCheckValues = writingsMap["tagCheckValues"];
    if(editingWriting && !validTextInput()){
      fillWritingInformation(writingToEdit);
    }
    return Scaffold(
      appBar: AppBar(
        title: editingWriting?Text("Writing Modification"):Text("Writing Creation"),
        backgroundColor: Colors.blueGrey[700],
        centerTitle: true,
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
              icon: Icon(Icons.keyboard_arrow_down),
              value: importance,
              items: ["Blue Pill", "Medium", "High", "Red pill"].map((importanceValue) {
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
            Divider(thickness: 4,
              color: Colors.blueGrey[700],
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
                }).toList().cast<Widget>() + [ElevatedButton(
                    onPressed: () {
                      createNewTagWindow(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.add,),
                        Text("Add a new tag",),
                      ],
                    ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey[700]),
                  ),
                    )
                ]
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (validTextInput()) {
            Set selectedTags = new Set();
            for (String key in tagCheckValues.keys) {
              if (tagCheckValues[key] == true) {
                selectedTags.add(key);
              }
            }
            Writing newWriting = new Writing(
                titleInputController.text, descriptionInputController.text,
                textInputController.text, DateTime.now(), importance,
                selectedTags);
            Navigator.pop(context, newWriting);
          }
          else{
            createNewInputAlertWindow(context);
          }
        },
        child: Icon(Icons.double_arrow_sharp),
      ),
    );
  }

  bool validTextInput(){
    if(titleInputController.text.length != 0 && descriptionInputController.text.length != 0 && textInputController.text.length != 0){
      return true;
    }
    return false;
  }
}
