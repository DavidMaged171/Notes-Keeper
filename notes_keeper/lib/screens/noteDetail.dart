import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_keeper/models/note.dart';
import 'package:notes_keeper/screens/note_list.dart';
import 'package:notes_keeper/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note,this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note,this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {

  String appBarTitle;
   Note note;
  NoteDetailState(this.note,this.appBarTitle);
  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper=DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text=note.title;
    descriptionController.text=note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10, right: 10),
        child: ListView(
          children: [
            //First Element
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: textStyle,
                value: getPriorityAsString(note.priority),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    print("User Selected $valueSelectedByUser");
                    updatePriorityAsInt(valueSelectedByUser);
                  });
                },
              ),
            ),
            //Second Element
            Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  print('Something changed in Title textField');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelStyle: textStyle,
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            //Third Element
            Padding(
              padding: EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  print('Something changed in Title textField');
                  updatedescription();
                },
                decoration: InputDecoration(
                    labelStyle: textStyle,
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            //Fourth Element
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          print('Save Button Clicked');
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(width: 5),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          print('Delete Button Clicked');
                          _delete();
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  //Convert string priority to int
  void updatePriorityAsInt(String value)
  {
    if(value=="High")
      note.priority=1;
    else
      note.priority=2;
  }
  //Convert int priority to String
  String getPriorityAsString(int value)
  {
    if(value==1)
      return _priorities[0];//High
    else
      return _priorities[1];//Low
  }
  //Update the title of note object
  void updateTitle()
  {
    note.title=titleController.text;
  }
  //Update the description of note object
  void updatedescription()
  {
    note.description=descriptionController.text;
  }

  void _save()async
  {
    moveToLastScreen();
    note.date=DateFormat.yMMM().format(DateTime.now());
    int result;
    if(note.id!=null)//Update Operation
      {
        result= await helper.updateNote(note);
      }
    else//Insert Operation
      {
        result= await helper.insertNote(note);
      }
    if(result !=0)
      {
        _showAlertDialog("Note Saved Successfully");
      }
    else
      {
        _showAlertDialog("Problem Saving Note");
      }
  }
  void _showAlertDialog(String message,[String title = "Status"])
  {
    AlertDialog alertDialog =AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_)=>alertDialog);
  }
  void _delete()async
  {
    moveToLastScreen();
    if(note.id==null)
      {
        _showAlertDialog("No Note To Delete");
        return;
      }
    int result=await helper.deleteNote(note.id);
    if(result!=0)
      {
        _showAlertDialog("Note Deleted Successfully");
      }
    else{
      _showAlertDialog("Error Occured while Deleting Note");
    }
  }

}
