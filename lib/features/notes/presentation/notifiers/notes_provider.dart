import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_notes.dart';

class NotesProvider extends ChangeNotifier {
  final GetNotes getNotes;
  final AddNote addNote;
  final DeleteNote deleteNote;

  List<Note> _notes = [];
  List<Note> get notes => _notes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  NotesProvider({
    required this.getNotes,
    required this.addNote,
    required this.deleteNote,
  });

  Future<void> loadNotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getNotes(NoParams());

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (notesList) {
        _notes = notesList;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> add(Note note) async {
    _isLoading = true;
    notifyListeners();

    final result = await addNote(note);

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (_) async {
        await loadNotes();
      },
    );
  }

  Future<void> delete(Note note) async {
    final result = await deleteNote(note);

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) async {
        await loadNotes();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is CacheFailure) {
      return failure.message;
    }
    return 'Unexpected Error';
  }
}
