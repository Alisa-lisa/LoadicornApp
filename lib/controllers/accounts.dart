import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
// import 'package:loadiapp/models/account_type.dart';
import 'package:format/format.dart';

const String baseUri = "https://finance.analyticorn.com";

Future<http.Response> createAccount(
	String comment,
	String type,
	Decimal balance) {
	String url = format("{}/accounts/register?comment={}&acc_type={}&balance={}", baseUri, comment, type.toUpperCase(), balance);

	var resp = http.post(Uri.parse(url));
	print(resp);
	return resp;
}
