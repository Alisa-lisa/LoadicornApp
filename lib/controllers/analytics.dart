// import 'dart:convert';
// import 'package:decimal/decimal.dart';
import 'package:format/format.dart';
import 'package:http/http.dart' as http;

const String baseUri = "https://finance.analyticorn.com/charts";

Future<String> getTotal() async {
  String url = format("{}/total", baseUri);
  var resp = await http.get(Uri.parse(url));
  if (resp.statusCode == 200) {
    String res = resp.body.toString().replaceAll('"', '');
    return res;
  } else {
    throw Exception("Could not collect total");
  }
}
