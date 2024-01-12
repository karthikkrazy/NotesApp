import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/Controller/NoteController.dart';
import 'package:sample/Model/Note.dart';
import 'package:share_plus/share_plus.dart';

class NoteCreatePage extends StatefulWidget {
  final Note? note;

  NoteCreatePage({this.note});

  @override
  _NoteCreatePageState createState() => _NoteCreatePageState();
}

class _NoteCreatePageState extends State<NoteCreatePage> {
  final NoteController noteController = Get.find();
  late TextEditingController titleController;
  late TextEditingController contentController;
  String? imagePath;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
    imagePath = widget.note?.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          widget.note == null ? 'Create Note' : 'Update Note',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.josefinSans().fontFamily ?? "Roboto",
              fontSize: 20.0, // adjust the size as needed
              color: Colors.white),
        ),
        actions: <Widget>[
          if (widget.note != null)
            IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  if (imagePath != null) {
                    Share.shareFiles([imagePath!],
                        text:
                            '${titleController.text}\n${contentController.text}');
                  } else {
                    Share.share(
                        '${titleController.text}\n${contentController.text}');
                  }
                }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                " Title",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black))),
                controller: titleController,
              ),
              SizedBox(height: 20),
              Text(
                " Content",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black))),
                maxLines: 10,
                // maxLength: 200,
                keyboardType: TextInputType.multiline,
                controller: contentController,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Attach Image'),
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        if (pickedFile.mimeType == null ||
                            pickedFile.mimeType!.startsWith('image/')) {
                          setState(() {
                            imagePath = pickedFile.path;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Only images allowed')),
                          );
                        }
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Text('Take Photo'),
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        if (pickedFile.mimeType == null ||
                            pickedFile.mimeType!.startsWith('image/')) {
                          setState(() {
                            imagePath = pickedFile.path;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Only images allowed')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (errorMessage != null)
                Text(
                  'Error: $errorMessage',
                  style: TextStyle(color: Colors.red),
                ),
              if (imagePath != null)
                Container(
                  width: 200.0,
                  height: 200.0,
                  child: Image.file(File(Uri.parse(imagePath!).path),
                      fit: BoxFit.contain),
                ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        // color: Colors.teal,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  18.0), // adjust the border radius as needed
            ),
          ),
          onPressed: () {
            if (widget.note == null) {
              noteController.addNote(Note(
                title: titleController.text,
                content: contentController.text,
                imagePath: imagePath,
                timeCreated: DateTime.now(),
              ));
            } else {
              noteController.updateNote(
                widget.note!,
                Note(
                  title: titleController.text,
                  content: contentController.text,
                  imagePath: imagePath,
                  timeCreated: DateTime.now(),
                ),
              );
            }
            Get.back();
          },
          child: Text(
            widget.note == null ? 'ADD NOTE' : 'UPDATE NOTE',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: GoogleFonts.josefinSans().fontFamily ?? "Roboto"),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
