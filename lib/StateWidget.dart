import 'package:Pilled/CoreState.dart';
import "package:flutter/material.dart";
import 'Writing.dart';

class StateWidget extends StatefulWidget{
  final Widget child;

  const StateWidget({Key key, @required this.child}) : super(key: key);

  @override
  _StateWidgetState createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  CoreState state = CoreState(writings: [], tags: {}, fontSize: 12);

  void addWriting(Writing writing){
    final newWritings = state.writings + [writing];
    final newState = state.copy(newWritings: newWritings);

    setState(() {
      state = newState;
    });
  }

  void setFontSize(double fontSize){
    final newState = state.copy(newFontSize: fontSize);
    setState(() {
      state = newState;
    });
  }

  void removeWriting(Writing writing){
    List<Writing> oldWritings = List.from(state.writings);
    oldWritings.remove(writing);

    final newWritings = oldWritings;
    final newState = state.copy(newWritings: newWritings);

    setState(() {
      state = newState;
    });
  }

  void editWriting(Writing oldWriting, Writing newWriting){
    List<Writing> writings = List.from(state.writings);
    int oldIndex = writings.indexOf(oldWriting);
    writings[oldIndex] = newWriting;
    final newState = state.copy(newWritings: writings);
    setState(() {
      state = newState;
    });
  }


  void addTag(String tag){
    final newTags = state.tags.union({tag});
    final newState = state.copy(newTags: newTags);
    setState(() {
      state = newState;
    });
  }

  void removeTag(String tag){
    Set oldTags = Set.from(state.tags);
    oldTags.remove(tag);

    final newTags = oldTags;
    final newState = state.copy(newTags: newTags);

    setState(() {
      state = newState;
    });
  }

  void initialiseState(Set tags, List<Writing> writings){
    final newState = state.copy(newTags: tags, newWritings: writings);
    setState(() {
      state = newState;
    });
  }

  @override
  Widget build(BuildContext contet) => StateInheritedWidget(
    child: widget.child,
    state: state,
    stateWidget: this,
  );


}

class StateInheritedWidget extends InheritedWidget{
  final CoreState state;
  final _StateWidgetState stateWidget;

  const StateInheritedWidget({
    Key key,
    @required Widget child,
    @required this.state,
    @required this.stateWidget,
}) : super(key: key, child: child);

  static _StateWidgetState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<StateInheritedWidget>().stateWidget;

  @override
  bool updateShouldNotify(StateInheritedWidget oldWidget) =>
      oldWidget.state != state;

}