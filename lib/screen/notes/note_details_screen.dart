import 'package:everdo_app/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:provider/provider.dart';

class NoteDetailsScreen extends StatelessWidget {
  final Note note;

  const NoteDetailsScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final backgroundColor =
        isDarkMode ? const Color(0xFF14242B) : const Color(0xFFEAF9FC);
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;

    final secondaryTextColor =
        isDarkMode ? Colors.grey.shade400 : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        backgroundColor: const Color(0xFF004A63),
        foregroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${note.date.day}/${note.date.month}/${note.date.year}',
                style: TextStyle(fontSize: 16, color: secondaryTextColor),
              ),
              const SizedBox(height: 20),
              Text(
                note.text,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  color: primaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
