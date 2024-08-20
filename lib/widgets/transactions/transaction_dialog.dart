import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';

import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/transactions.dart';
import 'package:loadiapp/models/account.dart';

class TransactionDialog extends StatefulWidget {
	final CustomCache cache;
  const TransactionDialog({super.key, required this.cache});

  @override
  TransactionDialogState createState() => TransactionDialogState();
}

class TransactionDialogState extends State<TransactionDialog > {
	CustomCache get cache => widget.cache;

	final TextEditingController _comment = TextEditingController();
	final TextEditingController _amount = TextEditingController();
	String? origin;
	String? target;
	bool _isBusiness = false;
	bool _isBorrowed = false;


  @override
  void initState() {
    super.initState();
  }

  List<DropdownMenuItem<String>> getAccounts() {
	List<DropdownMenuItem<String>> res = [];
	res.addAll(cache.state["accounts"].map<DropdownMenuItem<String>>((Account value) {
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

  Future<void> saveTransaction(String comment,
	  Decimal amount,
	  bool isBusiness,
	  bool isBorrowed,
	  String? parentTransaction,
	  String? origin,
	  String? target,
	  List<int> tags) async {
	  var res = await createTransaction(comment, amount, isBusiness, isBorrowed, null, origin, target, []);
	  print(res);
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
				      padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
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
		      // const Text("Incoming/Outgoing/Transfer"), // TODO: add visual clue for logic
                      Row(
			children: [
				const Text("Origin"),
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
                      Row(
			children: [
			      const Text("Target"),
				Padding(
					padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
					child:DropdownButton<String>(
					focusColor: Colors.white,
					value: target,
					items: ddItems,
					onChanged: (String? value) {
						setState(() {
							if (value == "none"){
								target = null;
							} else {
								target = value!;
							}
						});
					},
					hint: const Text('Account type'))
				)
			]),
                      // const Text("Parent"),  // update in db for now if needed
                      Row(children: [
			      const Text("Comment"),
				Padding(
					padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
					child: SizedBox(width: width* 0.3,
						child: TextField(
						controller: _comment,
						textAlign: TextAlign.center
					))
				),
		      ]),
                      Row(children: [
			      const Text("is business"),
			      InkWell(
				      child: const Icon(Icons.add_business, color: Colors.grey),
				      onTap: () {
					      setState(() {
						_isBusiness != _isBusiness;
					      });
				      }
				      )
		      ]),
                      Row(children: [
                      const Text("is borrowed"),
			      InkWell(
				      child: const Icon(Icons.account_balance, color: Colors.grey),
				      onTap: () {
					      setState(() {
						_isBorrowed != _isBorrowed;
					      });
				      }
				      )
		      ]),
                      const Text("tags"),
		      TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text("Save"),
                          onPressed: () async {
			await saveTransaction(_comment.text, Decimal.parse(_amount.text), _isBusiness, _isBorrowed, null, origin, target, []);
                            Navigator.of(context).pop();
                          },
	)]))])));

  }
}
