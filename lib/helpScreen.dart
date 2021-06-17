import 'package:flutter/material.dart';
import "appBarTitle.dart";
import 'helpEntry.dart';

class helpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle("Guide"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.6, 0.8],
              colors: [
                Colors.blueGrey[700],
                Colors.blueGrey[500],
                Colors.blueGrey[400],
                Colors.blueGrey[300]
              ]

          )
        ),
        child: ListView(
          children: [
            HelpEntry("Pill Types", ["The Red Pill is an important truth that isn't commonly known or is opposed by many people",
            "The White Pill is a motivator, it can be an observation that suggests things are going well.", "The Black Pill is the opposite of a white pill meaning its a sign that things are not going well, this "
                  "category is included for the sake of completeness but should contain significantly fewer writings than the other categories."
                  , "The Blue Pill is a category which covers misconceptions/lies that are commonly believed",
            "Do not worry about what type of 'pill' you pick for a writing initially as this can be easily edited in the future"], Icons.warning_rounded),
            HelpEntry("Adding Writings", ["Select any of the folders from the home screen", "Once you are on the folder screen press the plus button in the bottom right corner of the screen",
                "Fill out the relevant information and click the arrow button in the bottom right of the screen in order to create the writing",
              "The new writing will then be stored in the relevant folders"], Icons.add),
            HelpEntry("Deleting Writings", ["Enter the folder which contains the writing", "Optionally, you can simply view all of the writings", "Scroll until you get to the writing that you want to delete",
            "Instead of clicking on the writing, hold it down until it disappears", "Be careful when doing this, there is no way to reverse this"], Icons.delete_rounded),
            HelpEntry("Deleting Tags", ["Navigate to the home screen and scroll through the tags so the tag you want to delete is visible", "Hold the tag tile until a new window pops up",
            "Click yes to confirm that you would like to delete the tag", "Any writings that contain that tag and no other tags will be deleted alongside it"], Icons.delete_forever_rounded),
            HelpEntry("Saving Writings", ["Your writings are saved each time the app is shut down or left running in the background.", "Ensure that you do not shut down your phone while the "
                "app is running as this can lead to any changes to writings not being saved"], Icons.save),
            HelpEntry("Editing Writings", ["Enter the folder which contains the writing", "Optionally, you can simply view all of the writings", "Scroll until you get to the writing that you want to edit",
            "Click on the pencil icon on the right of the writing tile", "Edit the relevant information and press the arrow button in the bottom right to finalise the changes"], Icons.edit)
          ],
        ),
      ),

    );
  }
}
