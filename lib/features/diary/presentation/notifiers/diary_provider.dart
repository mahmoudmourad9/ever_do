import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/diary_entry.dart';
import '../../domain/usecases/add_diary_entry.dart';
import '../../domain/usecases/delete_diary_entry.dart';
import '../../domain/usecases/get_diary_entries.dart';

class DiaryProvider extends ChangeNotifier {
  final GetDiaryEntries getDiaryEntries;
  final AddDiaryEntry addDiaryEntry;
  final DeleteDiaryEntry deleteDiaryEntry;

  List<DiaryEntry> _entries = [];
  List<DiaryEntry> get entries => _entries;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DiaryProvider({
    required this.getDiaryEntries,
    required this.addDiaryEntry,
    required this.deleteDiaryEntry,
  });

  Future<void> loadEntries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getDiaryEntries(NoParams());

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
      },
      (entriesList) {
        _entries = entriesList;
        // Sort by date descending
        _entries.sort((a, b) => b.date.compareTo(a.date));
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> add(DiaryEntry entry) async {
    final result = await addDiaryEntry(entry);

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) async {
        await loadEntries();
      },
    );
  }

  Future<void> delete(DiaryEntry entry) async {
    final result = await deleteDiaryEntry(entry);

    result.fold(
      (failure) {
        _errorMessage = _mapFailureToMessage(failure);
        notifyListeners();
      },
      (_) async {
        await loadEntries();
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
