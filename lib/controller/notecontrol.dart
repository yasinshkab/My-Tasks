import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task_control/model/note_model.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;
  final _prefs = SharedPreferences.getInstance();

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  void loadNotes() async {
    final prefs = await _prefs;
    final notesData = prefs.getStringList('notes');
    if (notesData != null) {
      notes.value = notesData.map((noteString) {
        return Note.fromJsonString(noteString);
      }).toList();
    }
  }

  void saveNotes() async {
    final prefs = await _prefs;
    final notesData = notes.map((note) => note.toJsonString()).toList();
    prefs.setStringList('notes', notesData);
  }

  void addNote({
    required String title,
    required String description,
    required Color color,
  }) {
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      color: color,
    );
    notes.add(newNote);
    saveNotes();
  }

  void deleteNote(int id) {
    notes.removeWhere((note) => note.id == id);
    saveNotes();
  }

  //   void editNote({
  //   required String title,
  //   required String description,
  //   required Color color,
  // }) {
  //   final newNote = Note(
  //     id: DateTime.now().millisecondsSinceEpoch,
  //     title: title,
  //     description: description,
  //     color: color,
  //   );
  //   notes.u(newNote);
  //   saveNotes();
  // }
  void updateNote(Note updatedNote) {
    final index = notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      saveNotes(); // Save the updated list to SharedPreferences
    }
  }
}
