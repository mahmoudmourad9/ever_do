import 'dart:io';
import 'package:everdo_app/models/diary_entry_model.dart';
import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  final DiaryEntry entry;

  const DetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color cardColor =
        isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white;
    final Color primaryTextColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final Color secondaryTextColor =
        isDarkMode ? Colors.grey.shade400 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'تفاصيل اليومية',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (entry.imagePath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(entry.imagePath!),
                        width: double.infinity,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                  
                  const SizedBox(height: 10),
                  Text(
                    _emojiFromIndex(entry.emojiIndex),
                    style: const TextStyle(fontSize: 34),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.text,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryTextColor,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
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
