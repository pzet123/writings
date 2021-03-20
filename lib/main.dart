
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:writings/Writing.dart';
import 'package:writings/writingCreation.dart';
import 'package:writings/writingViewing.dart';


void main() => runApp(new MaterialApp(
  initialRoute: "/home",
  routes: {"/home": (context) => homeScreen(),
          "/writingCreation" : (context) => writingCreationScreen(),
          "/writingViewing" : (context) => writingViewing(),
  },
));

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> with SingleTickerProviderStateMixin {

  List<Writing> writings = [Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "important"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "redpill"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "medium"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "medium"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "medium"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "medium"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "normal"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "medium"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "medium"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "medium"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "important"),
    Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "redpill"),
  Writing("Beaver mentality", "A reflection on the mindset of the beaver", "The beaver is a hard worker, determined to build their dam.", DateTime.now(), "important")];

  AnimationController _breathingAnimationController;
  Animation _breathingAnimation;

  static const String highestImportance = "redpill";
  static const String highImportance = "important";
  static const String mediumImportance = "medium";
  static const String lowImportance = "normal";

  @override
  void initState(){
    _breathingAnimationController = AnimationController(vsync:this, duration: Duration(seconds: 1));
    _breathingAnimationController.repeat(reverse: true);
    _breathingAnimation = Tween(begin: 0.2, end: 5.0).animate(_breathingAnimationController)..addListener(() {
      setState(() {

      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Writings"),
          backgroundColor: Colors.blueGrey[700],
          centerTitle: true,
        ),
        body: Container(
          color: Colors.blueGrey[900],
          child: Scrollbar(
            child: ListView(
              children: getWritingsWidgets(writings),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "writingCreation");
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


  Container decideContainer(Writing writing){
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

  Container getHighestImportanceContainer(Writing writing){
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
        color: Color.fromARGB(200, 200, 33, 4)
      ),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Colors.orange[600],
            // Color.fromARGB(255, 239, 126, 22),
            blurRadius: _breathingAnimation.value,
            spreadRadius: _breathingAnimation.value,
          )]
      ),
    );
  }

  Container getHighImportanceContainer(Writing writing){
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
          color: Colors.green
      ),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Color.fromARGB(50, 200, 0, 214),
            blurRadius: _breathingAnimation.value,
            spreadRadius: _breathingAnimation.value,
          )]
      ),
    );
  }

  Container getMediumImportanceContainer(Writing writing){
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

  Container getLowImportanceContainer(Writing writing){
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

