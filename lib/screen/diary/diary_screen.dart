import 'dart:convert';
import 'dart:io';
import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:everdo_app/models/diary_entry_model.dart';
import 'package:everdo_app/screen/diary/details_screen.dart';
import 'package:everdo_app/widget/AppBar%20.dart';
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
              costmAppbar(
                titel: 'اليوميات',
               
              ),
              Expanded(
                child: diaryEntries.isEmpty ? _buildEmpty(isDarkMode, textColor) : _buildList(cardColor, textColor, secondaryTextColor),
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailsScreen(entry: e)),
            );
          },
 
          child: Card(
  color: cardColor,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  elevation: 4,
  margin: const EdgeInsets.only(bottom: 16),
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: e.imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(e.imagePath!),
                width: 70, 
                height: 70,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Center(
                child: Text(
                  _emojiFromIndex(e.emojiIndex),
                  style: const TextStyle(fontSize: 32), 
                ),
              ),
            ),
      title: Text(
        e.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 16, 
        ),
      ),
      subtitle: Text(
        '${e.date.day}/${e.date.month}/${e.date.year}',
        style: TextStyle(
          color: secondaryTextColor,
          fontSize: 14, 
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 28, color: Colors.redAccent),
                 onPressed: () async {
            final confirm = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: cardColor,
                title: Text('حذف اليومية', style: TextStyle(color: textColor)),
                content:
                    Text('هل تريد حذف هذه اليومية؟', style: TextStyle(color: secondaryTextColor)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('نعم'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              diaryEntries.removeAt(index);
              await _saveDiary();
              setState(() {});
            }
          },
      ),
    ),
  ),
)

        );
      },
    );
  }

  String _emojiFromIndex(int i) {
    const list = ['😡', '☹️', '🙂', '😄', '😍'];
    if (i < 0 || i >= list.length) return '🙂';
    return list[i];
  }
}
