import 'dart:convert';
import 'package:format/format.dart';
import 'package:http/http.dart' as http;

const String baseUri = "https://finance.analyticorn.com/charts";

Future<String> getTotal() async {
  String url = format("{}/total", baseUri);
  var resp = await http.get(Uri.parse(url));
  if (resp.statusCode == 200) {
    String res =
        resp.body.toString().replaceAll('"', '').split(".")[0].toString();
    return res;
  } else {
    throw Exception("Could not collect total");
  }
}

Future<List<Map<String, List<String>>>> collectTotalTrend() async {
  String url = format("{}/total_trend", baseUri);
  var resp = await http.get(Uri.parse(url));
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

Future<Map<String, Map<String, double>>> collectAccountTrend() async {
  String url = format("{}/account_trend", baseUri);
  var resp = await http.get(Uri.parse(url));
  if (resp.statusCode == 200) {
    Map<String, Map<String, double>> res = {};
    Map<String, dynamic> payload = jsonDecode(resp.body);
    res = payload.map((k, v) {
      return MapEntry(
          k,
          (v as Map<String, dynamic>).map((ik, iv) {
            return MapEntry(ik.trim(), -double.parse(iv.toString()));
          }));
    });
    return res;
  } else {
    throw Exception("Could not collect structure");
  }
}

Future<Map<String, double>> collectMontlyStructure() async {
  // TBD: for now only current month
  String url =
      format("{}/expenses_structure?month={}", baseUri, DateTime.now());
  var resp = await http.get(Uri.parse(url));
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
