import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/repositories/diary_repository.dart';
import '../datasources/diary_local_data_source.dart';
import '../models/diary_entry_model.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryLocalDataSource localDataSource;

  DiaryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<DiaryEntry>>> getEntries() async {
    try {
      final localEntries = await localDataSource.getLastEntries();
      return Right(localEntries);
    } catch (e) {
      return const Left(CacheFailure('Error loading diary entries'));
    }
  }

  @override
  Future<Either<Failure, void>> addEntry(DiaryEntry entry) async {
    try {
      final currentEntries = await localDataSource.getLastEntries();
      // Remove existing entry for same date to allow updates
      currentEntries.removeWhere((e) =>
          e.date.year == entry.date.year &&
          e.date.month == entry.date.month &&
          e.date.day == entry.date.day);

      currentEntries.add(DiaryEntryModel.fromEntity(entry));
      await localDataSource.cacheEntries(currentEntries);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Error adding diary entry'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(DiaryEntry entry) async {
    try {
      final currentEntries = await localDataSource.getLastEntries();
      currentEntries.removeWhere((e) =>
          e.date.millisecondsSinceEpoch == entry.date.millisecondsSinceEpoch);
      await localDataSource.cacheEntries(currentEntries);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Error deleting diary entry'));
    }
  }
}
