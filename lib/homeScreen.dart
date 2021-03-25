
import 'package:flutter/material.dart';
import 'package:writings/Writing.dart';

const String highestImportance = "Red pill";
const String highImportance = "High";
const String mediumImportance = "Medium";
const String lowImportance = "Normal";
const List folderImportanceAttributes = [[highestImportance, Colors.red], [highImportance, Colors.purple], [mediumImportance, Colors.blue], [lowImportance, Colors.grey]];

List<Writing> writings = [Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), highImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Yeah", DateTime.now(), highestImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), lowImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), mediumImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), highImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), highestImportance, ["default tag"]),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), highImportance, ["default tag"])];

class homeScreen extends StatelessWidget {



  Map writingImportanceMap = sortWritingsByImportance();

  @override
  Widget build(BuildContext context) {
    List<Widget> importanceFolders = getImportanceFolders(writingImportanceMap, context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home screen"),
      ),
      body: Column(
        children: [
          getFolderWidget(importanceFolders),
          Divider(thickness: 3, height: 10,)
        ],
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

Widget getFolderWidget(List<Widget> folderCards){
  List<Widget> folderRows = [];
  for(int i = 0; i < folderCards.length; i += 2){
    folderRows.add(
      Row(
        children: [
          folderCards[i],
          SizedBox(width: 10,),
          folderCards.length - i > 1 ? folderCards[i+1]:SizedBox(),
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
        print(importanceAttributes[0]);
        print(writingImportanceMap[importanceAttributes[0]]);
        print("AFTER THE PRINT");
        Navigator.pushNamed(context, "/writingScreen", arguments: writingImportanceMap[importanceAttributes[0]]);
      },
    );
  }).toList();
  return importanceFolderCards;
}

Widget getFolderCard(String title, Color color){
  return Card(
    color: color,
    child: Text(title,
    style: TextStyle(
      fontSize: 24,
    )),
  );

}

