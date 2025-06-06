import 'package:flutter/material.dart';

Widget getRowElement(double width, Widget header, Widget child) {
  return SizedBox(
      width: width * 0.8,
      child: Row(children: [
        Expanded(
            flex: 2,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2), child: header)),
        Expanded(
            flex: 8,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 5, 2),
                child: SizedBox(width: width * 0.3, child: child)))
      ]));
}

const style = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 8,
);

Widget getMonthlyLabel(double value) {
  Widget text;
  switch ((value.toInt())) {
    case 1:
      text = const Text('Jan', style: style);
      break;
    case 2:
      text = const Text('Feb', style: style);
      break;
    case 3:
      text = const Text('Mar', style: style);
      break;
    case 4:
      text = const Text('Apr', style: style);
      break;
    case 5:
      text = const Text('May', style: style);
      break;
    case 6:
      text = const Text('Jun', style: style);
      break;
    case 7:
      text = const Text('Jul', style: style);
      break;
    case 8:
      text = const Text('Aug', style: style);
      break;
    case 9:
      text = const Text('Sep', style: style);
      break;
    case 10:
      text = const Text('Oct', style: style);
      break;
    case 11:
      text = const Text('Nov', style: style);
      break;
    case 12:
      text = const Text('Dec', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return text;
}
