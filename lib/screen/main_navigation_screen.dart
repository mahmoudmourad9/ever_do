import 'package:everdo_app/screen/diary/addDiary_screen.dart';
import 'package:everdo_app/screen/notes/add_note_screen.dart';
import 'package:everdo_app/screen/diary/diary_screen.dart';
import 'package:everdo_app/screen/notes/notes_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const MainNavigationScreen({super.key, required this.onToggleTheme});

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
      DiaryScreen(key: _diaryScreenKey, onToggleTheme: widget.onToggleTheme),
      NotesScreen(key: _notesScreenKey, onToggleTheme: widget.onToggleTheme),
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
            // المنطق الذكي للتحقق من وجود يومية بتاريخ اليوم
            final diaryState = _diaryScreenKey.currentState;
            if (diaryState == null) return;

            final now = DateTime.now();
            DiaryEntry? todayEntry;

            // البحث عن يومية مسجلة بتاريخ اليوم
            try {
              todayEntry = diaryState.diaryEntries.firstWhere((entry) =>
                  entry.date.year == now.year &&
                  entry.date.month == now.month &&
                  entry.date.day == now.day);
            } catch (e) {
              todayEntry = null;
            }

            // الانتقال إلى شاشة الإضافة أو التعديل
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddScreen(initialEntry: todayEntry?.toMap())),
            );

            // تحديث القائمة بعد العودة
            diaryState.refreshEntries();

          } else if (_currentIndex == 1) {
            // منطق الملاحظات
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddNoteScreen()),
            );
            _notesScreenKey.currentState?.refreshNotes();
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