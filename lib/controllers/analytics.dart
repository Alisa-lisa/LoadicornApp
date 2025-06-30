import 'dart:convert';
import 'package:format/format.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

String? base = dotenv.env["SERVER"];
String? auth = dotenv.env["AUTH"];
String baseUri = format("{}/charts", base!);
Map<String, String> headers = {
  'Content-Type': 'application/json',
  'access': auth!,
};

Future<String> getTotal(String id) async {
  String url = format("{}/total/{}", baseUri, id);
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
Future<List<Map<String, List<String>>>> collectMonthlyTrend(
    String id, int? limit) async {
  String url = format("{}/total_trend/{}", baseUri, id);
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
    if (limit != null) {
      int start = res.length - limit > 0 ? res.length - limit : 0;
      var sublist = ListSlice(res, start, res.length);
      return sublist;
    }
    return res;
  } else {
    throw Exception("Could not collect total trend");
  }
}

Future<Map<String, double>> collectMontlyStructure(String id) async {
  // TBD: for now only current month
  String url =
      format("{}/expenses_structure/{}?month={}", baseUri, id, DateTime.now());
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

Future<Map<String, double>> collectReoccuring(
    String id, DateTime date, String freq) async {
  String url =
      format("{}/special/{}?date={}&frequency={}", baseUri, id, date, freq);
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
