import 'package:flutter/material.dart';

class Grid extends StatelessWidget {

  final int tilesPerRow;
  final int initialTilesPadding;
  final GridIterator iterator;

  Grid({@required this.tilesPerRow, @required this.iterator, this.initialTilesPadding = 0});

  List<Widget> _buildColumnChildren() {
    List<Widget> columnChildren = [];
    List<Widget> singleRowChildren = [];

    var remainingPadding = initialTilesPadding;
    while(remainingPadding > 0) {
      if (remainingPadding > tilesPerRow)
        singleRowChildren.addAll(List.filled(tilesPerRow, GridTile()));
      else
        singleRowChildren.addAll(List.filled(remainingPadding, GridTile()));
      remainingPadding -= tilesPerRow;

      // Se la Row è full la aggiunge
      if (singleRowChildren.length >= tilesPerRow) {
        columnChildren.add(Row(children: singleRowChildren,));
        singleRowChildren = [];
      }
    }

    while(!iterator.stop()) {
      singleRowChildren.add(iterator.next());

      // Se la Row è full la aggiunge
      if (singleRowChildren.length >= tilesPerRow) {
        columnChildren.add(Row(children: singleRowChildren,));
        singleRowChildren = [];
      }
    }

    if (singleRowChildren.length > 0) {
      singleRowChildren.addAll(List.filled(tilesPerRow - singleRowChildren.length, GridTile()));
      columnChildren.add(Row(children: singleRowChildren,));
    }
    return columnChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildColumnChildren(),
    );
  }

}

class IntGridTile extends StatelessWidget {
  final int number;
  final bool active;
  final bool selected;
  final Function onTap;

  IntGridTile({@required this.number, @required this.active, this.selected = false, this.onTap});

  _onTap(String text) {
    if (onTap != null)
      onTap(number);
  }

  @override
  Widget build(BuildContext context) {
    return TextGridTile(text: number.toString(), active: active, selected: selected, onTap: _onTap,);
  }

}

class TextGridTile extends StatelessWidget {
  final String text;
  final bool active;
  final bool selected;
  final Function onTap;
  final TextStyle inactiveTextStyle = TextStyle(color: Color(0xFF95989A));
  final TextStyle selectedTextStyle = TextStyle(color: Colors.white);
  
  TextGridTile({@required this.text, @required this.active, this.selected = false, this.onTap});

  _onTap() {
    if (onTap != null)
      onTap(text);
  }

  @override
  Widget build(BuildContext context) {
    var onTap = (active && this.onTap != null) ? _onTap : null;
    var textStyle;
    if (active)
      textStyle = selected ? selectedTextStyle : null;
    else
      textStyle = inactiveTextStyle;

    return GridTile(active: active, child: Center(
      child: Text(text, style: textStyle,),
    ), selected: selected, onTap: onTap,);
  }

}

class GridTile extends StatelessWidget {
  final Widget child;
  final bool active;
  final bool selected;
  final Function onTap;

  GridTile({this.child, this.active = true, this.selected = false, this.onTap});

  _inkWell(child) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: _childPadding(child),
      ),
    );
  }

  _childPadding(child) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var containerDecoration;
    bool empty = child == null;

    if (!empty && active) {
      containerDecoration = BoxDecoration(
        color: selected ? Colors.red : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: selected ? null : Border.all(color: Color(0xFFEDEDED)),
      );
    }

    return Expanded(child: Padding(
      padding: EdgeInsets.all(4),
      child: Container(
        decoration: containerDecoration,
        child: (!empty && active) ? _inkWell(child) : _childPadding(child),
      ),
    ));
  }
  
}

class GridIterator {
  Function next;
  Function stop;

  GridIterator({@required this.stop, @required this.next});
}