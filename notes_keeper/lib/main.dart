import 'package:flutter/material.dart';
import 'package:notes_keeper/screens/noteDetail.dart';
import 'package:notes_keeper/screens/note_list.dart';

void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes Keeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: NoteList(),
    );
  }

}
