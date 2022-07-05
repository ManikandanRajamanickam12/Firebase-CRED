import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credope/read.dart';
import 'package:credope/service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditPage extends StatefulWidget {
  EditPage(
      {Key? key,
      required this.currentTitle,
      required this.currentDescription,
      required this.documentId})
      : super(key: key);
  String currentTitle;
  String currentDescription;
  String documentId;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    final controller1 = TextEditingController(text: widget.currentTitle);
    final controller2 = TextEditingController(text: widget.currentDescription);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 156, 206, 212),
      appBar: AppBar(
        title: Text("Edit Data"),
        actions: [
          IconButton(
              onPressed: (() async {
                await Database.deleteItem(docId: widget.documentId);
                // deletedata(widget.documentId);

                Navigator.pop(context);
              }),
              icon: Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: controller1,
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: controller2,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: (() {
                  String title = controller1.text;
                  String description = controller2.text;
                  if (title != "" && description != "") {
                    Database.updateItem(
                      title: title,
                      description: description,
                      docId: widget.documentId,
                    );
                    // updatedata(widget.documentId, title, description);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Enter the Data to Update DB")),
                    );
                  }

                  controller1.clear();
                  controller2.clear();
                }),
                child: Text("Edit Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future updatedata(String id, String title, String description) async {
  print(id);
  final notedDoc = FirebaseFirestore.instance.collection("data").doc(id);
  final data = Note(id: id, title: title, description: description);
  final json = data.toJson();
  await notedDoc.update(json);
}

Future deletedata(String id) async {
  final notedDoc = FirebaseFirestore.instance.collection("data").doc(id);

  await notedDoc.delete();
}
