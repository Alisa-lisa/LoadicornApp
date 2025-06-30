import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';

import 'package:loadiapp/controllers/accounts.dart';
import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/widgets/misc.dart';
import 'package:loadiapp/models/account.dart';

class AccountDialog extends StatefulWidget {
  final CustomCache cache;
  const AccountDialog({super.key, required this.cache});

  @override
  AccountDialogState createState() => AccountDialogState();
}

class AccountDialogState extends State<AccountDialog> {
  CustomCache get cache => widget.cache;
  final TextEditingController _comment = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  String? _type;

  @override
  void initState() {
    super.initState();
  }

  Future<Account> _createNewAccount(
      String comment, String type, Decimal amount) async {
    Account res = await createAccount(cache.state["id"], comment, type, amount);
    _comment.clear();
    _amount.clear();
    return res;
  }

  List<DropdownMenuItem<String>> getAccountType() {
    List<DropdownMenuItem<String>> res = [];
    for (String item in ['PERSONAL', 'BUSINESS', 'INVESTMENT']) {
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
        width: width * 0.9,
        height: height * 0.6,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("New Account"),
              Expanded(
                  child: getRowElement(
                      width,
                      const Text("Balance:"),
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
                      const Text("Comment:", style: TextStyle(fontSize: 11)),
                      TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          controller: _comment,
                          textAlign: TextAlign.center))),
              Expanded(
                  child: getRowElement(
                      width,
                      const Text("Type:"),
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
                              hint: const Text("Type"),
                              focusColor: Colors.grey,
                              value: _type,
                              items: ddItems,
                              alignment: Alignment.center,
                              onChanged: (String? value) {
                                setState(() {
                                  _type = value!;
                                });
                              })))),
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
                  Account res = await _createNewAccount(
                      _comment.text, _type!, Decimal.parse(_amount.text));
                  cache.update("accounts", res);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
              ))
            ]),
      )
    ])));
  }
}
