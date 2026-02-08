import 'package:everdo_app/Providers/theme_provider.dart';
import 'package:everdo_app/core/services/local_storage_service.dart';
import 'package:everdo_app/features/diary/data/datasources/diary_local_data_source.dart';
import 'package:everdo_app/features/diary/data/repositories/diary_repository_impl.dart';
import 'package:everdo_app/features/diary/domain/usecases/add_diary_entry.dart';
import 'package:everdo_app/features/diary/domain/usecases/delete_diary_entry.dart';
import 'package:everdo_app/features/diary/domain/usecases/get_diary_entries.dart';
import 'package:everdo_app/features/diary/presentation/notifiers/diary_provider.dart';
import 'package:everdo_app/features/notes/data/datasources/notes_local_data_source.dart';
import 'package:everdo_app/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:everdo_app/features/notes/domain/usecases/add_note.dart';
import 'package:everdo_app/features/notes/domain/usecases/delete_note.dart';
import 'package:everdo_app/features/notes/domain/usecases/get_notes.dart';
import 'package:everdo_app/features/notes/presentation/notifiers/notes_provider.dart';
import 'package:everdo_app/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:everdo_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:everdo_app/features/todo/domain/usecases/add_todo.dart';
import 'package:everdo_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:everdo_app/features/todo/domain/usecases/get_todos.dart';
import 'package:everdo_app/features/todo/domain/usecases/update_todo.dart';
import 'package:everdo_app/features/todo/presentation/notifiers/todo_provider.dart';
import 'package:everdo_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services
  final localStorageService = LocalStorageServiceImpl();
  await localStorageService.init();

  // Notes Feature Dependencies
  final notesLocalDataSource =
      NotesLocalDataSourceImpl(localStorageService: localStorageService);
  final notesRepository =
      NotesRepositoryImpl(localDataSource: notesLocalDataSource);
  final getNotes = GetNotes(notesRepository);
  final addNote = AddNote(notesRepository);
  final deleteNote = DeleteNote(notesRepository);

  // ToDo Feature Dependencies
  final todoLocalDataSource =
      TodoLocalDataSourceImpl(localStorageService: localStorageService);
  final todoRepository =
      TodoRepositoryImpl(localDataSource: todoLocalDataSource);
  final getTodos = GetTodos(todoRepository);
  final addTodo = AddTodo(todoRepository);
  final updateTodo = UpdateTodo(todoRepository);
  final deleteTodo = DeleteTodo(todoRepository);

  // Diary Feature Dependencies
  final diaryLocalDataSource =
      DiaryLocalDataSourceImpl(localStorageService: localStorageService);
  final diaryRepository =
      DiaryRepositoryImpl(localDataSource: diaryLocalDataSource);
  final getDiaryEntries = GetDiaryEntries(diaryRepository);
  final addDiaryEntry = AddDiaryEntry(diaryRepository);
  final deleteDiaryEntry = DeleteDiaryEntry(diaryRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<LocalStorageService>.value(value: localStorageService),
        ChangeNotifierProvider(
          create: (_) => NotesProvider(
            getNotes: getNotes,
            addNote: addNote,
            deleteNote: deleteNote,
          )..loadNotes(),
        ),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(
            getTodos: getTodos,
            addTodo: addTodo,
            updateTodo: updateTodo,
            deleteTodo: deleteTodo,
          )..loadTodos(),
        ),
        ChangeNotifierProvider(
          create: (_) => DiaryProvider(
            getDiaryEntries: getDiaryEntries,
            addDiaryEntry: addDiaryEntry,
            deleteDiaryEntry: deleteDiaryEntry,
          )..loadEntries(),
        ),
      ],
      child: const EverDoApp(),
    ),
  );
}

class EverDoApp extends StatelessWidget {
  const EverDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EverDo App',
          theme: themeProvider.themeData,
          home: SplashPage(onThemeChanged: themeProvider.toggleTheme),
        );
      },
    );
  }
}
