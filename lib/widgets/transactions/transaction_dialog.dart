import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import 'package:loadiapp/const.dart';
import 'package:loadiapp/controllers/analytics.dart';
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
  bool isIncoming = false;
  bool isBusiness = false;
  bool isRepeating = false;
  bool isSpecial = false;

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
      bool isIncoming,
      bool isBusiness,
      bool isBorrowed,
      bool isRepeating,
      bool isSpecial,
      String? parentTransaction,
      String? origin,
      String? target,
      List<DropdownItem<Tag>> tags) async {
    List<int> taggos = [];
    taggos.addAll(tags.map((DropdownItem<Tag> t) {
      return t.value.id;
    }).toList());
    Decimal tAmount = isIncoming == false ? -amount : amount;
    await createTransaction(comment, tAmount, isBusiness, isBorrowed,
        isRepeating, isSpecial, null, origin, target, taggos);
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
    Color outgoingColor = isIncoming == false ? Colors.red : Colors.grey;
    Color incomingColor = isIncoming == true ? Colors.red : Colors.grey;
    Color isRepeatingColor = isRepeating == true ? Colors.red : Colors.grey;
    Color isSpecialColor = isSpecial == true ? Colors.red : Colors.grey;
    Color isBusinessColor = isBusiness == false ? Colors.grey : Colors.red;
    return Dialog(
        child: SingleChildScrollView(
            child: Stack(children: [
      Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30), // Shadow color
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
                const Text("New Transaction", style: TextStyle(fontSize: 16)),
                Row(children: [
                  Expanded(
                      flex: 3,
                      child: InkWell(
                          child: Icon(Icons.arrow_upward, color: outgoingColor),
                          onTap: () {
                            setState(() {
                              if (outgoingColor == Colors.grey) {
                                outgoingColor = Colors.red;
                                incomingColor = Colors.grey;
                                isIncoming = false;
                              }
                            });
                          })),
                  Expanded(
                      flex: 3,
                      child: InkWell(
                          child:
                              Icon(Icons.arrow_downward, color: incomingColor),
                          onTap: () {
                            setState(() {
                              if (incomingColor == Colors.grey) {
                                outgoingColor = Colors.grey;
                                incomingColor = Colors.red;
                                isIncoming = true;
                              }
                            });
                          })),
                ]),
                Expanded(
                    child: getRowElement(
                        width,
                        const Text('Amount:'),
                        TextField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*')),
                            ],
                            controller: _amount,
                            textAlign: TextAlign.center))),
                Expanded(
                    child: getRowElement(
                        width,
                        const Text("Origin:"),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purple,
                                  width:
                                      1.0), // Border around the DropdownButton
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
                                })))),
                Expanded(
                    child: getRowElement(
                        width,
                        const Text("Target:"),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.purple,
                                  width:
                                      1.0), // Border around the DropdownButton
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
                                value: target,
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
                                })))),
                Expanded(
                    child: getRowElement(
                        width,
                        const Text("Comment:", style: TextStyle(fontSize: 11)),
                        SizedBox(
                            width: width * 0.3,
                            child: TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                controller: _comment,
                                textAlign: TextAlign.center)))),
                Row(children: [
                  Expanded(
                      flex: 3,
                      child: InkWell(
                          child: Icon(Icons.cached, color: isRepeatingColor),
                          onTap: () {
                            setState(() {
                              isRepeating = !isRepeating;
                              if (isRepeating == true) {
                                isSpecial = false;
                              }
                            });
                          })),
                  Expanded(
                      flex: 3,
                      child: InkWell(
                          child: Icon(Icons.bolt, color: isSpecialColor),
                          onTap: () {
                            setState(() {
                              isSpecial = !isSpecial;
                              if (isSpecial == true) {
                                isRepeating = false;
                              }
                            });
                          })),
                  Expanded(
                      flex: 3,
                      child: InkWell(
                          child:
                              Icon(Icons.add_business, color: isBusinessColor),
                          onTap: () {
                            setState(() {
                              isBusiness = !isBusiness;
                            });
                          })),
                ]),
                Expanded(
                    child: getRowElement(
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
                            )))),
                Expanded(
                    child: TextButton(
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
                        isIncoming,
                        isBusiness,
                        false,
                        isRepeating,
                        isSpecial,
                        null,
                        origin,
                        target,
                        _tags.selectedItems);
                    String newTotal = await getTotal();
                    cache.updateSimple("total", newTotal);
                    Map<String, double> newStructure =
                        await collectMontlyStructure();
                    cache.updateSimple("monthlyStructure", newStructure);
                    List<Map<String, List<String>>> newTrend =
                        await collectMonthlyTrend(trendMonths);
                    cache.updateSimple("monthlyTrend", newTrend);
                    setState(() {});
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                ))
              ]))
    ])));
  }
}
