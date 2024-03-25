import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/note/note_class.dart';

import '../../clients/client_class.dart';

class NotesManager{

  static List<Note> notesList = [];

  static void updateNoteList(DataSnapshot snapshot){

    notesList.clear();

    for (var idFolder in snapshot.children){

      Note tempNote = Note.fromSnapshot(idFolder);
      if(tempNote.id != '') notesList.add(tempNote);

    }
  }

  static void replaceChangedClientItem(Note note){
    for (int i = 0; i<notesList.length; i++){
      if (notesList[i].id == note.id){
        notesList[i] = note;
      }
    }
  }

  static void removeFromNotesList(String id){
    notesList.removeWhere((element) => element.id == id);
  }

  static Note getNoteFromList(String id){
    for (int i = 0; i<notesList.length; i++){
      if (notesList[i].id == id) return notesList[i];
    }
    return Note.empty();
  }

  static List<Note> getNotesListForDeal(String dealId){
    List<Note> tempList = [];
    for (int i = 0; i<notesList.length; i++){
      if (notesList[i].idEntity == dealId) tempList.add(notesList[i]);
    }
    return tempList;
  }

}