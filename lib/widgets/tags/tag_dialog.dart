import 'package:flutter/material.dart';

class TagDialog extends StatefulWidget {
  const TagDialog({super.key});

  @override
  TagDialogState createState() => TagDialogState();
}

class TagDialogState extends State<TagDialog> {


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
                      const Text("New Tag"),
                      const Text("Name"),
		      const Text("Description"),
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