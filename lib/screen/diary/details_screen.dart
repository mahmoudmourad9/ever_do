import 'dart:io';
import 'package:flutter/material.dart';
import 'diary_screen.dart';

class DetailsScreen extends StatelessWidget {
  final DiaryEntry entry;

  const DetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل اليومية'),
        backgroundColor: const Color(0xFF004A63),
      ),
      backgroundColor: const Color(0xFFEAF9FC),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (entry.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(entry.imagePath!),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Text(
                _emojiFromIndex(entry.emojiIndex),
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 20),
              Text(
                entry.text,
                style: const TextStyle(fontSize: 18, height: 1.6),
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
