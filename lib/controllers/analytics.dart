import 'dart:convert';
import 'package:format/format.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String? base = dotenv.env["SERVER"];
String? auth = dotenv.env["AUTH"];
String baseUri = format("{}/charts", base!);
Map<String, String> headers = {
  'Content-Type': 'application/json',
  'access': auth!,
};

Future<String> getTotal() async {
  String url = format("{}/total", baseUri);
  var resp = await http.get(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    String res =
        resp.body.toString().replaceAll('"', '').split(".")[0].toString();
    return res;
  } else {
    throw Exception("Could not collect total");
  }
}

/// Backend call to collect aggregated in/out numbers per month for all accounts
Future<List<Map<String, List<String>>>> collectMonthlyTrend() async {
  String url = format("{}/total_trend", baseUri);
  var resp = await http.get(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    List<Map<String, List<String>>> res = [];
    var payload = jsonDecode(resp.body);
    for (var item in payload) {
      List<String> values = [];
      for (var i in item.values.first) {
        values.add(i.toString());
      }
      res.add({item.keys.first.toString(): values});
    }
    return res;
  } else {
    throw Exception("Could not collect total trend");
  }
}

Future<Map<String, double>> collectMontlyStructure() async {
  // TBD: for now only current month
  String url =
      format("{}/expenses_structure?month={}", baseUri, DateTime.now());
  var resp = await http.get(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    Map<String, dynamic> payload = jsonDecode(resp.body);
    var res = payload.map((k, v) {
      return MapEntry(k, double.parse(v.toString()));
    });
    return res;
  } else {
    throw Exception("Could not collect monthly structure");
  }
}

Future<Map<String, double>> collectReoccuring() async {
  String url = format("{}/reoccuring?date={}", baseUri, DateTime.now());
  var resp = await http.get(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    Map<String, dynamic> payload = jsonDecode(resp.body);
    Map<String, double> res = payload.map<String, double>((k, v) {
      return MapEntry(k, -double.parse(v.toString()));
    });
    return res;
  } else {
    throw Exception("Re-occuring expenses are not available");
  }
}
