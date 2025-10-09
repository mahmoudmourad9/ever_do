import 'dart:convert';
import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:everdo_app/models/diary_entry_model.dart';
import 'package:everdo_app/widget/AppBar .dart';
import 'package:everdo_app/widget/_DeleteConfirmationDialog.dart';
import 'package:everdo_app/widget/diary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const DiaryScreen({
    super.key,
    this.onToggleTheme,
    required Function(bool) onThemeChanged,
  });

  @override
  DiaryScreenState createState() => DiaryScreenState();
}

class DiaryScreenState extends State<DiaryScreen> {
  List<DiaryEntry> diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDiary();
  }

  void refreshEntries() {
    _loadDiary();
  }

  Future<void> _loadDiary() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('diary_entries');
    if (data != null) {
      final List decoded = jsonDecode(data);
      diaryEntries = decoded.map((e) => DiaryEntry.fromMap(e)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      if (mounted) setState(() {});
    }
  }

  Future<void> _saveDiary() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(diaryEntries.map((e) => e.toMap()).toList());
    await prefs.setString('diary_entries', data);
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

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    const Color(0xFF0E1A1F),
                    const Color(0xFF1E2C33),
                  ]
                : [
                    const Color(0xFFA8E8F2),
                    const Color(0xFFEAF9FC),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const costmAppbar(
                titel: 'اليوميات',
              ),
              Expanded(
                child: diaryEntries.isEmpty
                    ? _buildEmpty(isDarkMode, textColor)
                    : _buildList(cardColor, textColor, secondaryTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(bool isDarkMode, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/write_white.png'
                : 'assets/images/write.png',
            height: 120,
          ),
          const SizedBox(height: 10),
          Text(
            'دون يومياتك',
            // ignore: deprecated_member_use
            style: TextStyle(fontSize: 20, color: textColor.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildList(Color cardColor, Color textColor, Color secondaryTextColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: diaryEntries.length,
      itemBuilder: (context, index) {
        final e = diaryEntries[index];
        return DiaryEntryCard(
          entry: e,
          cardColor: cardColor,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
          onDelete: () async {
            final confirm = await showDialog(
              context: context,
              builder: (_) => DeleteConfirmationDialog(
                cardColor: cardColor,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
            );
            if (confirm == true) {
              diaryEntries.removeAt(index);
              await _saveDiary();
              setState(() {});
            }
          },
        );
      },
    );
  }
}
