import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes_keeper/models/note.dart';
import 'package:notes_keeper/screens/noteDetail.dart';
import 'package:notes_keeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<Note>noteList;

  int count = 0;

  @override
  Widget build(BuildContext context) {
    if(noteList==null)
      {
        noteList=List<Note>();
        updateListView();
      }
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FAB Tabbed');
          navigatetoDetail(Note('', '' , 2 ),'Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(
              this.noteList[position].title,
              style: titleStyle,
            ),
            subtitle: Text(this.noteList[position].date),
            
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: (){
                _delete(context,noteList[position]);
              },
            ),
            onTap: () {
              print("List Tile Tapped");
              navigatetoDetail(this.noteList[position],'Edit Note');
            },
          ),
        );
      },
    );
  }
  void navigatetoDetail(Note note,String title) async
  {
    bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(note,title);

    }),);
    if (result== true){
      updateListView();
    }
  }
  Color getPriorityColor(int value)
  {
    if(value==1)
      return Colors.red;
    else
      return Colors.green;
  }
  Icon getPriorityIcon(int value)
  {
    if(value==1)
      return Icon(Icons.play_arrow);
    else
      return Icon(Icons.keyboard_arrow_right);
  }
  void _delete(BuildContext context,Note note)async
  {
    int result =await databaseHelper.deleteNote(note.id);
    if(result!=0)
      {
        _showSnackBar(context,'Note Deleted Successfully');
        updateListView();
      }
  }
  void _showSnackBar(BuildContext context,String message)
  {
    final snackbar=SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);
  }
  void updateListView()
  {
    final Future<Database> dbfuture=databaseHelper.initializeDatabase();
    dbfuture.then((database){
      Future <List<Note>>noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList=noteList;
          this.count=noteList.length;
        });
      });
    });
  }
}
