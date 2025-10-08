import 'package:everdo_app/models/note_model.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteCard({
    required this.note,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF006C8D),
            child: Text(
              note.title.isNotEmpty ? note.title[0].toUpperCase() : 'N',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal'),
          ),
          subtitle: Text(
            '${note.date.day}/${note.date.month}/${note.date.year}',
            style: TextStyle(color: secondaryTextColor, fontFamily: 'Tajawal'), 
          ),
        ),
      ),
    );
  }
}