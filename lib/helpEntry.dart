import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HelpEntry extends StatelessWidget {
  String title;
  List<String> steps;
  IconData sectionIcon;
  HelpEntry(String title, List<String> steps, IconData sectionIcon){
    this.title = title;
    this.steps = steps;
    this.sectionIcon = sectionIcon;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          GestureDetector(
            child: ListTile(

              title: Text(title,
                  style: TextStyle(
                    fontSize: 22
                  ),
              ),
              leading: Icon(sectionIcon,
              size: 30,),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            onTap: () {
              Navigator.pushNamed(context, "/helpEntryScreen", arguments: {"title" : title, "steps" : steps});
            },
          )
        ],
    );
  }
}
