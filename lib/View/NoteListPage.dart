import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/Controller/NoteController.dart';
import 'package:sample/Model/Note.dart';
import 'package:sample/View/NoteCreatePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final NoteController noteController = Get.put(NoteController());
  final Set<Note> selectedNotes = {};
  // Define your color list
  List<Color?> colors = [
    Colors.purple[50],
    Colors.yellow[50],
    Colors.teal[50],
    Colors.cyan[50],
    Colors.lime[50],
    Colors.pink[50],
    Colors.indigo[50],
    Colors.blue[50],
    Colors.orange[50],
    Colors.green[50],
    Colors.yellow[50],
    Colors.purple[50],
    Colors.orange[50],
    Colors.pink[50],
    Colors.teal[50],
    Colors.cyan[50],
    Colors.lime[50],
    Colors.indigo[50]
  ];

  Future<void> deleteSelectedNotes() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete Selected Notes'),
          content: Text('Are you sure you want to delete the selected notes?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                noteController.deleteNotes(selectedNotes);
                setState(() {
                  selectedNotes.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/images/noteicon2.png'),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'NOTES APP',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.josefinSans().fontFamily ?? "Roboto",
                fontSize: 20.0, // adjust the size as needed
                color: Colors.white),
          ),
        ),
        actions: <Widget>[
          if (selectedNotes.isNotEmpty)
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.delete),
              onPressed: deleteSelectedNotes,
            ),
        ],
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: noteController.notes.length == 0
              ? Center(
                  child: Container(
                      height: 250,
                      width: 250,
                      child: Image.asset('assets/images/handnotes.png')),
                )
              : ListView.builder(
                  itemCount: noteController.notes.length,
                  itemBuilder: (_, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: <Widget>[
                          SlidableAction(
                            onPressed: (context) {
                              noteController
                                  .deleteNote(noteController.notes[index]);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Container(
                        height: 100,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: selectedNotes
                                  .contains(noteController.notes[index])
                              ? Colors.red
                              : colors[index % colors.length],
                          child: ListTile(
                            // leading: Icon(Icons.event_note, color: Colors.deepPurple),
                            title: Text(
                              "${noteController.notes[index].title}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "${noteController.notes[index].content?.split('\n')[0]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            trailing: Text(
                              "${DateFormat('MMM d, y').format(noteController.notes[index].timeCreated!)}\n    ${DateFormat('h:mm a').format(noteController.notes[index].timeCreated!)}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              if (selectedNotes.isEmpty) {
                                Get.to(NoteCreatePage(
                                    note: noteController.notes[index]));
                              } else {
                                setState(() {
                                  if (selectedNotes
                                      .contains(noteController.notes[index])) {
                                    selectedNotes
                                        .remove(noteController.notes[index]);
                                  } else {
                                    selectedNotes
                                        .add(noteController.notes[index]);
                                  }
                                });
                              }
                            },
                            onLongPress: () {
                              setState(() {
                                if (selectedNotes
                                    .contains(noteController.notes[index])) {
                                  selectedNotes
                                      .remove(noteController.notes[index]);
                                } else {
                                  selectedNotes
                                      .add(noteController.notes[index]);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Get.to(NoteCreatePage()),
      ),
    );
  }
}
