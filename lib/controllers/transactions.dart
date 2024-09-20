import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:format/format.dart';
import 'package:http/http.dart' as http;

const String baseUri = "https://finance.analyticorn.com/transactions";

Future<String> createTransaction(
    String comment,
    Decimal amount,
    bool isBusiness,
    bool isBorrowed,
    String? parentTransaction,
    String? originAcc,
    String? targetAcc,
    List<int> tags) async {
  String url = format("{}/create", baseUri);
  Map<String, dynamic> payload = {
    'comment': comment,
    'amount': amount,
    'is_business': isBusiness,
    'is_borrowed': isBorrowed,
    'parent_transaction_id': parentTransaction,
    'origin_account': originAcc,
    'target_account': targetAcc,
    'tags': tags
  };
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  var resp = await http.post(Uri.parse(url),
      body: jsonEncode(payload), headers: headers);
  if (resp.statusCode == 200) {
    return resp.body;
  } else {
    throw Exception("Could not create transaction");
  }
}
