import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/diary_entry.dart';
import '../repositories/diary_repository.dart';

class GetDiaryEntries implements UseCase<List<DiaryEntry>, NoParams> {
  final DiaryRepository repository;

  GetDiaryEntries(this.repository);

  @override
  Future<Either<Failure, List<DiaryEntry>>> call(NoParams params) async {
    return await repository.getEntries();
  }
}
