import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class AddNote implements UseCase<void, Note> {
  final NotesRepository repository;

  AddNote(this.repository);

  @override
  Future<Either<Failure, void>> call(Note params) async {
    return await repository.addNote(params);
  }
}
