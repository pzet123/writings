import 'package:flutter/material.dart';
import 'package:writings/appBarTitle.dart';
import 'helpScreenEntry.dart';

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
            end: Alignment.bottomRight, //TODO: ADD ICONS TO THE HELP SECTION AND SPLIT UP EACH HELP ENTRY INTO A NEW SCREEN
            stops: [0.2, 0.4, 0.6, 0.8],
            colors: [Colors.blueGrey[500], Colors.blueGrey[400], Colors.blueGrey[300], Colors.blueGrey[200]],
          )
        ),
        child: ListView(
          children: [
            HelpScreenEntry("Adding Writings:", "In order to add a writing, select any of the folders from the home screen and tap the button with the plus sign in the bottom right\n\n"
                "Once the writing creation has appeared, fill out the relevant information and click to button with the arrow in the bottom right in order to finalise the writing", Icons.add_circle),
            SizedBox(height: 10,),
            HelpScreenEntry("Deleting Writings:", "In order to delete a writing, navigate to it in one of the folders and hold it until it disappears", Icons.delete_rounded),
          ],
        ),
      ),

    );
  }
}
