import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004A63),
        elevation: 0,
        title: const Text('إضافة ملاحظة',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_date.day} / ${_date.month} / ${_date.year}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                IconButton(
                    icon: const Icon(Icons.calendar_month,
                        color: Color(0xFF004A63)),
                    onPressed: _pickDate),
              ],
            ),
            const SizedBox(height: 25),
            const Text('عنوان الملاحظة',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'اكتب العنوان هنا',
                hintStyle: const TextStyle(color: Colors.black38),
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 25),
            const Text('المحتوى',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'اكتب ملاحظتك هنا...',
                hintStyle: const TextStyle(color: Colors.black38),
                filled: true,
                fillColor: Colors.black12,
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
                  backgroundColor: const Color(0xFF004A63),
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
        lastDate: DateTime(2100));
    if (picked != null) setState(() => _date = picked);
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

    notesList.add(newNote);

    await prefs.setString('notes', jsonEncode(notesList));

    if (mounted) {
      Navigator.pop(context, newNote);
    }
  }
}