// ignore_for_file: file_names, unused_local_variable, dead_code, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_pad/Helper/DatabaseHelper.dart';
import 'package:note_pad/Model/model.dart';
import 'package:note_pad/Screens/NoteDetail.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {


  int count = 0;
  List<Note> noteList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    
      updateListView();
      
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const NoteList()));
                }),
            title: const Text('Notes'),
            backgroundColor: Colors.orange,
          ),
          body: getLists(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              navigateToDetail(Note('','',2), 'Add Note');
            },
            tooltip: 'Add note',
            child: const Icon(Icons.add),
          ),
        );
  }

  ListView getLists() {
    TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .headlineMedium;


    return ListView.builder(
    physics:const BouncingScrollPhysics(),
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            margin: const EdgeInsets.all(5.0),
            elevation: 5.0,
            child:ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(noteList[position].priority),
                child: getPriorityIcon(noteList[position].priority),
              ),
              title: Text(noteList[position].title),
              subtitle: Text(noteList[position].date),
              trailing: GestureDetector(
                child: const Icon(Icons.delete, color: Colors.grey,),
                onTap: (){
                  _delete(context, noteList[position]);
                },
              ),
              onTap: () {
                navigateToDetail(noteList[position], 'Edit note');
              },
            )
          );
        }
    );
  }
  //get priority color
  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.yellow;
        break;
      case 2:
        return Colors.red;
        break;
      default:
        return Colors.yellow;
    }
  }
  //get priority icon
  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return const Icon(Icons.play_arrow);
        break;
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }
  //delete note
  void _delete(BuildContext context, Note note) async{
      int result  = await databaseHelper.deleteNote(note.id!);
      if(result!=0){
        _showSnackBar(context,'Note deleted successfully');
        updateListView();
      }
  }
  void _showSnackBar(BuildContext context, String s) {
    final snackBAr = SnackBar(content: Text(s));
    Scaffold.of(context).showBottomSheet((context) => snackBAr);
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((datbase) async {
      List<Note> noteList = await databaseHelper.getNoteList();
         setState(() {
           this.noteList = noteList;
           count = noteList.length;
         });
     
    });
  }
  void navigateToDetail(Note note , String title)async{
    bool? result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteDetail(note,title)));
    if(result==true){
      updateListView();
    }
  }
}


