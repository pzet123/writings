
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
const String lowImportance = "Blue Pill";
const List folderImportanceAttributes = [[highestImportance, Colors.red], [highImportance, Color.fromARGB(255, 255,223,0)],
  [mediumImportance, Color.fromARGB(255, 240, 240, 240)], [lowImportance, Colors.blue]];



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


  Directory hostFileDirectory;

  File writingsFile;
  String writingsFileName = "writings";
  bool writingsFileExists;

  File tagsFile;
  String tagsFileName = "tags";
  bool tagsFileExists;


  File createFile(String jsonString, File file, bool fileExists){
    file.createSync();
    fileExists = true;
    writeToFile(jsonString, file, fileExists);
  }

  void writeToFile(String jsonString, File file, bool fileExists){
    if(fileExists){
      file.writeAsStringSync(jsonString);
    }
    else createFile(jsonString, file, fileExists);
  }
  

  @override
  void initState(){
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      hostFileDirectory = directory;
      writingsFile = new File(hostFileDirectory.path + "/" + writingsFileName);
      tagsFile = new File(hostFileDirectory.path + "/" + tagsFileName);
      writingsFileExists = writingsFile.existsSync();
      tagsFileExists = tagsFile.existsSync();
      if(writingsFileExists) setState(() {
        List<dynamic> decodedJSON = json.decode(writingsFile.readAsStringSync());
        for(dynamic item in decodedJSON){
          writings.add(Writing.fromJson(item));
        }
        //updateTags();
      });
      if(tagsFileExists) setState(() {
        List<dynamic> decodedJSON = json.decode(tagsFile.readAsStringSync());
        for(dynamic item in decodedJSON){
          tags.add(item);
        }
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
      if(_lastLifecycleState == AppLifecycleState.inactive){
        writeToFile(json.encode(writings), writingsFile, writingsFileExists);
        writeToFile(json.encode(tags.toList()), tagsFile, tagsFileExists);
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
      List<Writing> writingTagList = [];
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


  void update(){
    importanceFolders = getImportanceFolders(writingImportanceMap, context);
    writingImportanceMap = sortWritingsByImportance();
    writingTagMap = sortWritingsByTag(tags.toList());
    tagFolders = getTagFolders(writingTagMap, context, tags);
  }
  
  @override
  Widget build(BuildContext context) {
    update();
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle("Folders"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        actions: [
          IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                Navigator.pushNamed(context, "/helpScreen");
              })
                ],
                ),
                body: Container(
                decoration: BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.5, 0.7, 0.95],
                colors: [
                Colors.blueGrey[700],
                Colors.blueGrey[500],
                Colors.blueGrey[400],
                Colors.blueGrey[300]
                ]

                )
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8,),
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
                    displayWritings(List.from(writings).cast<Writing>());
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















