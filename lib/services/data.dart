import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_notes/models/group.dart';
import 'package:group_notes/models/group_user.dart';
import 'package:group_notes/services/auth.dart';

class Data {
  static DocumentReference getDocRefById(String id) {
    return FirebaseFirestore.instance.collection("Groups").doc(id);
  }

  static Future<void> deleteGroup(String id) async {
    await FirebaseFirestore.instance.collection('Groups').doc(id).delete();
  }

  static Stream<Group> getGroupStream(String id) async* {
    await for (var doc in FirebaseFirestore.instance
        .collection('Groups')
        .doc(id)
        .snapshots()) {
      try {
        yield Group.fromMap(doc.data()!);
      } catch (e) {
        // print('parsing Group error');
      }
    }
  }

  static Future<Group?> getGroup(String id) async {
    var data =
        (await FirebaseFirestore.instance.collection('Groups').doc(id).get())
            .data();
    if (data != null) {
      return Group.fromMap(data);
    }
    return null;
  }

  static Future<void> setGroup(String id, Group group) async {
    await FirebaseFirestore.instance
        .collection('Groups')
        .doc(id)
        .set(group.toMap());
  }

  static Future<String> createGroup(Group group) async {
    var new_doc = FirebaseFirestore.instance.collection("Groups").doc();

    new_doc.set(group.toMap());
    return new_doc.id;
  }
}
