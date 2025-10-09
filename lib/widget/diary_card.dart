import 'dart:io';
import 'package:flutter/material.dart';
import 'package:everdo_app/models/diary_entry_model.dart';
import 'package:everdo_app/screen/diary/details_screen.dart';

class DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onDelete;

  const DiaryEntryCard({
    super.key,
    required this.entry,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(entry: entry)),
        );
      },
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              entry.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(entry.imagePath!),
                        width: 100, 
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 100, 
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          _emojiFromIndex(entry.emojiIndex),
                          style: const TextStyle(fontSize: 40), // ← حجم الإيموجي أكبر
                        ),
                      ),
                    ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(
  entry.text,
  maxLines: 2,
  overflow: TextOverflow.clip,
  textAlign: TextAlign.center, 
  style: TextStyle(
    color: textColor,
    fontWeight: FontWeight.w500,

    fontSize: 17,
    fontFamily: 'PlaypenSansArabic'
  ),
),

                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 30, color: Colors.redAccent),
                onPressed: onDelete,
              ),
                      ],
                    ),
                  ],
                ),
              ),

             
              
            ],
          ),
        ),
      ),
    );
  }

  String _emojiFromIndex(int i) {
    const list = ['😡', '☹️', '🙂', '😄', '😍'];
    if (i < 0 || i >= list.length) return '🙂';
    return list[i];
  }
}
