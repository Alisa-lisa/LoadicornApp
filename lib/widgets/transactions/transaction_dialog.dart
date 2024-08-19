import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';

import 'package:loadiapp/controllers/accounts.dart';
import 'package:loadiapp/models/account.dart';

class TransactionDialog extends StatefulWidget {
  const TransactionDialog({super.key});

  @override
  TransactionDialogState createState() => TransactionDialogState();
}

class TransactionDialogState extends State<TransactionDialog > {
	final TextEditingController _comment = TextEditingController();
	final TextEditingController _amount = TextEditingController();
	String? origin;
	String? target;
	bool _isBusiness = false;
	bool _isBorrowed = false;
	List<Account> accs = [];

	Future<void> _fetchAccounts(List<Account> accs) async {
		List<Account> res = await fetchAccounts();
		print("WTTTTFFF");
		print("Collected raw accounts ${res}");
		setState(() { accs = res; });
	}

  @override
  void initState() {
    super.initState();
    setState(() {
    
    _fetchAccounts(accs);
    });
    print("Accounts collected ${accs}");
  }

  List<DropdownMenuItem<String>> getAccounts() {
	List<DropdownMenuItem<String>> res = [];
	res.addAll(accs.map<DropdownMenuItem<String>>((Account value) {
					return DropdownMenuItem<String>(
						value: value.id,child: Text(value.comment)
					);
				}).toList());
		res.add(const DropdownMenuItem<String>(
						value: "none",
						child: Text("none")
					));
	return res;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<DropdownMenuItem<String>> ddItems = getAccounts();
    return Dialog(
        child: SingleChildScrollView(
		child: Stack( children: [
            Container(
		color: Colors.white,
                width: width * 0.9,
                height: height * 0.8,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("New Transaction"),
		      Row(
			      children: [
			      const Text("Amount"),
			      Padding(
				      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
				      child: SizedBox(
					      width: width * 0.3,
					      child: TextField(
						      keyboardType: const TextInputType.numberWithOptions(decimal: true),
						      inputFormatters: <TextInputFormatter>[
							      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
						      ],
						      controller: _amount,
						      textAlign: TextAlign.center
						)))
		      ]),
		      const Text("Incoming/Outgoing/Transfer"), // TODO: add visual clue for logic

                      Row(
			children: [
				const Text("Origin Account"),
				DropdownButton<String>(
					focusColor: Colors.white,
					value: origin,
					items: ddItems,
					onChanged: (String? value) {
						setState(() {
							if (value == "none"){
								origin = null;
							} else {
								origin = value!;
							}
						});
					},
					hint: const Text('Account type'))
			]),
                      const Text("Target"),
                      // const Text("Parent"),  // update in db for now if needed
                      const Text("Comment"),
                      const Text("is_business"),
                      const Text("is_borrowed"),
                      const Text("tags"),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text("Save"),
                          onPressed: () async {

                            Navigator.of(context).pop();
                          },
	)]))])));

  }
}
