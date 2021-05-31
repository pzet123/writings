import 'package:flutter/material.dart';

class helpEntryScreen extends StatelessWidget {
  @override
  String title;
  List<String> steps;

  Widget build(BuildContext context) {
    Map helpInformationMap = ModalRoute.of(context).settings.arguments;
    title = helpInformationMap["title"];
    steps = helpInformationMap["steps"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[600],
        title: Text(this.title),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView(
          children: this.steps.map((step) {
            return Column(
              children: [
                Text(step,
                    style: TextStyle(
                      fontSize: 20,
                      wordSpacing: 1.2,
                      color: Colors.grey[850]
                    ),
                ),
                SizedBox(height: 10,)
              ],
            );
          }).toList(),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.5, 1],
            colors: [Colors.blueGrey[300], Colors.blueGrey[100]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
      ),
    );
  }
}
