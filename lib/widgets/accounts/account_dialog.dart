import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loadiapp/controllers/accounts.dart';
import 'package:decimal/decimal.dart';
import 'package:loadiapp/models/account_type.dart';

class AccountDialog extends StatefulWidget {
  const AccountDialog({super.key});

  @override
  AccountDialogState createState() => AccountDialogState();
}

class AccountDialogState extends State<AccountDialog> {
	final TextEditingController _comment = TextEditingController();
	final TextEditingController _amount = TextEditingController();
	String? _type;

  @override
  void initState() {
    super.initState();

  }

  Future<void> _createNewAccount(String comment, String type, Decimal amount) async {
	  await createAccount(comment, type, amount);
	_comment.clear();
	_amount.clear();
  }

  List<DropdownMenuItem<String>> getAccountType() {
		List<DropdownMenuItem<String>> res = [];
		for (String item in ['PERSONAL', 'BUSINESS', 'INVESTMENT']){
			res.add(DropdownMenuItem<String>(value: item, child: Text(item)));
		}
		return res;
	}

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<DropdownMenuItem<String>> ddItems = getAccountType();
    return Dialog(
        child: SingleChildScrollView(
		child: Stack(children: [
		    Container(
			width: width * 0.9,
			height: height * 0.8,
			color: Colors.white,
			child: Column(
			    mainAxisAlignment: MainAxisAlignment.spaceAround,
			    children: [
			      const Text("New Account"),
			      Row(children: [
				      const Text("Balance"),
					Padding(
						padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
						child: SizedBox(
							width: width * 0.3,
							child:TextField(
							keyboardType: TextInputType.numberWithOptions(decimal: true),
							  inputFormatters: <TextInputFormatter>[
							   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
							  ],
							controller: _amount,
							textAlign: TextAlign.center
						))
					),
			      ]),
			      Row(children: [
				      const Text("Comment"),
					Padding(
						padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
						child: SizedBox(width: width* 0.3,
							child: TextField(
							controller: _comment,
							textAlign: TextAlign.center
						))
					),
			      ]),
			      Row(children: [
				      const Text("Type"),
				      DropdownButton<String>(
					focusColor: Colors.white,
					value: _type,
					items: ddItems,
					onChanged: (String? value) {
						setState(() {
							_type = value!;
						});
					},
					hint: const Text('Choose a tag'))
			      ]),
				TextButton(
				  style: TextButton.styleFrom(
				    foregroundColor: Colors.blue,
				    padding: const EdgeInsets.all(16.0),
				    textStyle: const TextStyle(fontSize: 20),
				  ),
				  child: const Text("Save"),
				  onPressed: () async {
				    await _createNewAccount(_comment.text, _type!, Decimal.parse(_amount.text));
				    Navigator.of(context).pop();
				  },
				)
			      ]),
			)])));
  }
}
