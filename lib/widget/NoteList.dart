import 'package:everdo_app/models/note_model.dart';
import 'package:everdo_app/widget/notecard.dart';
import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Function(int) onNoteTapped;
  final Function(int) onNoteLongPressed;

  const NoteList({
    required this.notes,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onNoteTapped,
    required this.onNoteLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          cardColor: cardColor,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
          onTap: () => onNoteTapped(index),
          onLongPress: () => onNoteLongPressed(index),
        );
      },
    );
  }
}