import 'package:flutter/material.dart';
import 'package:writings/Writing.dart';
import 'appBarTitle.dart';


class writingScreen extends StatefulWidget {
  @override
  _writingScreenState createState() => _writingScreenState();
}

class _writingScreenState extends State<writingScreen> with SingleTickerProviderStateMixin {

  static const String highestImportance = "Red pill";
  static const String highImportance = "High";
  static const String mediumImportance = "Medium";
  static const String lowImportance = "Normal";

  AnimationController _repeatingAnimationController;
  Animation _breathingAnimation;
  Animation _redpillColourShift;




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
    List<Writing> writingsToDisplay = writingsMap["WritingsToDisplay"];
    List<Writing> writings = writingsMap["Writings"];
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle("Writings"),
        backgroundColor: Colors.blueGrey[700],
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child: Scrollbar(
          child: ListView(
            children: getWritingsWidgets(writingsToDisplay),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/writingCreation", arguments: writings);
          writings.add(Writing("Test writing","Test","Test writing ..", DateTime.now(), "Red pill", {"Life events", "Friends"}));
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
      writingWidgets.add(generateWritingWidget(writing));
    }
    return writingWidgets;
  }

  Widget generateWritingWidget(Writing writing){
    return GestureDetector(
      child: decideContainer(writing),
      onTap: () {
        Navigator.pushNamed(context, "/writingViewing", arguments: writing);
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

  Widget getHighestImportanceContainer(Writing writing){
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (BuildContext context, _) {
        return Container(
          margin: EdgeInsets.all(8),
          child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Column(
                  children: [
                    Text(writing.title),
                    Divider(thickness: 4, height: 8,),
                    Text(writing.description),
                  ],
                ),
              ),
              color: _redpillColourShift.value
          ),
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
          child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Column(
                  children: [
                    Text(writing.title),
                    Divider(thickness: 4, height: 8,),
                    Text(writing.description),
                  ],
                ),
              ),
              color: Colors.purple[300]
          ),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                color: Color.fromARGB(100, 200, 0, 214),
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
      child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Column(
              children: [
                Text(writing.title),
                Divider(thickness: 4, height: 8,),
                Text(writing.description),
              ],
            ),
          ),
          color: Colors.indigo[500]
      ),
    );
  }

  Widget getLowImportanceContainer(Writing writing){
    return Container(
      margin: EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            children: [
              Text(writing.title),
              Divider(thickness: 4, height: 8,),
              Text(writing.description),
            ],
          ),
        ),
        color: Colors.grey[600],
      ),
    );
  }


}