import 'dart:convert';
import 'package:format/format.dart';
import 'package:http/http.dart' as http;
import 'package:loadiapp/models/tag.dart';

const String baseUri = "https://finance.analyticorn.com/tags";

Future<List<Tag>> fetchTags() async {
  String url = format("{}/list", baseUri);
  var resp = await http.get(Uri.parse(url));
  if (resp.statusCode == 200) {
    List<dynamic> body = json.decode(resp.body);
    return body.map((item) => Tag.fromJson(item)).toList();
  } else {
    throw Exception("Failed to fetch tags");
  }
}

Future<Tag> createTag(String name, String description) async {
  String url =
      format("{}/create?name={}&description={}", baseUri, name, description);
  var resp = await http.post(Uri.parse(url));
  if (resp.statusCode == 200) {
    return Tag.fromJson(json.decode(resp.body));
  } else {
    throw Exception("Failed to create a tag");
  }
}
