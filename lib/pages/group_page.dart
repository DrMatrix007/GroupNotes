import 'package:flutter/material.dart';
import 'package:group_notes/models/group.dart';
import 'package:group_notes/models/share_link.dart';
import 'package:group_notes/pages/note_page.dart';
import 'package:group_notes/services/data.dart';
import 'package:share/share.dart';

class GroupPage extends StatelessWidget {
  GroupPage({required this.groupID});

  String groupID;

  TextEditingController titleEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Group?>(
      stream: Data.getGroupStream(groupID),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          var group = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text(group.Name),
            ),
            body: ListView.builder(
              itemCount: group.notes.entries.length + 2,
              itemBuilder: (context, index) {
                if (index == group.notes.entries.length + 1) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          await ShareLink.share(context, groupID);
                        },
                        child: Icon(Icons.share)),
                  );
                }

                if (index == group.notes.entries.length) {
                  return Card(
                    child: ListTile(
                      title: TextField(
                        controller: titleEditingController,
                        decoration: InputDecoration(
                          hintText: 'title',
                          // border: OutlineInputBorder(),
                        ),
                      ),
                      trailing: IconButton(
                        color: Theme.of(context).accentColor,
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          if (group.notes[titleEditingController.text] ==
                              null) {
                            group.notes[titleEditingController.text] = "";

                            await Data.setGroup(groupID, group);
                            titleEditingController.text = "";
                          }
                        },
                      ),
                    ),
                  );
                }
                var current = group.notes.entries.toList()[index];

                String value;
                if (current.value.isEmpty) {
                  value = "\" \"";
                } else if (current.value.length > 20) {
                  value = current.value.substring(0, 20) + "...";
                } else {
                  value = current.value;
                }
                return new Hero(
                  tag: current.key,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(

                        child: ListTile(
                          trailing: IconButton(
                            onPressed: () async {
                              group.notes.remove(current.key);
                              await Data.setGroup(groupID, group);
                            },
                            color: Colors.red,
                            icon: Icon(Icons.delete),
                          ),
                          title: Text(current.key),
                          subtitle: Text(value),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NotePage(id: groupID, data: current),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
