import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

class DeleteDiaryEntry implements UseCase<void, DiaryEntry> {
  final DiaryRepository repository;

  DeleteDiaryEntry(this.repository);

  @override
  Future<Either<Failure, void>> call(DiaryEntry params) async {
    return await repository.deleteEntry(params);
  }
}
