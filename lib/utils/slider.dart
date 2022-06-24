import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _value = 5.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            body: SfSlider(
          value: _value,
          min: 0.0,
          max: 10.0,
          showLabels: true,
          interval: 1.0,
          showTicks: true,
          enableTooltip: true,
          onChanged: (chosenValue) {
            setState(() {
              _value = chosenValue;
            });
          },
        )));
  }
}
