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
    String id, String comment, String type, Decimal balance) async {
  String url = format("{}/register", baseUri);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'access': auth!,
  };
  Map<String, dynamic> body = {
    "comment": comment,
    "type": type.toUpperCase(),
    "is_cash": false,
    "balance": balance,
    "user_id": id
  };
  var resp =
      await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
  if (resp.statusCode == 200) {
    return Account.fromJson(jsonDecode(resp.body));
  } else {
    throw Exception("Failed to create account");
  }
}

Future<List<Account>> fetchAccounts(String id) async {
  String url = format('{}/list/{}', baseUri, id);
  var resp = await http.get(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(resp.body);
    return jsonList.map((json) => Account.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load accounts");
  }
}
