import 'dart:core';
import 'package:notes_keeper/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper
{
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper

  static Database _database;             // Singleton Database

  String noteTable="note_table",colId="id",colTitle='title',colDescription='description';
  String colPriority='priority',colDate='date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper()
  {
    if(_databaseHelper == null )
      {
        _databaseHelper=DatabaseHelper._createInstance();
      }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database==null)
      {
        _database=await initializeDatabase();
      }
    return _database;
  }

  Future<Database> initializeDatabase()async
  {
    //Get the directory path for android and ios to store the database
    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path + 'notes+db';
    //open / create database the database at a given directory
    var notesDB= openDatabase(path,version: 1,onCreate: _createDatabase);
    return notesDB;
  }

  void _createDatabase(Database db,int newVersion) async
  {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }
  //Fetch Operation: Get all note objects from database
  Future<List<Map<String,dynamic>>> getNoteMapList()async
  {
    Database db=await this.database;
    var result= await db.rawQuery('select * from $noteTable order by $colPriority ASC');
    return result;
  }
  //Insert Operation: insert a note object and save it to a database
  Future <int>insertNote(Note note)async
  {
    Database db =await this.database;
    var result= await db.insert(noteTable, note.toMap());
    return result;
  }
  //Update Operation: Update a note object and save it to a database
  Future<int> updateNote (Note note) async {
    var db= await this.database;
    var result= await db.update(noteTable, note.toMap(),where: '$colId= ?',whereArgs: [note.id]);
    return result;
  }
  //Delete Operation: Delete a note object
  Future<int> deleteNote (int id) async {
    var db= await this.database;
    var result= await db.rawDelete('Delete from $noteTable where $colId=$id');
    return result;
  }

  //Get number of note objects in database
  Future <int>getCount() async
  {
    var db= await this.database;
    List<Map<String,dynamic>> count=await db.rawQuery('select count (*) from $noteTable');

    int result =Sqflite.firstIntValue(count);
    return result;
  }
  //Get the 'MapList' List<Map> and convert it to note list
  Future<List<Note>>getNoteList() async{
    var noteMapList = await getNoteMapList();
    int count =noteMapList.length;
    //print(count);
    List<Note> noteList=List<Note>();
    for(int i=0;i<count;i++)
     {
        noteList.add(Note.fromMapObject(noteMapList[i]));
     }
  return noteList;
  }

}

