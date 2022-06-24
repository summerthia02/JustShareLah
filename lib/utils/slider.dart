import 'package:flutter/material.dart';

class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  static double _lowerValue = 0.0;
  static double _upperValue = 10.0;

  RangeValues values = RangeValues(_lowerValue, _upperValue);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 15,
        overlayColor: Colors.transparent,
        minThumbSeparation: 100,
        rangeThumbShape: RoundRangeSliderThumbShape(
          enabledThumbRadius: 10,
          disabledThumbRadius: 10,
        ),
      ),
      child: RangeSlider(
        activeColor: Colors.blue,
        labels: RangeLabels(
            values.start.abs().toString(), values.end.abs().toString()),
        min: 0.0,
        max: 10.0,
        values: values,
        onChanged: (val) {
          setState(() {
            values = val;
          });
        },
      ),
    );
  }
}
