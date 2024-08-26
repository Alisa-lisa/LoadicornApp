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
