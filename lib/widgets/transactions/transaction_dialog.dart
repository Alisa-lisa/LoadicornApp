import 'package:flutter/material.dart';

class TransactionDialog extends StatefulWidget {
  const TransactionDialog({super.key});

  @override
  TransactionDialogState createState() => TransactionDialogState();
}

class TransactionDialogState extends State<TransactionDialog > {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Dialog(
        child: SingleChildScrollView(
            child: SizedBox(
                width: width * 0.9,
                height: height * 0.8,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("New Transaction"),
                      const Text("Amount"),
		      const Text("Incoming/Outgoing/Transfer"),
                      const Text("Origin"),
                      const Text("Target"),
                      const Text("Comment"),
                      const Text("is_business"),
                      const Text("is_borrowed"),
                      const Text("tags"),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text("Save"),
                          onPressed: () {
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                        )
                      ]),
                    )));
  }
}
