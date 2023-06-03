// ignore_for_file: no_logic_in_create_state, file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_pad/Helper/DatabaseHelper.dart';
import 'package:note_pad/Model/model.dart';

class NoteDetail extends StatefulWidget {
  final String title;

  final Note note;

  const NoteDetail(this.note, this.title, {super.key});
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(note, title);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static Set<String> priorities = {'High', 'Low'};
  TextEditingController titleController = TextEditingController(),
      desscriptionComtroller = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  String title;
  Note note;
  final _formKey = GlobalKey<FormState>();
  NoteDetailState(this.note, this.title);
  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.titleMedium;

    titleController.text = note.title;
    desscriptionComtroller.text = note.description ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ListTile(
                    title: DropdownButton(
                      items: priorities
                          .map((e) => DropdownMenuItem<String>(
                              value: e, child: Text(e)))
                          .toList(),
                      onChanged: (String? v) {
                        setState(() {
                          updatePriorityAsInt(v!);
                        });
                      },
                      value: updatePriorityAsString(note.priority),
                      style: textStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (String v) {
                        updateTitle();
                      },
                      validator: (String? v) {
                        if (v!.isEmpty) {
                          return 'Man you gotta write some thing';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: 'Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      controller: desscriptionComtroller,
                      style: textStyle,
                      onChanged: (String v) {
                        updateDescription();
                      },
                      validator: (String? v) {
                        if (v!.isEmpty) {
                          return 'Man you gotta write some thing';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text(note.id == null ? 'Save' : "update"),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState!.validate()) {
                                  save();
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              setState(() {
                                delete();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ))),
    );
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String? updatePriorityAsString(int value) {
    String? priority;
    switch (value) {
      case 1:
        priority = 'High';
        break;
      case 2:
        priority = 'Low';
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = desscriptionComtroller.text;
  }

  void save() async {
    Navigator.pop(context, true);

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await databaseHelper.updateNote(note);
    } else {
      result = await databaseHelper.insertNote(note);
    }
    if (result != 0) {
      showAlert('Status', 'Note saved successfully!');
    } else {
      showAlert('Status', 'Problem occurred while saving note!');
    }
  }

  void showAlert(String title, String body) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(body),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void delete() async {
    Navigator.pop(context, true);

    if (note.id == null) {
      showAlert('Status', 'Please write some thing');
      return;
    }
    if (note.id != null) {
      int result = await databaseHelper.deleteNote(note.id!);

      if (result != 0) {
        showAlert('Status', 'Note deleted successfully!');
      } else {
        showAlert('Status', 'Problem occurred while deleting note!');
      }
    }
  }
}
