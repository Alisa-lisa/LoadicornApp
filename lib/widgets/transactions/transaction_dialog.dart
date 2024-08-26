import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/transactions.dart';
import 'package:loadiapp/models/account.dart';
import 'package:loadiapp/models/tag.dart';
import 'package:loadiapp/widgets/misc.dart';

class TransactionDialog extends StatefulWidget {
  final CustomCache cache;
  const TransactionDialog({super.key, required this.cache});

  @override
  TransactionDialogState createState() => TransactionDialogState();
}

class TransactionDialogState extends State<TransactionDialog> {
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
    res.addAll(
        cache.state["accounts"].map<DropdownMenuItem<String>>((Account value) {
      return DropdownMenuItem<String>(
          value: value.id, child: Text(value.comment));
    }).toList());
    res.add(const DropdownMenuItem<String>(
        value: "none",
        child: Text(
          "none",
          textAlign: TextAlign.center,
        )));
    return res;
  }

  List<DropdownItem<Tag>> prepareTags() {
    List<DropdownItem<Tag>> items = [];
    items.addAll(cache.state["tags"].map<DropdownItem<Tag>>((Tag value) {
      return DropdownItem(label: value.name, value: value);
    }).toList());
    return items;
  }

  Future<void> saveTransaction(
      String comment,
      Decimal amount,
      bool isBusiness,
      bool isBorrowed,
      String? parentTransaction,
      String? origin,
      String? target,
      List<DropdownItem<Tag>> tags) async {
    List<int> taggos = [];
    taggos.addAll(tags.map((DropdownItem<Tag> t) {
      return t.value.id;
    }).toList());
    var res = await createTransaction(
        comment, amount, isBusiness, isBorrowed, null, origin, target, taggos);
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
            child: Stack(children: [
      Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                spreadRadius: 2, // How wide the shadow spreads
                blurRadius: 10, // How blurry the shadow is
                offset: const Offset(2, 4), // The position of the shadow (x, y)
              ),
            ],
            borderRadius:
                BorderRadius.circular(8.0), // Optional: adds rounded corners
          ),
          width: width * 0.92,
          height: height * 0.8,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("New Transaction"),
                SizedBox(
                  height: height * 0.01,
                ),

                getRowElement(
                    width,
                    const Text('Amount:'),
                    TextField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        controller: _amount,
                        textAlign: TextAlign.center)),
                // const Text("Incoming/Outgoing/Transfer"),
                getRowElement(
                    width,
                    const Text("Origin:"),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.purple,
                              width: 1.0), // Border around the DropdownButton
                          borderRadius: BorderRadius.circular(
                              2.0), // Optional: adds rounded corners
                        ),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            hint: const Text("Account"),
                            focusColor: Colors.grey,
                            value: origin,
                            items: ddItems,
                            alignment: Alignment.center,
                            onChanged: (String? value) {
                              setState(() {
                                if (value == "none") {
                                  origin = null;
                                } else {
                                  origin = value!;
                                }
                              });
                            }))),
                getRowElement(
                    width,
                    const Text("Target:"),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.purple,
                              width: 1.0), // Border around the DropdownButton
                          borderRadius: BorderRadius.circular(
                              2.0), // Optional: adds rounded corners
                        ),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                            hint: const Text("Account"),
                            focusColor: Colors.grey,
                            value: origin,
                            items: ddItems,
                            alignment: Alignment.center,
                            onChanged: (String? value) {
                              setState(() {
                                if (value == "none") {
                                  target = null;
                                } else {
                                  target = value!;
                                }
                              });
                            }))),
                // const Text("Parent"),  // update in db for now if needed
                getRowElement(
                    width,
                    const Text("Comment:", style: TextStyle(fontSize: 11)),
                    SizedBox(
                        width: width * 0.3,
                        child: TextField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            controller: _comment,
                            textAlign: TextAlign.center))),
                Row(children: [
                  const Text("is business"),
                  InkWell(
                      child: const Icon(Icons.add_business, color: Colors.grey),
                      onTap: () {
                        setState(() {
                          _isBusiness != _isBusiness;
                        });
                      })
                ]),
                Row(children: [
                  const Text("is borrowed"),
                  InkWell(
                      child:
                          const Icon(Icons.account_balance, color: Colors.grey),
                      onTap: () {
                        setState(() {
                          _isBorrowed != _isBorrowed;
                        });
                      })
                ]),
                getRowElement(
                    width,
                    const Text("Tags:"),
                    SizedBox(
                        width: width * 0.6,
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
                        ))),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.purple.shade50,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text("Save"),
                  onPressed: () async {
                    await saveTransaction(
                        _comment.text,
                        Decimal.parse(_amount.text),
                        _isBusiness,
                        _isBorrowed,
                        null,
                        origin,
                        target,
                        _tags.selectedItems);
                    Navigator.of(context).pop();
                  },
                )
              ]))
    ])));
  }
}
