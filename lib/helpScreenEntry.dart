import 'package:flutter/material.dart';

class HelpScreenEntry extends StatelessWidget {
  String title;
  String description;
  HelpScreenEntry(String title, String description){
    this.title = title;
    this.description = description;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8,),
        Text(this.title,
        style: TextStyle(
          fontSize: 24,
          ),
        ),
        SizedBox(height: 5,),
        Text(this.description,
        style: TextStyle(
          fontSize: 20,
          ),
        ),
        Divider(height: 15, thickness: 4, color: Colors.white,)
      ],
    );
  }
}
