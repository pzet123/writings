import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:writings/Writing.dart';
import 'package:writings/homeScreen.dart';
import 'appBarTitle.dart';


class writingScreen extends StatefulWidget {
  @override
  _writingScreenState createState() => _writingScreenState();
}

class _writingScreenState extends State<writingScreen> with TickerProviderStateMixin {

  static const String highestImportance = "Red pill";
  static const String highImportance = "High";
  static const String mediumImportance = "Medium";
  static const String lowImportance = "Blue Pill";

  List<Writing> writingsToDisplay = [];

  final _animatedListKey = GlobalKey<AnimatedListState>();

  AnimationController _repeatingAnimationController;
  Animation _breathingAnimation;
  Animation _redpillColourShift;
  
  HashSet tags;
  Map tagCheckValues = new Map();




  @override
  void initState(){
    super.initState();

    _repeatingAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _breathingAnimation = Tween(begin: 0.0, end: 4.0).animate(_repeatingAnimationController);
    _redpillColourShift = ColorTween(begin: Colors.orange[600], end: Color.fromARGB(100, 255, 33, 38)).animate(_repeatingAnimationController);

    _repeatingAnimationController.forward();

    _repeatingAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        _repeatingAnimationController.reverse();
      } else if(status == AnimationStatus.dismissed) {
        _repeatingAnimationController.forward();
      }
    });


    }




  @override
  void dispose(){
    _repeatingAnimationController.dispose();
    super.dispose();


  }



  @override
  Widget build(BuildContext context) {
    Map writingsMap = ModalRoute.of(context).settings.arguments;
    writingsToDisplay = writingsMap["WritingsToDisplay"];
    List<Writing> writings = writingsMap["Writings"];
    tags = writingsMap["tags"];
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle("Writings"),
        backgroundColor: Colors.blueGrey[700],
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child: AnimatedList(
          key: _animatedListKey,
          initialItemCount: writingsToDisplay.length,
          itemBuilder: (context, index, animation) {
            return getWritingsWidgets(writingsToDisplay)[index];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for(String tag in tags){
            tagCheckValues[tag] = false;
          }
          Navigator.pushNamed(context, "/writingCreation", arguments: {"tags" : tags, "tagCheckValues" : tagCheckValues, "editingWriting" : false}).then((newWriting) => setState((){
            if(newWriting != null) {
              writingsToDisplay.add(newWriting);
              writings.add(newWriting);
              _animatedListKey.currentState.insertItem(writingsToDisplay.length - 1);
            }
          }));
        },
        backgroundColor: Colors.blueGrey,
        child:
        Icon(
          Icons.add_circle,
          color: Colors.blueGrey[900],
          size: 50,
        ),
      ),
    );
  }

  List<Widget> getWritingsWidgets(List<Writing> writings){
    List<Widget> writingWidgets = [];
    for(Writing writing in writings){
      writingWidgets.add(generateWritingWidget(writing, writings));
    }
    return writingWidgets;
  }

  Widget generateWritingWidget(Writing writing, List<Writing> writingsToDisplay){
    return GestureDetector(
      child: decideContainer(writing),
      onTap: () {
        Navigator.pushNamed(context, "/writingViewing", arguments: writing);
      },
      onLongPress: () {
        int index = writingsToDisplay.indexOf(writing);
        Widget removedWritingWidget = getWritingsWidgets(writingsToDisplay)[index];
        _animatedListKey.currentState.removeItem(index,
                (context, animation) => FadeTransition(
                  opacity: animation,
                  child: removedWritingWidget,
                    ));
        setState(() {
           writingsToDisplay.remove(writing);
           writings.remove(writing);         
        });
        writingsToDisplay.remove(writing);
        writings.remove(writing);
      },
    );
  }


  Widget decideContainer(Writing writing){
    switch(writing.importance){
      case highestImportance: {
        return getHighestImportanceContainer(writing);
      } break;
      case highImportance: {
        return getHighImportanceContainer(writing);
      } break;
      case mediumImportance: {
        return getMediumImportanceContainer(writing);
      } break;
      case lowImportance: {
        return getLowImportanceContainer(writing);
      } break;
    }
  }

  Widget getWidgetTile(Writing writing, Color color){
    return ListTile(
        title: Text(
          writing.title,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        subtitle: Text(writing.description),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            for(String tag in tags){
              if(writing.tags.contains(tag)) {
                tagCheckValues[tag] = true;
              }
              else{
                tagCheckValues[tag] = false;
              }
            }
            Navigator.pushNamed(context, "/writingCreation", arguments: {"editingWriting" : true, "writingToEdit" : writing, "tags" : tags, "tagCheckValues" : tagCheckValues}).then((editedWriting) {
              setState(() {
                if(editedWriting != null) {
                  int oldWritingIndexInWritingsToDisplay = writingsToDisplay.indexOf(writing);
                  int oldWritingIndexInWritings = writings.indexOf(writing);
                  writings[oldWritingIndexInWritings] = editedWriting;
                  writingsToDisplay[oldWritingIndexInWritingsToDisplay] = editedWriting;
                }
              });
            });
          },
        ),
        tileColor: color,
    );
  }

  Widget getHighestImportanceContainer(Writing writing){
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (BuildContext context, _) {
        return Container(
          margin: EdgeInsets.all(8),
          child: getWidgetTile(writing, _redpillColourShift.value),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.orange[600],
                blurRadius: _breathingAnimation.value*2,
                spreadRadius: _breathingAnimation.value,
              )]
          ),
        );
      },
    );
  }

  Widget getHighImportanceContainer(Writing writing){
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (BuildContext context, _){
        return Container(
          margin: EdgeInsets.all(8),
          child: getWidgetTile(writing, Color.fromARGB(255, 255,223,0)),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Color.fromARGB(100, 255, 212, 0),
                blurRadius: _breathingAnimation.value * 2,
                spreadRadius: _breathingAnimation.value,
              )]
          ),
        );
      }
    );
  }

  Widget getMediumImportanceContainer(Writing writing){
    return Container(
      margin: EdgeInsets.all(8),
      child: getWidgetTile(writing, Colors.indigo[500])
    );
  }

  Widget getLowImportanceContainer(Writing writing){
    return Container(
      margin: EdgeInsets.all(8),
      child: getWidgetTile(writing, Colors.blue[600])
    );
  }


}