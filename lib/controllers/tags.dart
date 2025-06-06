import 'dart:convert';
import 'package:format/format.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loadiapp/controllers/analytics.dart';
import 'package:loadiapp/models/tag.dart';

String? base = dotenv.env["SERVER"];
String? auth = dotenv.env["AUTH"];
String baseUri = format("{}/tags", base!);

Future<List<Tag>> fetchTags() async {
  String url = format("{}/list", baseUri);
  var resp = await http.get(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    List<dynamic> body = json.decode(resp.body);
    return body.map((item) => Tag.fromJson(item)).toList();
  } else {
    throw Exception("Failed to fetch tags");
  }
}

Future<Tag> createTag(String name, String description, String? color) async {
  String url =
      format("{}/create?name={}&description={}", baseUri, name, description);
  if (color != null) {
    url = format("{}&color={}", url, color);
  }
  var resp = await http.post(Uri.parse(url), headers: headers);
  if (resp.statusCode == 200) {
    return Tag.fromJson(json.decode(resp.body));
  } else {
    throw Exception("Failed to create a tag");
  }
}
