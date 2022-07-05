import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Database {
  static Future<void> addItem(
      {required String title, required String description}) async {
    final ref = _firestore.collection("notes").doc();
    Map<String, dynamic> data = {
      "id": ref.id,
      "title": title,
      "description": description
    };
    await ref.set(data).whenComplete(() => print("saved to db"));
  }

  static Future<void> updateItem(
      {required String title,
      required String description,
      required String docId}) async {
    final ref = _firestore.collection("notes").doc(docId);
    Map<String, dynamic> data = {"title": title, "description": description};
    await ref.update(data).whenComplete(() => print("Updated to db"));
  }

  static Stream<QuerySnapshot> readItems() {
    final ref = _firestore.collection("notes");
    return ref.snapshots();
  }

  static Future<void> deleteItem({required String docId}) async {
    final ref = _firestore.collection("notes").doc(docId);
    await ref.delete().whenComplete(() => print("deleted"));
  }
}
