
import 'dart:collection';

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

  String get importance => _importance;

  DateTime get dateOfWriting => _dateOfWriting;

  String get text => _text;

  String get title => _title;

  String get description => _description;

  Set get tags => _tags;




}