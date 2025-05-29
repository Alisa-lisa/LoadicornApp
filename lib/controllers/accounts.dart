import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:format/format.dart';
import 'package:loadiapp/controllers/analytics.dart';
import 'package:loadiapp/models/account.dart';

String? base = dotenv.env["SERVER"];
String? auth = dotenv.env["AUTH"];
String baseUri = format("{}/accounts", base!);

Future<Account> createAccount(
    String comment, String type, Decimal balance) async {
  String url = format("{}/register?comment={}&acc_type={}&balance={}", baseUri,
      comment, type.toUpperCase(), balance);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'access': auth!,
  };

  var resp = await http.post(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    return Account.fromJson(json.decode(resp.body));
  } else {
    throw Exception("Failed to create account");
  }
}

Future<List<Account>> fetchAccounts() async {
  String url = format('{}/list', baseUri);
  var resp = await http.get(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(resp.body);
    return jsonList.map((json) => Account.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load accounts");
  }
}
