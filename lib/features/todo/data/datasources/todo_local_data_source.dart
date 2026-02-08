import 'dart:convert';
import '../../../../core/error/failures.dart';
import '../../../../core/services/local_storage_service.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getLastTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
}

const String CACHED_TODOS = 'todo_list';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final LocalStorageService localStorageService;

  TodoLocalDataSourceImpl({required this.localStorageService});

  @override
  Future<List<TodoModel>> getLastTodos() async {
    final jsonString = localStorageService.getData(CACHED_TODOS);
    if (jsonString != null) {
      try {
        final List decoded = jsonDecode(jsonString);
        return decoded.map((e) => TodoModel.fromJson(e)).toList();
      } catch (e) {
        throw const CacheFailure('Data format exception');
      }
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    final jsonString = jsonEncode(todos.map((e) => e.toJson()).toList());
    await localStorageService.saveData(CACHED_TODOS, jsonString);
  }
}
