import 'package:flutter/material.dart';
import 'package:group_notes/services/data.dart';

class NotePage extends StatelessWidget {
  NotePage({required this.id, required this.data}){
    notesController.text = data.value;
  }

  MapEntry<String, String> data;

  String id;

  TextEditingController notesController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async{
          var g = await Data.getGroup(id);
          g!;
          g.notes[data.key] = notesController.text; 

          await Data.setGroup(id, g);
          

          Navigator.pop(context);
        },
      ) ,
      appBar: AppBar(
        title: Text(data.key),
      ),
      body: Hero(
        tag: data.key,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(padding: EdgeInsets.all(20)),
                Text("Notes:"),
                TextField(
                  controller: notesController,
                  // expands: true,
                  maxLines: 20,
                  minLines: 3,
                  decoration: InputDecoration(
                      hintText: 'notes', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
