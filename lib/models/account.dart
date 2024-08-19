import 'package:loadiapp/models/account_type.dart';
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

}
