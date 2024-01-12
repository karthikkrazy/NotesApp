import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sample/Model/Note.dart';
import 'package:sample/View/MyApp.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  runApp(MyApp());
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      title: reader.read(),
      content: reader.read(),
      imagePath: reader.read(),
      timeCreated: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.title);
    writer.write(obj.content);
    writer.write(obj.imagePath);
    writer.write(obj.timeCreated);
  }
}
