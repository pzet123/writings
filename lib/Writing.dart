
import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

class Writing{
  String _title;
  String _description;
  String _text;
  DateTime _dateOfWriting;
  String _importance;
  Set _tags;

  Writing(String title, String description, String text, DateTime dateOfWriting, String importance, Set tags){
    this._title = title;
    this._description = description;
    this._text = text;
    this._dateOfWriting = dateOfWriting;
    this._importance = importance;
    this._tags = tags;
  }

  String getTagsString(){
    String tagsString = "";
    for(String tag in tags){
      tagsString += tag + ", ";
    }
    return tagsString;
  }

  Writing.fromJson(Map<String, dynamic> json) :
    this._title = json["title"],
    this._description = json["description"],
    this._text = debugmeth(json["text"]),
    this._dateOfWriting = DateTime.parse(json["dateOfWriting"]),
    this._importance = json["importance"],
    this._tags = json["tags"].toSet();

  Map<String, dynamic> toJson() => {
    "title" : _title,
    "description" : _description,
    "text" : _text,
    "dateOfWriting" : _dateOfWriting.toIso8601String(),
    "importance" : _importance,
    "tags" : _tags.toList()
  };

  static String debugmeth(text){
    return text;
  }


  String get importance => _importance;

  DateTime get dateOfWriting => _dateOfWriting;

  String get text => _text;

  String get title => _title;

  String get description => _description;

  Set get tags => _tags;
}