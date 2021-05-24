
import 'dart:collection';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:writings/Writing.dart';
import 'appBarTitle.dart';
import 'package:path_provider/path_provider.dart';
const String highestImportance = "Red pill";
const String highImportance = "High";
const String mediumImportance = "Medium";
const String lowImportance = "Normal";
const List folderImportanceAttributes = [[highestImportance, Colors.red], [highImportance, Color.fromARGB(255, 236, 239, 241)], [mediumImportance, Color.fromARGB(255, 207, 216, 220)], [lowImportance, Color.fromARGB(255, 176, 190, 197)]];

String sampleTitle = "Lorem Ipsum";
String sampleDescription = "Lorem Ipsum reflection & meditations";
String sampleText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
Set sampleTags;


List<Writing> writings = [];


class homeScreen extends StatefulWidget {


  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> with WidgetsBindingObserver{
  AppLifecycleState _lastLifecycleState;

  HashSet tags = new HashSet<String>();

  Map writingImportanceMap;
  Map writingTagMap;

  List<Widget> importanceFolders;
  List<Widget> tagFolders;

  File writingsFile;
  Directory currentDirectory;
  String fileName = "writings";
  bool fileExists;


  File createFile(List<Writing> newWritings){
    writingsFile.createSync();
    fileExists = true;
    writeToFile(newWritings);
  }

  void writeToFile(List<Writing> newWritings){
    if(fileExists){
      print(newWritings);
      writingsFile.writeAsStringSync(json.encode(newWritings));
    }
    else createFile(newWritings);
  }

  void update(){
    writingImportanceMap = sortWritingsByImportance();
    writingTagMap = sortWritingsByTag(tags.toList());
    importanceFolders = getImportanceFolders(writingImportanceMap, context);
    tagFolders = getTagFolders(writingTagMap, context, tags);
  }

  @override
  void initState(){
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      currentDirectory = directory;
      writingsFile = new File(currentDirectory.path + "/" + fileName);
      print("Directory: " + writingsFile.path);
      fileExists = writingsFile.existsSync();
      if(fileExists) setState(() {
        print("FILE EXISTS");
        List<dynamic> decodedJSON = json.decode(writingsFile.readAsStringSync());
        for(dynamic item in decodedJSON){
          writings.add(Writing.fromJson(item));
        }
        updateTags();
        print(tags);
        print(writings);
      });
    });


    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    setState(() {
      _lastLifecycleState = state;
      print(_lastLifecycleState);
      if(_lastLifecycleState == AppLifecycleState.inactive){
        print("WRiting to FILE!!!");
        writeToFile(writings);
      }
    });
  }


  void displayWritings(List writingsToDisplay){
    Navigator.pushNamed(context, "/writingScreen", arguments: {
      "WritingsToDisplay": writingsToDisplay,
      "Writings": writings,
      "tags": tags
    }).then((value) {
      setState(() {
        update();
      });
    });
  }

  List<Widget> getTagFolders(Map writingTagMap, BuildContext context, HashSet tags){
    List<Widget> tagFolderCards = tags.map((tag) {
      return GestureDetector(
        child: getFolderCard(tag, Colors.blueGrey[300]),
        onTap: (){
          displayWritings(writingTagMap[tag]);
        },
        onLongPress: () {
          setState(() {
            tags.remove(tag);
            removeTagWritings(tag);
          });

        },
      );
    }).toList();
    return tagFolderCards;
  }

  void removeTagWritings(String tag){
    for(Writing writing in List.unmodifiable(writings)){
      if(writing.tags.contains(tag)){
        writings.remove(writing);
      }
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

  List<Widget> getImportanceFolders(Map writingImportanceMap, BuildContext context){
    List<Widget> importanceFolderCards = folderImportanceAttributes.map((importanceAttributes) {
      return GestureDetector(
        child: getFolderCard(importanceAttributes[0], importanceAttributes[1]),
        onTap: () {
          displayWritings(writingImportanceMap[importanceAttributes[0]]);
        },
      );
    }).toList();
    return importanceFolderCards;
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

  void updateTags(){
    for(Writing writing in writings){
      for(String tag in writing.tags){
        if(!tags.contains(tag)){
          tags.add(tag);
        }
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    update();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: AppBarTitle("Folders")),
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
              child: ElevatedButton.icon(
                  onPressed: () {
                    displayWritings(writings);
                  },
                  icon: Icon(Icons.format_align_left, color: Colors.black,),
                  label: Text("All", style: TextStyle(color: Colors.black),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey[300]),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}















