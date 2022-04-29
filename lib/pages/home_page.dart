import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_notes/models/group.dart';
import 'package:group_notes/models/group_user.dart';
import 'package:group_notes/models/share_link.dart';
import 'package:group_notes/pages/group_page.dart';
import 'package:group_notes/services/auth.dart';
import 'package:group_notes/services/data.dart';

class HomePage extends StatelessWidget {
  HomePage({required this.groupUser, required this.signout});

  Function signout;

  final CurrentGroupUser groupUser;

  final TextEditingController titleEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            signout();
          },
        ),
        actions: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                children: [
                  Image.network(
                    groupUser.photoURL,
                    width: 50,
                  ),
                  Text(groupUser.displayName),
                ]
                    .map((e) => Padding(
                          padding: EdgeInsets.all(2),
                          child: e,
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: (() {
          // print(snapshot.data);
          var data = groupUser.notesID;
          // if(groupUser.notesID.length==0){
          // }

          Auth.cleanUser(groupUser);

          return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == data.length) {
                return IntrinsicHeight(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => newGroupDialog(context),
                              );
                            },
                            child: Text("Create new group!"),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => addGroupdialog(context),
                              );
                            },
                            child: Text("Join to group!"),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

              // var ent = data[index];

              // var currentGroup = ent.key;
              var id = data[index];
              return StreamBuilder<Group?>(
                  stream: Data.getGroupStream(id),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Card(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    var ent = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 15,
                        child: TextButton(
                          onLongPress: () async {
                            if (groupUser.userUID != ent.creatorUID) {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title:
                                      Text("Do you want to exit from this group?"),
                                  content: Text(
                                      "You will exit \"${ent.Name}\""),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "no",
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // await Data.deleteGroup(id);
                                        Navigator.pop(context);
                                        // groupUser.notesID.remove(ent.value);
                                        Auth.removeIdFromUser(groupUser, id);
                                      },
                                      child: Text(
                                        "yes",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Do you like to delete this group?"),
                                  content: Text("you will delete ${ent.Name}"),
                                  actions:[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "no",
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Data.deleteGroup(id);
                                        Navigator.pop(context);
                                        // groupUser.notesID.remove(ent.value);
                                        Auth.removeIdFromUser(groupUser, id);
                                      },
                                      child: Text(
                                        "yes",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return GroupPage(groupID: id);
                              },
                            ));
                          },
                          child: ListTile(
                            title: Text(ent.Name),
                            trailing: IconButton(
                              onPressed: () async {
                                ShareLink.share(context,id);
                              },
                              icon: Icon(
                                Icons.share,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
          );
          // return Text("GG");
        })(),
      ),
    );
  }

  AlertDialog addGroupdialog(BuildContext context) {
    return AlertDialog(
      title: Text("Add Group!"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancel")),
        TextButton(
            onPressed: () async {
              if (titleEditingController.text != "") {
                var id = titleEditingController.text;

                var g = await Data.getGroup(id);

                if (g == null) {
                  Navigator.pop(context);
                  print("GG");
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Group not exist!"),
                      content: Text("group with id of $id isn't exist!"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Ok"))
                      ],
                    ),
                  );
                } else if (groupUser.notesID.length < 10) {
                  await Auth.addIdToUser(groupUser, id);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  showMaxGroupDialog(context);
                }
              }
            },
            child: Text("add")),
      ],
      content: TextField(
        controller: titleEditingController,
        decoration: InputDecoration(hintText: "new Group Name"),
      ),
    );
  }

  AlertDialog newGroupDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Create Group!"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancel")),
        TextButton(
            onPressed: () async {
              if (titleEditingController.text != "") {
                var id = await Data.createGroup(new Group(
                    Name: titleEditingController.text,
                    notes: new Map(),
                    creatorUID: groupUser.userUID));
                if (groupUser.notesID.length < 10) {
                  await Auth.addIdToUser(groupUser, id);
                  Navigator.pop(context);
                } else {
                  showMaxGroupDialog(context);
                }
              }
            },
            child: Text("create")),
      ],
      content: TextField(
        controller: titleEditingController,
        decoration: InputDecoration(hintText: "new Group Name"),
      ),
    );
  }

  void addIdToUser(String id) async {
    var u = (groupUser);
    // print("!!!!");
    // print("added $id");
    await Auth.addIdToUser(u, id);
  }

  void showMaxGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Could not create group!"),
        content: Text("You can't have more that 10 groups!"),
      ),
    );
  }
}
