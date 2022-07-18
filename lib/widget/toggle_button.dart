import 'package:flutter/material.dart';

class ToggleButtons1 extends StatefulWidget {
  @override
  _ToggleButtons1State createState() => _ToggleButtons1State();
}

class _ToggleButtons1State extends State<ToggleButtons1> {
  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) => Container(
        color: Color.fromARGB(255, 228, 154, 179),
        child: ToggleButtons(
          isSelected: isSelected,
          selectedColor: Colors.black,
          color: Colors.black,
          fillColor: Colors.green,
          renderBorder: false,
          // splashColor: Colors.red,
          highlightColor: Colors.lightBlue,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Negative', style: TextStyle(fontSize: 18)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Neutral',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Positive', style: TextStyle(fontSize: 18)),
            ),
          ],
          onPressed: (int newIndex) {
            setState(() {
              for (int index = 0; index < isSelected.length; index++) {
                if (index == newIndex) {
                  isSelected[index] = true;
                } else {
                  isSelected[index] = false;
                }
              }
            });
          },
        ),
      );
}
