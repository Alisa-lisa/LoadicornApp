import 'package:flutter/material.dart';

const List<String> transactionFreq = ["SPECIAL", "REPEAT"];
const int trendMonths = 12;

// TBD add colors/icons to DBs
// Use a more distinct palette so accounts are easier to visually separate.
Map<String, Color> accountsColors = {
  "haspa work": Colors.blue[200]!,
  "default cash": Colors.teal[200]!,
  "revolut invest": Colors.amber[200]!,
  "vivid": Colors.pinkAccent[100]!,
  "dkb personal": Colors.deepPurple[200]!,
  "dkb invest": Colors.green[200]!,
  "dkb shared": Colors.orange[200]!,
  "revolut private": Colors.cyan[200]!,
  "haspa private": Colors.brown[200]!,
};
Color noCustomTagColor = Colors.indigo[300]!;
