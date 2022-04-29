import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:group_notes/models/group_user.dart';
import 'package:group_notes/services/data.dart';

class Auth {
  static Future<DocumentSnapshot> getDocById(String id) async {
    return await getDocRefById(id).get();
  }

  static DocumentReference getDocRefById(String id) {
    return FirebaseFirestore.instance.collection("Users").doc(id);
  }

  static Stream<CurrentGroupUser?> userChanges() async* {
    await for (var fireuser in FirebaseAuth.instance.userChanges()) {
      print("user is $fireuser");
      if (fireuser != null) {
        await for (var userData in getDocRefById(fireuser.uid).snapshots()) {
          var doc = userData;
          if (doc.exists) {
            var u = CurrentGroupUser.fromMap(doc.data()!);

            yield u;
          } else {
            doc.reference
                .set(new CurrentGroupUser.fromFireUser(fireuser).toMap());
          }
        }
      } else {
        yield null;
      }
    }
  }

  static Future<bool> addIdToUser(CurrentGroupUser user, String id) async {
    if (!user.notesID.contains(id) && user.notesID.length < 10) {
      var docRef = getDocRefById(user.userUID);

      user.notesID.add(id);

      await docRef.set(user.toMap());
    }
    return user.notesID.length < 10;
  }

  static Future<void> removeIdFromUser(CurrentGroupUser user, String id) async {
    if (user.notesID.remove(id)) {
      var docRef = getDocRefById(user.userUID);

      // user.notesID.add(id);

      await docRef.set(user.toMap());
    }
  }

  static Future<void> cleanUser(CurrentGroupUser user) async {
    var l = user.notesID;

    // l.where((element) => ids.contains(element));

    for (var id in l.toList()) {
      var docRef = Data.getDocRefById(id);
      var d = await docRef.get();

      if(!d.exists){
        l.remove(id);
      }

    }


    user.notesID = l;

    var docRef = getDocRefById(user.userUID);

    await docRef.set(user.toMap());
  }
}
