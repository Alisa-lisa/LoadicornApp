// import 'package:loadiapp/models/account_type.dart';
import 'package:decimal/decimal.dart';


class Account {
	final String id;
	final String comment;
	final String type;
	final bool isCash;
	final Decimal balance;
	final bool active;

	const Account({
		required this.id,
		required this.comment,
		required this.type,
		required this.isCash,
		required this.balance,
		required this.active
	});

	factory Account.fromJson(Map<String, dynamic> json) {
		return Account(
			id: json['id'],
			comment: json['comment'],
			type: json['type'],
			isCash: json['is_cash'],
			balance: Decimal.parse(json['balance']),
			active: json['active']
			);
	}
}
