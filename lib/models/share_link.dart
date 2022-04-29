import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareLink {
  static Future<void> share(BuildContext context, String groupID) async {
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Share"),
          content: Column(
            children: [
              Text("Copy this:"),
              SelectableText(
                groupID
              ),
            ],
          ),
        ),
      
      );
    } else {
      await Share.share(groupID);
    }
    // var link = "https://drmatrix.page.link/group?id=$groupID";
  }
}
