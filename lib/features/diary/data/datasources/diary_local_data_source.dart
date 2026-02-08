import 'dart:convert';
import '../../../../core/error/failures.dart';
import '../../../../core/services/local_storage_service.dart';
import '../models/diary_entry_model.dart';

abstract class DiaryLocalDataSource {
  Future<List<DiaryEntryModel>> getLastEntries();
  Future<void> cacheEntries(List<DiaryEntryModel> entries);
}

const String CACHED_DIARY_ENTRIES = 'diary_entries';

class DiaryLocalDataSourceImpl implements DiaryLocalDataSource {
  final LocalStorageService localStorageService;

  DiaryLocalDataSourceImpl({required this.localStorageService});

  @override
  Future<List<DiaryEntryModel>> getLastEntries() async {
    final jsonString = localStorageService.getData(CACHED_DIARY_ENTRIES);
    if (jsonString != null) {
      try {
        final List decoded = jsonDecode(jsonString);
        return decoded.map((e) => DiaryEntryModel.fromJson(e)).toList();
      } catch (e) {
        throw const CacheFailure('Data format exception');
      }
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheEntries(List<DiaryEntryModel> entries) async {
    final jsonString = jsonEncode(entries.map((e) => e.toJson()).toList());
    await localStorageService.saveData(CACHED_DIARY_ENTRIES, jsonString);
  }
}
