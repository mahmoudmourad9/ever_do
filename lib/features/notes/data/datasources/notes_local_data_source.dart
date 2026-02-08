import 'dart:convert';
import '../../../../core/error/failures.dart';
import '../../../../core/services/local_storage_service.dart';
import '../models/note_model.dart';

abstract class NotesLocalDataSource {
  Future<List<NoteModel>> getLastNotes();
  Future<void> cacheNotes(List<NoteModel> notes);
}

const String CACHED_NOTES = 'notes';

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  final LocalStorageService localStorageService;

  NotesLocalDataSourceImpl({required this.localStorageService});

  @override
  Future<List<NoteModel>> getLastNotes() async {
    final jsonString = localStorageService.getData(CACHED_NOTES);
    if (jsonString != null) {
      try {
        List decoded = jsonDecode(jsonString);
        return decoded.map((e) => NoteModel.fromJson(e)).toList();
      } catch (e) {
        throw const CacheFailure('Data format exception');
      }
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheNotes(List<NoteModel> notes) async {
    final jsonString = jsonEncode(notes.map((e) => e.toJson()).toList());
    await localStorageService.saveData(CACHED_NOTES, jsonString);
  }
}
