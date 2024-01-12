import 'package:get/get.dart';
import 'package:sample/Model/Note.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;
  late Box<Note> noteBox;

  @override
  void onInit() async {
    super.onInit();
    noteBox = await Hive.openBox<Note>('notes');
    notes.addAll(noteBox.values);
  }

  @override
  void onClose() {
    noteBox.close();
    super.onClose();
  }

  void addNote(Note note) {
    notes.add(note);
    noteBox.add(note);
  }

  void deleteNotes(Set<Note> notesToDelete) {
    var notesToDeleteCopy = Set<Note>.from(notesToDelete);
    for (var note in notesToDeleteCopy) {
      int index = notes.indexOf(note);
      if (index != -1) {
        notes.removeAt(index);
        noteBox.deleteAt(index);
      }
    }
  }

  void deleteNote(Note note) {
    notes.remove(note);
    noteBox.deleteAt(notes.indexOf(note));
  }

  void updateNote(Note oldNote, Note newNote) {
    int index = notes.indexOf(oldNote);
    notes[index] = newNote;
    noteBox.putAt(index, newNote);
  }
}
