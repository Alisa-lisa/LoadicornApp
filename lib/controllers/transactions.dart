import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:decimal/decimal.dart';
import 'package:format/format.dart';
import 'package:http/http.dart' as http;

String? base = dotenv.env["SERVER"];
String? auth = dotenv.env["AUTH"];
String baseUri = format("{}/transactions", base!);
Map<String, String> headers = {
  'Content-Type': 'application/json',
  'access': auth!,
};

Future<String> createTransaction(
    String id,
    String comment,
    Decimal amount,
    bool isBusiness,
    bool isBorrowed,
    bool isRepeating,
    bool isSpecial,
    String? parentTransaction,
    String? originAcc,
    String? targetAcc,
    List<int> tags) async {
  String url = format("{}/create", baseUri);
  Map<String, dynamic> payload = {
    'user_id': id,
    'comment': comment,
    'amount': amount,
    'is_business': isBusiness,
    'is_borrowed': isBorrowed,
    'is_repeating': isRepeating,
    'is_special': isSpecial,
    'parent_transaction_id': parentTransaction,
    'origin_account': originAcc,
    'target_account': targetAcc,
    'tags': tags
  };
  var resp = await http.post(Uri.parse(url),
      body: jsonEncode(payload), headers: headers);
  if (resp.statusCode == 200) {
    return resp.body;
  } else {
    throw Exception("Could not create transaction");
  }
}
