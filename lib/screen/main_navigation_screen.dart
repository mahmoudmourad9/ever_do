import 'package:everdo_app/screen/details/addDiary_screen.dart';
import 'package:everdo_app/screen/notes/add_note_screen.dart';
import 'package:everdo_app/screen/details/diary_screen.dart';
import 'package:everdo_app/screen/notes/notes_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const MainNavigationScreen({super.key, required this.onThemeChanged});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  final GlobalKey<DiaryScreenState> _diaryScreenKey =
      GlobalKey<DiaryScreenState>();
  final GlobalKey<NotesScreenState> _notesScreenKey =
      GlobalKey<NotesScreenState>();

  @override
  void initState() {
    super.initState();

    _pages = [
      DiaryScreen(key: _diaryScreenKey, onThemeChanged: widget.onThemeChanged),
      NotesScreen(key: _notesScreenKey, onThemeChanged: widget.onThemeChanged),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004A63),
        onPressed: () async {
          if (_currentIndex == 0) {
            final result = await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(builder: (_) => const AddScreen()),
            );

            if (result != null && mounted) {
              _diaryScreenKey.currentState?.refreshEntries();
            }
          } else if (_currentIndex == 1) {
            final result = await Navigator.push<Map<String, dynamic>>(
              context,
              MaterialPageRoute(builder: (_) => const AddNoteScreen()),
            );

            if (result != null && mounted) {
              _notesScreenKey.currentState?.refreshNotes();
            }
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
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.menu_book,
                  size: 32,
                ),
                color: _currentIndex == 0 ? Colors.white : Colors.white54,
                onPressed: () => _onTabTapped(0),
                tooltip: 'اليوميات',
              ),
              IconButton(
                icon: const Icon(Icons.note_alt_outlined, size: 32),
                color: _currentIndex == 1 ? Colors.white : Colors.white54,
                onPressed: () => _onTabTapped(1),
                tooltip: 'الملاحظات',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
