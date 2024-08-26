import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/transactions.dart';
import 'package:loadiapp/models/account.dart';
import 'package:loadiapp/models/tag.dart';

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
	final MultiSelectController<Tag> _tags = MultiSelectController<Tag>();
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


  List<DropdownItem<Tag>> prepareTags() {
  	List<DropdownItem<Tag>> items = [];
	items.addAll(cache.state["tags"].map<DropdownItem<Tag>>((Tag value) {
		return DropdownItem(label: value.name, value: value);
	}).toList());
	return items;
  }


  Future<void> saveTransaction(String comment,
	  Decimal amount,
	  bool isBusiness,
	  bool isBorrowed,
	  String? parentTransaction,
	  String? origin,
	  String? target,
	  List<DropdownItem<Tag>> tags) async {
	  List<int> taggos = [];
	  taggos.addAll(tags.map((DropdownItem<Tag> t) {return t.value.id;}).toList());
	  var res = await createTransaction(comment, amount, isBusiness, isBorrowed, null, origin, target, taggos);
	_tags.clearAll();
	_amount.clear();
	_comment.clear();
}

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<DropdownMenuItem<String>> ddItems = getAccounts();
    List<DropdownItem<Tag>> tagsItems = prepareTags();
    return Dialog(
        child: SingleChildScrollView(
		child: Stack( children: [
            Container(
		color: Colors.white,
                width: width * 0.9,
                height: height * 0.8,
                child: Column(
			mainAxisSize: MainAxisSize.max,
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
                      Row(children: [
		      	const Text("tags"),
			Padding(
				padding: const EdgeInsets.fromLTRB(10, 2, 0, 5),
				child: SizedBox( width: width * 0.6,
					child: MultiDropdown<Tag>(
					items: tagsItems,
					controller: _tags,
					enabled: true,
					searchEnabled: true,
					chipDecoration: const ChipDecoration(
					  backgroundColor: Colors.yellow,
					  wrap: true,
					  runSpacing: 2,
					  spacing: 10,
					),
					)
			))]),
		      TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text("Save"),
                          onPressed: () async {
			await saveTransaction(_comment.text, Decimal.parse(_amount.text), _isBusiness, _isBorrowed, null, origin, target,_tags.selectedItems);
                            Navigator.of(context).pop();
                          },
	)]))])));

  }
}
