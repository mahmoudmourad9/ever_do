import 'dart:convert';
import 'package:everdo_app/Providers/theme_provide.dart';
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
    if (_titleController.text.isEmpty || _textController.text.isEmpty) {
      return;
    }
    final Map<String, dynamic> newNote = {
      'date': _date.millisecondsSinceEpoch,
      'title': _titleController.text.trim(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color primaryTextColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final Color inputFillColor =
        isDarkMode ? Colors.grey.shade800 : Colors.black12;
const buttonColor = Color(0xFF004A63);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
            widget.initialNote != null ? 'تعديل ملاحظة' : 'إضافة ملاحظة',
            style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_date.day} / ${_date.month} / ${_date.year}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    )),
                CircleAvatar(
                  backgroundColor: const Color(0xFF006C8D),
                  child: IconButton(
                      icon: const Icon(Icons.calendar_month,
                          color:Colors.white),
                      onPressed: _pickDate),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text('عنوان الملاحظة',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor)),
            const SizedBox(height: 10),
            TextField(
  controller: _titleController,
  textDirection: TextDirection.rtl,
  style: TextStyle(color: primaryTextColor),
  decoration: InputDecoration(
    hintText: 'اكتب العنوان هنا',
     hintTextDirection: TextDirection.rtl,
    hintStyle: TextStyle(
      color: isDarkMode ? Colors.grey : Colors.black38,
    ),
    filled: true,
    fillColor: inputFillColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  ),
),

            const SizedBox(height: 25),
            Text('المحتوى',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor)),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
               textDirection: TextDirection.rtl,
              maxLines: 8,
              style: TextStyle(color: primaryTextColor),
              decoration: InputDecoration(
                hintText: 'اكتب ملاحظتك هنا...',
                hintTextDirection: TextDirection.rtl,
                hintStyle:
                    TextStyle(color: isDarkMode ? Colors.grey : Colors.black38),
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _save,
                child: const Text('حفظ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
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
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _date = picked);
  }
}
