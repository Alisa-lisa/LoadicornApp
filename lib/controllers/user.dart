import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:format/format.dart';

String? base = dotenv.env["SERVER"];
String? auth = dotenv.env["AUTH"];
String baseUri = format("{}/users", base!);

Future<String> registerUser(String name, String pswd) async {
  String url = format("{}/create", baseUri);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'access': auth!,
  };
  Map<String, dynamic> body = {
    'name': name,
    'password': pswd,
    'registration': DateTime.now().toString()
  };
  var resp = await http.post(Uri.parse(url), headers: headers, body: body);
  if (resp.statusCode == 200) {
    return json.decode(resp.body);
  } else {
    throw Exception("Failed to create a user");
  }
}

Future<String> logIn(String name, String pswd) async {
  String url = format("{}/login", baseUri);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'access': auth!,
  };
  Map<String, dynamic> body = {
    'name': name,
    'password': pswd,
  };
  var resp = await http.post(Uri.parse(url), headers: headers, body: body);
  if (resp.statusCode == 200) {
    return json.decode(resp.body);
  } else {
    throw Exception("Failed to login a user");
  }
}
