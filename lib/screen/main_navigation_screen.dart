import 'package:everdo_app/features/diary/domain/entities/diary_entry.dart';
import 'package:everdo_app/features/diary/presentation/notifiers/diary_provider.dart';
import 'package:everdo_app/features/notes/presentation/notifiers/notes_provider.dart';
import 'package:everdo_app/screen/todo/todo_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
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

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 1; // Default: Notes
  late final List<Widget> _pages;
  bool _isSessionAuthenticated = false;

  final GlobalKey<DiaryScreenState> _diaryScreenKey =
      GlobalKey<DiaryScreenState>();
  final GlobalKey<NotesScreenState> _notesScreenKey =
      GlobalKey<NotesScreenState>();

  final AuthService _authService = AuthService();
  final PinService _pinService = PinService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pages = [
      DiaryScreen(key: _diaryScreenKey, onThemeChanged: widget.onThemeChanged),
      NotesScreen(key: _notesScreenKey, onThemeChanged: widget.onThemeChanged),
      ToDoListScreen(onThemeChanged: widget.onThemeChanged),
    ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Create a short delay to distinguish between temporary inactive (like biometrics) and actual app switch
      // For now, we'll reset on paused/inactive to ensure security.
      // However, biometrics might trigger inactive, so checking paused is safer for pure backgrounding.
      if (state == AppLifecycleState.paused) {
        setState(() {
          _isSessionAuthenticated = false;
        });
      }
    }
  }

  void _onTabTapped(int index) async {
    if (index == 0) {
      if (!_isSessionAuthenticated) {
        bool isAuth = await _authService.authenticateUser();
        if (!isAuth) isAuth = await _showPinDialog();

        if (!isAuth) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('فشل التحقق من الهوية ❌')),
            );
          }
          return;
        } else {
          setState(() {
            _isSessionAuthenticated = true;
          });
        }
      }
    }

    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _showPinDialog() async {
    final savedPin = await _pinService.getPin();
    final hasQA = (await _pinService.getSecurityQA()) != null;
    final controller = TextEditingController();

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  savedPin == null ? 'إنشاء رمز مرور جديد' : 'أدخل رمز المرور'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    style: const TextStyle(fontSize: 24, letterSpacing: 5),
                    decoration: const InputDecoration(hintText: '----'),
                  ),
                  if (savedPin != null && hasQA)
                    TextButton(
                      onPressed: () async {
                        // Close PIN dialog first
                        Navigator.of(context).pop(false);
                        // Start recovery flow
                        await _handleForgotPin();
                      },
                      child: const Text('نسيت الرمز؟',
                          style: TextStyle(color: Colors.red)),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () async {
                    if (savedPin == null) {
                      if (controller.text.length == 4) {
                        await _pinService.savePin(controller.text);
                        // Prompt to setup Security Question if creating new PIN
                        Navigator.of(context).pop(true);
                        _promptSecuritySetup();
                      }
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

  Future<void> _handleForgotPin() async {
    final qa = await _pinService.getSecurityQA();
    if (qa == null) return;

    final controller = TextEditingController();
    final verified = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('استعادة الرمز'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('سؤال الأمان: ${qa['question']}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'الإجابة'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              final isCorrect =
                  await _pinService.verifySecurityAnswer(controller.text);
              Navigator.pop(context, isCorrect);
            },
            child: const Text('تحقق'),
          ),
        ],
      ),
    );

    if (verified == true) {
      await _pinService.deletePin();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إعادة تعيين الرمز بنجاح ✅')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الإجابة غير صحيحة ❌')),
        );
      }
    }
  }

  void _promptSecuritySetup() {
    // Optional: prompt user to navigate to security settings
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يُنصح بتعيين سؤال أمان لاستعادة الرمز'),
          action: SnackBarAction(
            label: 'إعداد الآن',
            onPressed: () {
              // Navigate to settings? For now just a hint.
            },
          ),
        ),
      );
    }
  }

  Future<void> _handleFabPressed() async {
    if (_currentIndex == 0) {
      final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);

      final now = DateTime.now();
      DiaryEntry? todayEntry;

      try {
        todayEntry = diaryProvider.entries.firstWhere((entry) =>
            entry.date.year == now.year &&
            entry.date.month == now.month &&
            entry.date.day == now.day);
      } catch (e) {
        todayEntry = null;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddScreen(initialEntry: todayEntry)),
      );
    } else if (_currentIndex == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddNoteScreen()),
      );
      // ignore: use_build_context_synchronously
      Provider.of<NotesProvider>(context, listen: false).loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      floatingActionButton: _currentIndex == 2
          ? null // Hide global FAB for ToDo screen (it has its own)
          : FloatingActionButton(
              onPressed: _handleFabPressed,
              child: const Icon(Icons.add, size: 32),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == _currentIndex) return;
          _onTabTapped(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'اليوميات',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            selectedIcon: Icon(Icons.note_alt),
            label: 'الملاحظات',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'المهام',
          ),
        ],
      ),
    );
  }
}
