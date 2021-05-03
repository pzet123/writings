
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:writings/Writing.dart';
import 'appBarTitle.dart';
const String highestImportance = "Red pill";
const String highImportance = "High";
const String mediumImportance = "Medium";
const String lowImportance = "Normal";
const List folderImportanceAttributes = [[highestImportance, Colors.red], [highImportance, Color.fromARGB(255, 236, 239, 241)], [mediumImportance, Color.fromARGB(255, 207, 216, 220)], [lowImportance, Color.fromARGB(255, 176, 190, 197)]];

List<Writing> writings = [Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), highImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Yeah", DateTime.now(), highestImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, {"default tag", "Willpower"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), lowImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), highImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), highestImportance, {"default tag"}),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), highImportance, {"default tag"})];



class homeScreen extends StatefulWidget {


  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  HashSet tags;

  Map writingImportanceMap;
  Map writingTagMap;

  List<Widget> importanceFolders;
  List<Widget> tagFolders;

  void update(){
    tags = getTags();
    writingImportanceMap = sortWritingsByImportance();
    writingTagMap = sortWritingsByTag(tags.toList());
    importanceFolders = getImportanceFolders(writingImportanceMap, context);
    tagFolders = getTagFolders(writingTagMap, context, tags);
  }

  @override
  Widget build(BuildContext context) {
    print("Build called");
    update();
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle("home screen"),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
                child: getFolderWidget(importanceFolders)),
            Divider(thickness: 3, height: 10, color: Colors.white,),
            Expanded(
              flex: 11,
              child: ListView(
                children: [
                  getFolderWidget(tagFolders)
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: RaisedButton.icon(
                  onPressed: () {
                    setState(() {
                      update();
                    });
                    Navigator.pushNamed(context, "/writingScreen", arguments: {"WritingsToDisplay":writings, "Writings":writings});
                    },
                  icon: Icon(Icons.format_align_left),
                  label: Text("All"),
              color: Colors.blueGrey[300],)
            )

          ],
        ),
      ),
    );
  }
}


Map sortWritingsByImportance(){
  Map writingMap = new Map();
  List<Writing> redPillWritings = [];
  List<Writing> highImportanceWritings = [];
  List<Writing> mediumImportanceWritings = [];
  List<Writing> lowImportanceWritings = [];
  for(Writing writing in writings){
    switch(writing.importance){
      case highestImportance: {
        redPillWritings.add(writing);
      } break;
      case highImportance: {
        highImportanceWritings.add(writing);
      } break;
      case mediumImportance: {
        mediumImportanceWritings.add(writing);
      } break;
      case lowImportance: {
        lowImportanceWritings.add(writing);
      } break;
    }
  }
  writingMap = {
    highestImportance : redPillWritings,
    highImportance : highImportanceWritings,
    mediumImportance : mediumImportanceWritings,
    lowImportance : lowImportanceWritings,
  };
  return writingMap;
}

Map sortWritingsByTag(List<String> tags){
  Map writingMap = new Map();
  List<Writing> writingTemp = writings;
  for(String tag in tags.toList()){
    List<Writing> writingTagList = new List();
    for(Writing writing in writingTemp){
      if(writing.tags.contains(tag)) {
        writingTagList.add(writing);
      }
    }
    writingMap[tag] = writingTagList;

  }
  return writingMap;
}

HashSet<String> getTags(){
  HashSet<String> tags = new HashSet();
  tags.add("Legacy");
  tags.add("Willpower");
  tags.add("Friends");
  tags.add("Life events");
  tags.add("default tag");
  return tags;
}

Widget getFolderWidget(List<Widget> folderCards){
  List<Widget> folderRows = [];
  for(int i = 0; i < folderCards.length; i += 2){
    folderRows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: folderCards[i]),
          SizedBox(width: folderCards.length - i > 1 ? 10:0,),
          folderCards.length - i > 1 ? Expanded(flex: 1, child: folderCards[i+1]):SizedBox(width: 0,),
        ],
      )
    );
  }
  return Column(
    children: folderRows
  );

}

List<Widget> getImportanceFolders(Map writingImportanceMap, BuildContext context){
  List<Widget> importanceFolderCards = folderImportanceAttributes.map((importanceAttributes) {
    return GestureDetector(
      child: getFolderCard(importanceAttributes[0], importanceAttributes[1]),
      onTap: () {
        Navigator.pushNamed(context, "/writingScreen", arguments: {"WritingsToDisplay":writingImportanceMap[importanceAttributes[0]], "Writings":writings});
      },
    );
  }).toList();
  return importanceFolderCards;
}

List<Widget> getTagFolders(Map writingTagMap, BuildContext context, HashSet tags){
  List<Widget> tagFolderCards = tags.map((tag) {
    return GestureDetector(
      child: getFolderCard(tag, Colors.blueGrey[300]),
      onTap: (){
        Navigator.pushNamed(context, "/writingScreen", arguments: {"WritingsToDisplay":writingTagMap[tag], "Writings":writings});
      },
    );
  }).toList();
  return tagFolderCards;
}

Widget getFolderCard(String title, Color color){
  return Card(
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(title,
        style: TextStyle(
          fontSize: 24,
        )),
      ),
    ),
  );

}

