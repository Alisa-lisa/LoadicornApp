import 'package:flutter/material.dart';
import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/tags.dart';


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
            child: SizedBox(
                width: width * 0.9,
                height: height * 0.8,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("New Tag"),
                      Row(children:[
		      	const Text("Name"),
			Padding(
					padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
				child: SizedBox(
					width: width * 0.4,
					child: TextField(
						controller: _name,
						textAlign: TextAlign.center,
					)
				)
			)
			]),
                      Row(children:[
		      const Text("Description"),
			SizedBox(
				width: width * 0.4,
				child: Padding(
					padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
					child: TextField(
						controller: _description,
						textAlign: TextAlign.center,
					)
				)
			)
			]),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text("Save"),
                          onPressed: () async {
			  	await _createTag(_name.text, _description.text);
                            setState(() {
				// TODO: update cache properly
			    	// cache.update("tags", );
			    });
			    _name.clear();
			    _description.clear();
                            Navigator.of(context).pop();
                          },
                        )
                      ]),
                    )));
  }
}
