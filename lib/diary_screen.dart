import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_screen.dart';
import 'settings_screen.dart';

class DiaryEntry {
  DateTime date;
  String text;
  int emojiIndex;
  double sliderValue;
  String? imagePath;

  DiaryEntry({
    required this.date,
    required this.text,
    required this.emojiIndex,
    required this.sliderValue,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'text': text,
      'emojiIndex': emojiIndex,
      'sliderValue': sliderValue,
      'imagePath': imagePath,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      text: map['text'],
      emojiIndex: map['emojiIndex'],
      sliderValue: (map['sliderValue'] as num).toDouble(),
      imagePath: map['imagePath'],
    );
  }
}

class DiaryScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme; 

  const DiaryScreen({super.key, this.onToggleTheme}); 

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<DiaryEntry> diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDiary();
  }

  Future<void> _loadDiary() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('diary_entries');
    if (data != null) {
      final List decoded = jsonDecode(data);
      diaryEntries = decoded.map((e) => DiaryEntry.fromMap(e)).toList();
      setState(() {});
    }
  }

  Future<void> _saveDiary() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(diaryEntries.map((e) => e.toMap()).toList());
    await prefs.setString('diary_entries', data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA8E8F2), Color(0xFFEAF9FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF006C8D),
                      child: IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          );
                        },
                      ),
                    ),
                    const Text(
                      'اليوميات',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        // زر تغيير الثيم
                        CircleAvatar(
                          backgroundColor: const Color(0xFF006C8D),
                          child: IconButton(
                            icon: const Icon(Icons.brightness_6, color: Colors.white),
                            onPressed: widget.onToggleTheme, 
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: const Color(0xFF006C8D),
                          child: IconButton(
                            icon: const Icon(Icons.menu_book, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: diaryEntries.isEmpty ? _buildEmpty() : _buildList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004A63),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddScreen()),
          );
          if (result != null && result is Map<String, dynamic>) {
            final entry = DiaryEntry(
              date: result['date'] is int
                  ? DateTime.fromMillisecondsSinceEpoch(result['date'])
                  : result['date'],
              text: result['text'],
              emojiIndex: result['emojiIndex'],
              sliderValue: (result['sliderValue'] as num).toDouble(),
              imagePath: result['imagePath'],
            );
            diaryEntries.insert(0, entry);
            await _saveDiary();
            setState(() {});
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF004A63),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.calendar_today, color: Colors.white),
              Icon(Icons.menu_book, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.edit_note, size: 120, color: Colors.black54),
          SizedBox(height: 10),
          Text('دون يومياتك',
              style: TextStyle(fontSize: 20, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: diaryEntries.length,
      itemBuilder: (context, index) {
        final e = diaryEntries[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => _DetailScreen(entry: e)),
            );
          },
          onLongPress: () async {
            final confirm = await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('حذف اليومية'),
                content: const Text('هل تريد حذف هذه اليومية؟'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء')),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('نعم')),
                ],
              ),
            );
            if (confirm == true) {
              diaryEntries.removeAt(index);
              await _saveDiary();
              setState(() {});
            }
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: e.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(e.imagePath!),
                          width: 56, height: 56, fit: BoxFit.cover),
                    )
                  : Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: Text(_emojiFromIndex(e.emojiIndex),
                            style: const TextStyle(fontSize: 26)),
                      ),
                    ),
              title:
                  Text(e.text, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle:
                  Text('${e.date.day}/${e.date.month}/${e.date.year}'),
            ),
          ),
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

class _DetailScreen extends StatelessWidget {
  final DiaryEntry entry;
  const _DetailScreen({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل اليومية'),
        backgroundColor: const Color(0xFF004A63),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(entry.imagePath!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            Text(
              '${entry.date.day}/${entry.date.month}/${entry.date.year}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(entry.text, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('المزاج: ${_emojiFromIndex(entry.emojiIndex)}',
                style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }

  static String _emojiFromIndex(int i) {
    const list = ['😡', '☹️', '🙂', '😄', '😍'];
    if (i < 0 || i >= list.length) return '🙂';
    return list[i];
  }
}
