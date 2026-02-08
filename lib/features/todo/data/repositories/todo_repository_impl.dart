import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final localTodos = await localDataSource.getLastTodos();
      return Right(localTodos);
    } catch (e) {
      return const Left(CacheFailure('Error loading todos'));
    }
  }

  @override
  Future<Either<Failure, void>> addTodo(Todo todo) async {
    try {
      final currentTodos = await localDataSource.getLastTodos();
      currentTodos.add(TodoModel.fromEntity(todo));
      await localDataSource.cacheTodos(currentTodos);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Error adding todo'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTodo(Todo todo) async {
    try {
      final currentTodos = await localDataSource.getLastTodos();
      final index = currentTodos.indexWhere((element) => element.id == todo.id);
      if (index != -1) {
        currentTodos[index] = TodoModel.fromEntity(todo);
        await localDataSource.cacheTodos(currentTodos);
        return const Right(null);
      } else {
        return const Left(CacheFailure('Todo not found'));
      }
    } catch (e) {
      return const Left(CacheFailure('Error updating todo'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(Todo todo) async {
    try {
      final currentTodos = await localDataSource.getLastTodos();
      currentTodos.removeWhere((element) => element.id == todo.id);
      await localDataSource.cacheTodos(currentTodos);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Error deleting todo'));
    }
  }
}
