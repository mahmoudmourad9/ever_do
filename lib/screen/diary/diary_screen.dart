import 'dart:convert';
import 'dart:io';
import 'package:everdo_app/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      if (mounted) {
        setState(() {});
      }
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
 costmAppbar( titel: 'اليوميات', rightIcon: Icons.note_alt_outlined,),
              Expanded(
                child: diaryEntries.isEmpty ? _buildEmpty() : _buildList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
// لما تكون البيانات مش  موجودة أو غير مُضافة في الشاشة.
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
Image.asset('assets/images/write.png',height: 120,),
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
              MaterialPageRoute(builder: (_) => DetailScreen(entry: e)),
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

class DetailScreen extends StatelessWidget {
  final DiaryEntry entry;
  const DetailScreen({required this.entry, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        centerTitle: true,
        title: const Text('تفاصيل اليومية',style: TextStyle(color: Colors.white,)),
        backgroundColor: const Color(0xFF004A63),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          
            Text(
              '${entry.date.day}/${entry.date.month}/${entry.date.year}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
               const SizedBox(height: 8),
            Text(' ${_emojiFromIndex(entry.emojiIndex)}:شعور اليوم',
                style: const TextStyle(fontSize: 22)),
                   const SizedBox(height: 8),
            if (entry.imagePath != null)
              ClipRRect(
                
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(entry.imagePath!),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),
            Divider(thickness: 3,),
            
            const SizedBox(height: 8),
            Text(entry.text, style: const TextStyle(fontSize: 18,)),
         
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