import 'package:firebase_auth/firebase_auth.dart';

class GroupUser {
  late String photoURL;

  late String displayName;

  late String userUID;

  GroupUser.fromFireUser(User user) {
    photoURL = user.photoURL!;
    displayName = user.displayName!;
    userUID = user.uid;
  }
  GroupUser.fromMap(Map<String, dynamic> map) {
    photoURL = map['photoURL']!;
    displayName = map['displayName']!;
    userUID = map['userUID']!;
  }

  Map<String, dynamic> toMap() {
    var ans = new Map<String, dynamic>();

    ans['photoURL'] = photoURL;
    ans['displayName'] = displayName;
    ans['userUID'] = userUID;

    return ans;
  }
}

class CurrentGroupUser extends GroupUser {
  late List<String> notesID;

  CurrentGroupUser.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    notesID = map['notes']!=null?(map['notes'] as List).cast<String>():<String>[];
  }
  CurrentGroupUser.fromFireUser(User fireUser) : super.fromFireUser(fireUser) {
    notesID = [];
  }
  @override
  Map<String, dynamic> toMap() {
    var ans = super.toMap();

    ans['notes'] = notesID;

    return ans;
  }
}
