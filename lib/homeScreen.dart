
import 'dart:collection';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import "Writing.dart";
import 'appBarTitle.dart';
import 'package:path_provider/path_provider.dart';
import 'StateWidget.dart';


const String redPillString = "Red pill";
const String whitePillString = "White Pill";
const String blackPillString = "Black Pill";
const String bluePillString = "Blue Pill";
const List folderImportanceAttributes = [[redPillString, Colors.red], [whitePillString, Colors.white],
  [blackPillString, Color.fromARGB(255, 70, 70, 70)], [bluePillString, Color.fromARGB(255, 47, 38, 173)]];



class homeScreen extends StatefulWidget {


  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> with WidgetsBindingObserver{
  AppLifecycleState _lastLifecycleState;


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

  double fontSize;



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

  void setFontSize() {
    final provider = StateInheritedWidget.of(context);
    double screenWidth = MediaQuery.of(context).size.height;
    provider.setFontSize(screenWidth * 0.033);

  }

  @override
  void initState(){
    super.initState();
    Future(() => setFontSize());

    getApplicationDocumentsDirectory().then((Directory directory) {
      final provider = StateInheritedWidget.of(context);


      hostFileDirectory = directory;
      writingsFile = new File(hostFileDirectory.path + "/" + writingsFileName);
      tagsFile = new File(hostFileDirectory.path + "/" + tagsFileName);
      writingsFileExists = writingsFile.existsSync();
      tagsFileExists = tagsFile.existsSync();
      if(writingsFileExists) setState(() {
        List<dynamic> decodedJSON = json.decode(writingsFile.readAsStringSync());
        for(dynamic item in decodedJSON){
          provider.addWriting(Writing.fromJson(item));
        }
      });
      if(tagsFileExists) setState(() {
        List<dynamic> decodedJSON = json.decode(tagsFile.readAsStringSync());
        for(dynamic item in decodedJSON){
          provider.addTag(item);
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
    final provider = StateInheritedWidget.of(context);
    final writings = provider.state.writings;
    final tags = provider.state.tags;
    setState(() {
      _lastLifecycleState = state;
      if(_lastLifecycleState == AppLifecycleState.inactive){
        writeToFile(json.encode(writings), writingsFile, writingsFileExists);
        writeToFile(json.encode(tags.toList()), tagsFile, tagsFileExists);
      }
    });
  }


  void displayWritings(List writingsToDisplay, {String importance, String tag}){
    Navigator.pushNamed(context, "/writingScreen", arguments: {
      "WritingsToDisplay": writingsToDisplay,
      "currentTag" : tag,
      "currentImportance" : importance
    }).then((value) {
      setState(() {
        update();
      });
    });
  }

  List<Widget> getTagFolders(Map writingTagMap, BuildContext context, Set tags){
    List<Widget> tagFolderCards = tags.map((tag) {
      return GestureDetector(
        child: getFolderCard(tag, Colors.blueGrey[300]),
        onTap: (){
          displayWritings(writingTagMap[tag], tag: tag);
        },
        onLongPress: () {
          showConfirmationWindow(context, tag);
        },
      );
    }).toList();
    return tagFolderCards;
  }

  void showConfirmationWindow(BuildContext, String tag){
    showDialog(context: context, builder: (context) {
      final provider = StateInheritedWidget.of(context);
      return AlertDialog(
        title: Text("Are you sure you want to delete this tag?"),
        content: Row(
          children: [
            ElevatedButton(onPressed: () {
              setState(() {
                provider.removeTag(tag);
                removeTagWritings(tag);
                Navigator.pop(context);
              });
            }, child: Text("Yes"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey[700]),
              ),
            ),
            Spacer(),
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("No"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey[700]),
              ),
            )
          ],
        ),
      );
    });
  }
  void removeTagWritings(String tag){
    final provider = StateInheritedWidget.of(context);
    final writings = provider.state.writings;
    for(Writing writing in List.unmodifiable(writings)){
      if(writing.tags.contains(tag)){
        writing.tags.remove(tag);
        if(writing.tags.length == 0) {
          setState(() {
            provider.removeWriting(writing);
            update();
          });
        }
      }
    }
  }

  Map sortWritingsByImportance(){
    final provider = StateInheritedWidget.of(context);
    final writings = provider.state.writings;
    Map writingMap = new Map();
    List<Writing> redPillWritings = [];
    List<Writing> highImportanceWritings = [];
    List<Writing> mediumImportanceWritings = [];
    List<Writing> lowImportanceWritings = [];
    for(Writing writing in writings){
      switch(writing.importance){
        case redPillString: {
          redPillWritings.add(writing);
        } break;
        case whitePillString: {
          highImportanceWritings.add(writing);
        } break;
        case blackPillString: {
          mediumImportanceWritings.add(writing);
        } break;
        case bluePillString: {
          lowImportanceWritings.add(writing);
        } break;
      }
    }
    writingMap = {
      redPillString : redPillWritings,
      whitePillString : highImportanceWritings,
      blackPillString : mediumImportanceWritings,
      bluePillString : lowImportanceWritings,
    };
    return writingMap;
  }


  Map sortWritingsByTag(List<String> tags){
    final provider = StateInheritedWidget.of(context);
    final writings = provider.state.writings;
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
      String importanceName = importanceAttributes[0];
      Color importanceColor = importanceAttributes[1];
      return GestureDetector(
        child: getFolderCard(importanceName, importanceColor),
        onTap: () {
          displayWritings(writingImportanceMap[importanceName], importance: importanceName);
        },
      );
    }).toList();
    return importanceFolderCards;
  }

  Widget getFolderCard(String title, Color color){
    return Card(
      color: color,
      child: Padding(
        padding: EdgeInsets.all(fontSize),
        child: Center(
          child: Text(title,
              style: TextStyle(
                fontSize: fontSize,
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
    final provider = StateInheritedWidget.of(context);
    Set tags = provider.state.tags;
    importanceFolders = getImportanceFolders(writingImportanceMap, context);
    writingImportanceMap = sortWritingsByImportance();
    writingTagMap = sortWritingsByTag(new List<String>.from(tags));
    tagFolders = getTagFolders(writingTagMap, context, tags);
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = StateInheritedWidget.of(context);
    final writings = provider.state.writings;

    double screenWidth = MediaQuery.of(context).size.height;
    fontSize = screenWidth * 0.033;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

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
              flex: 7,
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
