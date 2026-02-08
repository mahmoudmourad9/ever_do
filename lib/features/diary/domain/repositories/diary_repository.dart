import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/diary_entry.dart';

abstract class DiaryRepository {
  Future<Either<Failure, List<DiaryEntry>>> getEntries();
  Future<Either<Failure, void>> addEntry(DiaryEntry entry);
  Future<Either<Failure, void>> deleteEntry(DiaryEntry entry);
}
