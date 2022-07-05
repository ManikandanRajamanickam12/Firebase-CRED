import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credope/edit.dart';
import 'package:credope/homepage.dart';
import 'package:credope/service/database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReadData extends StatefulWidget {
  ReadData({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadData> createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  @override
  Widget build(BuildContext context) {
    Widget builddata(Note note) {
      return ListTile(
          leading: Icon(
            Icons.list_alt,
            size: 45,
            color: Colors.black,
          ),
          title: Text(note.title.toString()),
          subtitle: Text(note.description.toString()),
          trailing: IconButton(
            onPressed: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => EditPage(
                          currentTitle: note.title.toString(),
                          currentDescription: note.description.toString(),
                          documentId: note.id.toString()))));
            }),
            icon: Icon(
              Icons.edit,
              color: Colors.black,
              size: 30,
            ),
          ));
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 156, 206, 212),
        appBar: AppBar(
          title: Text("ReadData"),
        ),
        body: Column(
          children: [
            // Expanded(
            //   child: StreamBuilder(
            //     stream: readdata(),
            //     builder: (context, AsyncSnapshot<List<Note>> snapshot) {
            //       if (snapshot.hasData) {
            //         final users = snapshot.data!;

            //         return SizedBox(
            //           height: 500,
            //           child: ListView(
            //             children: users.map(builddata).toList(),
            //           ),
            //         );
            //       } else {
            //         return Center(child: CircularProgressIndicator());
            //       }
            //     },
            //   ),
            // ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Database.readItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 500,
                        child: ListView.separated(
                          separatorBuilder: ((context, index) => SizedBox(
                                height: 10,
                              )),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var noteinfo = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            String docId = snapshot.data!.docs[index].id;
                            String title = noteinfo["title"];
                            String description = noteinfo["description"];
                            return Ink(
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: Icon(
                                  Icons.list_alt,
                                  size: 45,
                                  color: Colors.black,
                                ),
                                title: Text(
                                  title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  description,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => EditPage(
                                                  currentTitle: title,
                                                  currentDescription:
                                                      description,
                                                  documentId: docId))));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 30,
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ));
  }
}

Stream<List<Note>> readdata() =>
    FirebaseFirestore.instance.collection("data").snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());

class Note {
  String? id;
  String? title;
  String? description;

  Note({
    this.id = "",
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };

  static Note fromJson(Map<String, dynamic> json) => Note(
      id: json['id'], title: json['title'], description: json['description']);
}
