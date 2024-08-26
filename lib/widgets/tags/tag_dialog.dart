import 'package:flutter/material.dart';
import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/tags.dart';
import 'package:loadiapp/widgets/misc.dart';

class TagDialog extends StatefulWidget {
  final CustomCache cache;
  const TagDialog({super.key, required this.cache});

  @override
  TagDialogState createState() => TagDialogState();
}

class TagDialogState extends State<TagDialog> {
  CustomCache get cache => widget.cache;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _createTag(String name, String description) async {
    var res = await createTag(name, description);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
          height: height * 0.3,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("New Tag"),
                getRowElement(
                    width,
                    const Text("Name:"),
                    TextField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        controller: _name,
                        textAlign: TextAlign.center)),
                getRowElement(
                    width,
                    const Text("Comment:", style: TextStyle(fontSize: 11)),
                    TextField(
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        controller: _description,
                        textAlign: TextAlign.center)),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.purple.shade50,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text("Save"),
                  onPressed: () async {
                    await _createTag(_name.text, _description.text);
                    setState(() {
                      // cache.update("tags", );
                    });
                    _name.clear();
                    _description.clear();
                    Navigator.of(context).pop();
                  },
                )
              ]))
    ])));
  }
}
