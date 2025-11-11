import 'package:flutter/material.dart';
import 'package:everdo_app/models/diary_entry_model.dart';
import 'package:everdo_app/screen/diary/addDiary_screen.dart';
import 'package:everdo_app/screen/notes/add_note_screen.dart';
import 'package:everdo_app/screen/diary/diary_screen.dart';
import 'package:everdo_app/screen/notes/notes_screen.dart';
import 'package:everdo_app/auth/pin_service.dart';
import '../auth/auth_service.dart';

class MainNavigationScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const MainNavigationScreen({super.key, required this.onThemeChanged});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1; // الصفحة الافتراضية: الملاحظات
  late final List<Widget> _pages;

  final GlobalKey<DiaryScreenState> _diaryScreenKey = GlobalKey<DiaryScreenState>();
  final GlobalKey<NotesScreenState> _notesScreenKey = GlobalKey<NotesScreenState>();

  final AuthService _authService = AuthService();
  final PinService _pinService = PinService();

  @override
  void initState() {
    super.initState();
    _pages = [
      DiaryScreen(key: _diaryScreenKey, onThemeChanged: widget.onThemeChanged),
      NotesScreen(key: _notesScreenKey, onThemeChanged: widget.onThemeChanged),
    ];
  }

  Future<void> _onTabTapped(int index) async {
    if (index == 0) {
      // التوثيق بالبصمة أولًا
      bool isAuth = await _authService.authenticateUser();

      if (!isAuth) {
        // لو فشل التوثيق بالبصمة → fallback للـ PIN
        isAuth = await _showPinDialog();
      }

      if (!isAuth) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل التحقق من الهوية ❌')),
        );
        return; // لا يُفتح اليوميات
      }
    }

    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _showPinDialog() async {
    final savedPin = await _pinService.getPin();
    final controller = TextEditingController();

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(savedPin == null ? 'إنشاء رمز مرور جديد' : 'أدخل رمز المرور'),
              content: TextField(
                controller: controller,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'PIN'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () async {
                    if (savedPin == null) {
                      await _pinService.savePin(controller.text);
                      Navigator.of(context).pop(true);
                    } else {
                      final ok = await _pinService.verifyPin(controller.text);
                      Navigator.of(context).pop(ok);
                    }
                  },
                  child: const Text('تأكيد'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004A63),
        onPressed: () async {
          if (_currentIndex == 0) {
            final diaryState = _diaryScreenKey.currentState;
            if (diaryState == null) return;

            final now = DateTime.now();
            DiaryEntry? todayEntry;

            try {
              todayEntry = diaryState.diaryEntries.firstWhere((entry) =>
                  entry.date.year == now.year &&
                  entry.date.month == now.month &&
                  entry.date.day == now.day);
            } catch (e) {
              todayEntry = null;
            }

            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddScreen(initialEntry: todayEntry?.toMap())),
            );

            diaryState.refreshEntries();
          } else if (_currentIndex == 1) {
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
                icon: const Icon(Icons.menu_book, size: 32),
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
