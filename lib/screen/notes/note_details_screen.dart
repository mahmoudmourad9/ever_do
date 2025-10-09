import 'package:everdo_app/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:provider/provider.dart';
import 'add_note_screen.dart';

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
    const buttonColor = Color(0xFF004A63);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الملاحظه'),
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${note.date.day}/${note.date.month}/${note.date.year}',
                style: TextStyle(fontSize: 16, color: secondaryTextColor),
              ),

              const SizedBox(height: 10),

              Text(
                note.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontFamily: 'Lalezar'),
              ),

              const SizedBox(height: 25),

              Text(
                note.text,
                style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    color: primaryTextColor,
                    fontFamily: 'UthmanTNB'),
              ),
              const SizedBox(height: 40), // Spacing before the button

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'تعديل الملاحظة',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () async {
                    
                    final result = await Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddNoteScreen(initialNote: note.toMap()),
                      ),
                    );
                    if (result != null) {
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, result);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Same color as AppBar
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
