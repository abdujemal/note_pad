// ignore_for_file: prefer_conditional_assignment, file_names

import 'dart:io';
import 'package:note_pad/Model/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  String noteTable = 'note_table',
  colId = 'id',
  colTitle = 'title',
  colDescription = 'description',
  colPriority = 'priority',
  colDate = 'date';
  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    if(_databaseHelper==null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';

    var notesDatabase = await openDatabase(path,version: 1,onCreate: _createDb);
    return notesDatabase;
  }

  Future<Database?> get database async {
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  //creating database
  void _createDb(Database db,int newVersion) async{
    await db.execute(
        'CREATE TABLE $noteTable('
            '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
            ' $colTitle TEXT,'
            '$colDescription TEXT,'
            ' $colPriority INTEGER,'
            '$colDate TEXT)'
    );
  }
  //geting data
  Future<List<Map<String,dynamic>>> getNoteMapList() async {
    Database? db = await database;

    var result = await db!.query(noteTable,orderBy: '$colPriority ASC' );
    return result;
  }
  //inserting data
  Future<int> insertNote(Note note) async{
    Database? db = await database;
    var result = await db!.insert(noteTable,note.toMap());
    return result;
  }
  //update data
  Future<int> updateNote(Note note) async{
    var db = await database;
    var result = await db!.update(noteTable,note.toMap(),where: '$colId = ?',whereArgs: [note.id]);
    return result;
  }
  //deleta data
  Future<int> deleteNote(int id) async{
    var db = await database;
    var result = await db!.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }
  //get number of datas present in the daata base
  Future<int> getCount() async {
    Database? db = await database;
    List<Map<String,dynamic>> x = await db!.rawQuery('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }
  //get the map list
  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = [];
    for (int i = 0; i < count;i++){
      noteList.add(Note.fromMapToObject(noteMapList[i]));
    }
    return noteList;
  }

}