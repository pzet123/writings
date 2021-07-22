import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "Writing.dart";
import 'StateWidget.dart';
class writingViewing extends StatefulWidget {
  @override
  _writingViewingState createState() => _writingViewingState();
}
class _writingViewingState extends State<writingViewing> {
  @override
  Widget build(BuildContext context) {
    double fontSize = StateInheritedWidget.of(context).state.fontSize * 0.75;
    Writing writing = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(writing.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.grey[100],
        ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
      ),
      body: Container(
        color: Colors.blueGrey[200],
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ListView(
                  children: [
                    SizedBox(height: 8,),
                    Text(writing.description,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 18
                        )),
                    Divider(thickness: 4,
                      height: 12,
                      color: Colors.blueGrey[700],
                    ),
                    Text(
                    writing.text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ]
                ),
              ),
            ),
            Divider(thickness: 3, height: 5,),
            Container(
              color: Colors.blueGrey,
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _writingMetaDataWidget("Importance: " + writing.importance, fontSize),
                  _writingMetaDataWidget("Tags: " + ((writing.tags.length > 0) ? writing.getTagsString(): "None"), fontSize),
                  _writingMetaDataWidget(writing.dateOfWriting.toString().substring(0, 16), fontSize)
                ],
              ),
            ),
          ],
        ),
      )
    );
  }



}

class _writingMetaDataWidget extends StatelessWidget{
  final String text;
  final double fontSize;

  const _writingMetaDataWidget(this.text, this.fontSize);

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Center(child:
        Text(this.text,
          style: TextStyle(fontSize: fontSize),)),
        Divider(thickness: 2, color: Colors.white,),
      ],
    );
  }

}