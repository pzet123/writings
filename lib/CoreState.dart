
import 'Writing.dart';
import 'package:flutter/material.dart';

class CoreState{

  final List<Writing> writings;
  final Set tags;
  final double fontSize;


  const CoreState({
    @required this.writings,
    @required this.tags,
    @required this.fontSize
  });

  CoreState copy({List<Writing> newWritings, Set newTags, double newFontSize})
  => CoreState(writings: newWritings ?? this.writings, tags: newTags ?? this.tags, fontSize: newFontSize ?? this.fontSize);

  @override
  bool operator ==(Object other) {
    if (identical(this, other) ||
        (other is CoreState && runtimeType == other.runtimeType &&
            writings == other.writings && tags == other.tags && fontSize == other.fontSize)) return true;
    return false;
  }

}