import 'dart:collection';

import 'package:Pilled/StateWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "Writing.dart";
import "homeScreen.dart";
import 'appBarTitle.dart';


class writingScreen extends StatefulWidget {
  @override
  _writingScreenState createState() => _writingScreenState();
}

class _writingScreenState extends State<writingScreen> with TickerProviderStateMixin {

  static const String redPillString = "Red Pill";
  static const String whitePillString = "White Pill";
  static const String blackPillString = "Black Pill";
  static const String bluePillString = "Blue Pill";

  List<Writing> writingsToDisplay = [];

  final _animatedListKey = GlobalKey<AnimatedListState>();

  AnimationController _repeatingAnimationController;
  Animation _breathingAnimation;
  Animation _redpillColourShift;

  Map tagCheckValues = new Map();


  @override
  void initState(){
    super.initState();

    _repeatingAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _breathingAnimation = Tween(begin: 0.0, end: 4.0).animate(_repeatingAnimationController);
    _redpillColourShift = ColorTween(begin: Colors.orange[600], end: Color.fromARGB(150, 255, 33, 38)).animate(_repeatingAnimationController);

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
    final provider = StateInheritedWidget.of(context);
    Map writingsMap = ModalRoute.of(context).settings.arguments;
    writingsToDisplay = writingsMap["WritingsToDisplay"];
    String selectedTag = writingsMap["currentTag"] ?? "";
    String selectedImportance = writingsMap["currentImportance"];
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle("Pills"),
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
          for(String tag in provider.state.tags){
            if(tag == selectedTag) tagCheckValues[tag] = true;
            else tagCheckValues[tag] = false;
          }
          Navigator.pushNamed(context, "/writingCreation", arguments: {"tagCheckValues" : tagCheckValues, "editingWriting" : false, "currentImportance" : selectedImportance}).then((newWriting) => setState((){
            if(newWriting != null) {
              writingsToDisplay.add(newWriting);
              provider.addWriting(newWriting);
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
    final provider = StateInheritedWidget.of(context);
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
           provider.removeWriting(writing);
        });
      },
    );
  }


  Widget decideContainer(Writing writing){
    switch(writing.importance){
      case redPillString: {
        return getRedPillContainer(writing);
      } break;
      case whitePillString: {
        return getWhitePillContainer(writing);
      } break;
      case blackPillString: {
        return getBlackPillContainer(writing);
      } break;
      case bluePillString: {
        return getBluePillContainer(writing);
      } break;
    }
  }

  Widget getWidgetTile(Writing writing, Color color){
    final provider = StateInheritedWidget.of(context);
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
            for(String tag in provider.state.tags){
              if(writing.tags.contains(tag)) {
                tagCheckValues[tag] = true;
              }
              else{
                tagCheckValues[tag] = false;
              }
            }
            Navigator.pushNamed(context, "/writingCreation", arguments: {"editingWriting" : true, "writingToEdit" : writing, "tagCheckValues" : tagCheckValues}).then((editedWriting) {
              setState(() {
                if(editedWriting != null) {
                  int oldWritingIndexInWritingsToDisplay = writingsToDisplay.indexOf(writing);
                  writingsToDisplay[oldWritingIndexInWritingsToDisplay] = editedWriting;
                  provider.editWriting(writing, editedWriting);
                }
              });
            });
          },
        ),
        tileColor: color,
    );
  }

  Widget getRedPillContainer(Writing writing){
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (BuildContext context, _) {
        return Container(
          margin: EdgeInsets.all(8),
          child: getWidgetTile(writing, _redpillColourShift.value),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.orange[600],
                blurRadius: _breathingAnimation.value * 2,
                spreadRadius: _breathingAnimation.value * 2,
              )]
          ),
        );
      },
    );
  }

  Widget getWhitePillContainer(Writing writing){
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (BuildContext context, _){
        return Container(
          margin: EdgeInsets.all(8),
          child: getWidgetTile(writing, Colors.white),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Colors.white54,
                blurRadius: _breathingAnimation.value * 1.5,
                spreadRadius: _breathingAnimation.value * 1.5,
              )]
          ),
        );
      }
    );
  }

  Widget getBlackPillContainer(Writing writing){
    return Container(
      margin: EdgeInsets.all(8),
      child: getWidgetTile(writing, Colors.grey[700])
    );
  }

  Widget getBluePillContainer(Writing writing){
    return Container(
      margin: EdgeInsets.all(8),
      child: getWidgetTile(writing,  Color.fromARGB(255, 47, 38, 173))
    );
  }


}