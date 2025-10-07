import 'dart:convert';
import 'package:everdo_app/models/note_model.dart';
import 'package:everdo_app/widget/AppBar%20.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_details_screen.dart';


class NotesScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const NotesScreen({super.key, this.onToggleTheme, required Function(bool p1) onThemeChanged});

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void refreshNotes() {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notes');
    if (data != null) {
      final List decoded = jsonDecode(data);
      notes = decoded.map((e) => Note.fromMap(e)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(notes.map((e) => e.toMap()).toList());
    await prefs.setString('notes', data);
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
            colors: [Color(0xFFA8E8F2), Color(0xFFEAF9FC)],  //عايز يتعادل عشان يتوافق مع الدرك مود
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              costmAppbar(  titel: 'الملاحظات', rightIcon: Icons.note_alt_outlined,),
              Expanded(
                child: notes.isEmpty ? _buildEmpty() : _buildList(),
              ),
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
        children:  [
          Image.asset('assets/images/notes.png',height: 120,),
          SizedBox(height: 10),
          Text('لا يوجد ملاحظات',
              style: TextStyle(fontSize: 20, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () async {
            final result = await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(
                builder: (_) => NoteDetailsScreen(note: note),
              ),
            );

            if (result != null) {
              setState(() {
                notes[index] = Note.fromMap(result);
              });
              await _saveNotes();
            }
          },
          onLongPress: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('حذف الملاحظة'),
                content: const Text('هل تريد حذف هذه الملاحظة؟'),
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
              notes.removeAt(index);
              await _saveNotes();
              setState(() {});
            }
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              title: Text(note.title,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle:
                  Text('${note.date.day}/${note.date.month}/${note.date.year}'),
            ),
          ),
        );
      },
    );
  }
}

