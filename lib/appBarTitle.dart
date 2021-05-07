import 'package:flutter/material.dart';


class AppBarTitle extends StatefulWidget {
  String title;
  AppBarTitle(String title){
    this.title = title;
  }
  @override
  _AppBarTitleState createState() => _AppBarTitleState(this.title);


}

class _AppBarTitleState extends State<AppBarTitle> {
  String title;
  _AppBarTitleState(String title){
    this.title = title;
  }
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 700),
        child: Text(this.title),
        builder: (BuildContext context, double val, Widget child){
          return Opacity(
              opacity: val,
              child: child
          );
        });
  }
}
