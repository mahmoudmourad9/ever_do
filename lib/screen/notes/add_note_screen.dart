import 'dart:convert';
import 'package:everdo_app/Providers/theme_provider.dart';
import 'package:everdo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  final Map<String, dynamic>? initialNote;
  const AddNoteScreen({super.key, this.initialNote});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialNote != null) {
      final note = widget.initialNote!;
      _titleController.text = note['title'] ?? '';
      _textController.text = note['text'] ?? '';
      _date = DateTime.fromMillisecondsSinceEpoch(
          note['date'] ?? DateTime.now().millisecondsSinceEpoch);
    }
  }

  void _save() async {
    if (_titleController.text.isEmpty && _textController.text.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final Map<String, dynamic> newNote = {
      'date': _date.millisecondsSinceEpoch,
      'title': _titleController.text.trim().isEmpty
          ? 'بدون عنوان'
          : _titleController.text.trim(),
      'text': _textController.text.trim(),
    };

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notes');
    List<dynamic> notesList = data != null ? jsonDecode(data) : [];

    if (widget.initialNote != null) {
      notesList
          .removeWhere((note) => note['date'] == widget.initialNote!['date']);
    }

    notesList.add(newNote);

    await prefs.setString('notes', jsonEncode(notesList));

    if (mounted) {
      Navigator.pop(context, newNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryTextColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final secondaryTextColor = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _save,
            icon: Icon(Icons.check,
                size: 30, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [IceColors.backgroundNight, const Color(0xFF001018)]
                : [const Color(0xFFEAF9FC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Date Pill
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_date.day}/${_date.month}/${_date.year}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title Input
                TextField(
                  controller: _titleController,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'العنوان',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(
                      color: secondaryTextColor.withOpacity(0.5),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 10),

                // Content Input
                Expanded(
                  child: TextField(
                    controller: _textController,
                    textDirection: TextDirection.rtl,
                    maxLines: null,
                    expands: true,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      color: primaryTextColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ابدأ الكتابة هنا...',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(
                        color: secondaryTextColor.withOpacity(0.4),
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _date = picked);
  }
}
