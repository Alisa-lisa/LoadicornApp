import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/tags.dart';
import 'package:loadiapp/widgets/misc.dart';
import 'package:loadiapp/models/tag.dart';
import 'package:format/format.dart';

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
  String? _chosenColor;

  @override
  void initState() {
    super.initState();
  }

  Future<Tag> _createTag(String name, String description, String? color) async {
    var res = await createTag(name, description, color);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Dialog(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30), // Shadow color
                  spreadRadius: 2, // How wide the shadow spreads
                  blurRadius: 10, // How blurry the shadow is
                  offset:
                      const Offset(2, 4), // The position of the shadow (x, y)
                ),
              ],
              borderRadius:
                  BorderRadius.circular(8.0), // Optional: adds rounded corners
            ),
            width: width * 0.95,
            height: height * 0.7,
            padding: const EdgeInsets.all(5),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'New Tag',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                        getRowElement(
                            width,
                            const Text("Name:", style: TextStyle(fontSize: 9)),
                            TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                controller: _name,
                                textAlign: TextAlign.center)),
                        getRowElement(
                            width,
                            const Text("Comment:",
                                style: TextStyle(fontSize: 9)),
                            TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                controller: _description,
                                textAlign: TextAlign.center)),
                        const SizedBox(height: 10),
                        const Text("Color:", style: TextStyle(fontSize: 10)),
                        SizedBox(
                          width: width * 0.8,
                          child: ColorPicker(
                            pickerColor: Colors.blue,
                            onColorChanged: (v) {
                              _chosenColor =
                                  format("{}-{}-{}-{}", v.a, v.r, v.g, v.b);
                            },
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.purple.shade50,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text("Save"),
                          onPressed: () async {
                            Tag newTag = await _createTag(
                                _name.text, _description.text, _chosenColor);
                            setState(() {
                              cache.update("tags", newTag);
                            });
                            _name.clear();
                            _description.clear();
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          },
                        )
                      ])))
                ])));
  }
}
