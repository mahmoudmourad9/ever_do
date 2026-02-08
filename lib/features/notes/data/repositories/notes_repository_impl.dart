import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_data_source.dart';
import '../models/note_model.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;

  NotesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final localNotes = await localDataSource.getLastNotes();
      return Right(localNotes);
    } catch (e) {
      return const Left(CacheFailure('Error loading notes'));
    }
  }

  @override
  Future<Either<Failure, void>> addNote(Note note) async {
    try {
      final currentNotes = await localDataSource.getLastNotes();
      currentNotes.add(NoteModel.fromEntity(note));
      await localDataSource.cacheNotes(currentNotes);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Error adding note'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(Note note) async {
    try {
      final currentNotes = await localDataSource.getLastNotes();
      // Using date/title/text combination for equality check since we lack IDs
      currentNotes.removeWhere((n) =>
          n.date.millisecondsSinceEpoch == note.date.millisecondsSinceEpoch &&
          n.title == note.title &&
          n.text == note.text);
      await localDataSource.cacheNotes(currentNotes);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Error deleting note'));
    }
  }
}
