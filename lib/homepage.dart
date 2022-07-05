import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credope/read.dart';
import 'package:credope/service/database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 156, 206, 212),
      appBar: AppBar(
        title: Text("HomePage"),
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
                    Database.addItem(title: title, description: description);

                    // createdata(title, description);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Enter the Data to add into DB")),
                    );
                  }

                  controller1.clear();
                  controller2.clear();
                }),
                child: Text("Add To DB"),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => ReadData())));
                  },
                  child: Text(
                    "View Page",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Future createdata(String title, String description) async {
  final notedDoc = FirebaseFirestore.instance.collection("data").doc();
  final data = Note(id: notedDoc.id, title: title, description: description);
  final json = data.toJson();
  await notedDoc.set(json);
}

class Note {
  String? id;
  String? title;

  String? description;

  Note({
    this.id = "",
    required this.title,
    required this.description,
  });
  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'description': description};
}
