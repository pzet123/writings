import 'package:flutter/material.dart';
import 'package:writings/appBarTitle.dart';
import 'helpEntry.dart';

class helpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle("Guide"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[600],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.2, 0.4, 0.6, 0.8],
            colors: [Colors.blueGrey[400], Colors.blueGrey[300], Colors.blueGrey[200], Colors.blueGrey[100]],
          )
        ),
        child: ListView(
          children: [
            HelpEntry("Adding Writings", ["In order to add a writing, select any of the folders from the home screen and tap the button with the plus sign in the bottom right",
                "Once the writing creation has appeared, fill out the relevant information and click to button with the arrow in the bottom right in order to finalise the writing"], Icons.add_circle),
            SizedBox(height: 10,),
            HelpEntry("Deleting Writings", ["Navigate to the writing", "Hold it down until it fades away"], Icons.delete_rounded),
          ],
        ),
      ),

    );
  }
}
