import 'dart:convert';
import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:everdo_app/models/note_model.dart';
import 'package:everdo_app/widget/AppBar%20.dart';
import 'package:everdo_app/widget/NoteList.dart';
import 'package:everdo_app/widget/_DeleteConfirmationDialog.dart';
import 'package:everdo_app/widget/_EmptyState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_details_screen.dart';

class NotesScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const NotesScreen({
    super.key,
    this.onToggleTheme,
    required Function(bool p1) onThemeChanged,
  });

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void refreshNotes() {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notes');
    if (data != null) {
      try {
        final List decoded = jsonDecode(data);
        notes = decoded.map((e) => Note.fromMap(e)).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        if (mounted) setState(() {});
      // ignore: empty_catches
      } catch (e) {
       
      }
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(notes.map((e) => e.toMap()).toList());
    await prefs.setString('notes', data);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final cardColor =
        isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryTextColor =
        isDarkMode ? Colors.grey.shade400 : Colors.black54;

    final backgroundGradientColors = isDarkMode
        ? [const Color(0xFF0E1A1F), const Color(0xFF1E2C33)]
        : [const Color(0xFFA8E8F2), const Color(0xFFEAF9FC)];

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundGradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const costmAppbar(
                titel: 'الملاحظات',
              ),
              Expanded(
                child: notes.isEmpty
                    ? EmptyState(
                        isDarkMode: isDarkMode,
                        textColor: textColor,
                      )
                    : NoteList(
                        notes: notes,
                        cardColor: cardColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        onNoteTapped: (index) => _handleNoteTap(context, index),
                        onNoteLongPressed: (index) => _handleDelete(context,
                            index, cardColor, textColor, secondaryTextColor),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleNoteTap(BuildContext context, int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteDetailsScreen(note: notes[index]),
      ),
    );

    if (result != null) {
      setState(() {
        notes[index] = Note.fromMap(result);
      });
      await _saveNotes();
    }
  }

  Future<void> _handleDelete(BuildContext context, int index, Color cardColor,
      Color textColor, Color secondaryTextColor) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        cardColor: cardColor,
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
      ),
    );
    if (confirm == true) {
      notes.removeAt(index);
      await _saveNotes();
      setState(() {});
    }
  }
}
