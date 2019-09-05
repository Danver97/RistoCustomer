import 'package:flutter/material.dart';
import 'package:prova/grid.widget.dart';

class PeoplePicker extends StatefulWidget {
  final int initialPeopleSelected;
  final Function onPeopleChanged;
  final Function onPeopleSelected;
  final Function onPeopleDeselected;

  PeoplePicker({this.initialPeopleSelected, this.onPeopleChanged, this.onPeopleSelected, this.onPeopleDeselected});

  @override
  State<StatefulWidget> createState() => PeoplePickerState();
}

class PeoplePickerState extends State<PeoplePicker> {
  int peopleSelected;
  int maxInt = 10;
  
  final int tilesPerRow = 5;
  final int moreIncrement = 10;

  initState() {
    super.initState();
    peopleSelected = widget.initialPeopleSelected;
  }

  GridIterator iterator() {
    int i = 1;
    return GridIterator(
      next: () {
        var tile;
        if (i != maxInt + 1)
          tile = IntGridTile(number: i, active: true, selected: peopleSelected == i, onTap: _onPeopleTapped,);
        else
          tile = TextGridTile(text: '+', active: true, onTap: _onMoreTapped,);
        i++;
        return tile;
      },
      stop: () => i > maxInt + 1,
    );
  }

  _onMoreTapped(String text) {
    setState(() {
      maxInt += moreIncrement;
    });
  }

  _onPeopleTapped(int i) {
    setState(() {
      if (peopleSelected == i)
        peopleSelected = null;
      else
        peopleSelected = i;
      _onPeopleChanged(peopleSelected);
      if (peopleSelected != null && peopleSelected > 0)
        _onPeopleSelected(peopleSelected);
      else
        _onPeopleDeselected();
    });
  }

  _onPeopleChanged(int i) {
    if (widget.onPeopleChanged != null)
      widget.onPeopleChanged(i);
  }

  _onPeopleSelected(int i) {
    if (widget.onPeopleSelected != null)
      widget.onPeopleSelected(i);
  }

  _onPeopleDeselected() {
    if (widget.onPeopleDeselected != null)
      widget.onPeopleDeselected();
  }

  @override
  Widget build(BuildContext context) {
    return Grid(
      tilesPerRow: tilesPerRow,
      iterator: iterator(),
    );
  }

}
