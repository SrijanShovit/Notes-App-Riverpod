import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends ChangeNotifier {
  List notesList = [];

  void onSaveNote(String note) {
    notesList.add(note);
    notifyListeners();
  }

  void onDeleteNote(int index) {
    notesList.removeAt(index);
    notifyListeners();
  }
}

//using notesProvider we can listen to changes wherever we need
final notesProvider =
    ChangeNotifierProvider<NotesNotifier>((ref) => NotesNotifier());
