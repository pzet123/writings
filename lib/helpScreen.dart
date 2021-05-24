import 'package:flutter/material.dart';
import 'package:writings/appBarTitle.dart';


class helpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle("Guide"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.2, 0.4, 0.6, 0.8],
            colors: [Colors.blueGrey[800], Colors.blueGrey[700], Colors.blueGrey[600], Colors.blueGrey[500]],
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Adding Writings:",
              style: TextStyle(
                  fontSize: 26
                ),
            ),
            SizedBox(height: 4,),
            Text("In order to add a writing, select any of the folders from the home screen and tap the button with the plus sign in the bottom right\n"
                "Once the writing creation has appeared, fill out the relevant information and click to button with the arrow in the bottom right in order to finalise the writing"),
            Divider(thickness: 3, height: 20, color: Colors.white,),
            Text("Deleting Writings:",
              style: TextStyle(
                fontSize: 26
            ),
            ),
            SizedBox(height: 4,),
            Text("In order to delete a writing, navigate to it in one of the folders and hold it until it disappears"),
            //TODO: Change the way new entries to the help section are added by creating a new stateless widget which combiens the title, sized box and the actual help text
          ],
        ),
      ),

    );
  }
}
