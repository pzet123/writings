import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HelpScreenEntry extends StatelessWidget {
  String title;
  String description;
  IconData sectionIcon;
  HelpScreenEntry(String title, String description, IconData sectionIcon){
    this.title = title;
    this.description = description;
    this.sectionIcon = sectionIcon;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ListTile(
            title: Text(title),
            leading: Icon(sectionIcon),
          )
        ],
    );
  }
}
