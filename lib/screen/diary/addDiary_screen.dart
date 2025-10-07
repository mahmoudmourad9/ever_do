import 'dart:convert';
import 'dart:io';
import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  final Map<String, dynamic>? initialEntry;
  const AddScreen({super.key, this.initialEntry});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  int _selectedEmoji = 2;
  double _sliderValue = 0.5;
  DateTime _date = DateTime.now();
  DateTime? _originalDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialEntry != null) {
      final e = widget.initialEntry!;
      _controller.text = e['text'] ?? '';
      _selectedEmoji = e['emojiIndex'] ?? 2;
      _sliderValue = (e['sliderValue'] ?? 0.5).toDouble();
      _date = DateTime.fromMillisecondsSinceEpoch(
          e['date'] ?? DateTime.now().millisecondsSinceEpoch);
      _originalDate = _date;
      if (e['imagePath'] != null) _pickedImage = File(e['imagePath']);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _save() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء كتابة محتوى اليومية')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('diary_entries');
    List<dynamic> entriesList = data != null ? jsonDecode(data) : [];

    bool dateExists = entriesList.any((entry) {
      final existingDate = DateTime.fromMillisecondsSinceEpoch(entry['date']);
      if (widget.initialEntry != null &&
          _isSameDay(existingDate, _originalDate!)) {
        return false;
      }
      return _isSameDay(existingDate, _date);
    });

    if (dateExists) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('لا يمكن إضافة أكثر من يومية في نفس اليوم')),
        );
      }
      return;
    }

    final Map<String, dynamic> newEntry = {
      'date': _date.millisecondsSinceEpoch,
      'text': _controller.text.trim(),
      'emojiIndex': _selectedEmoji,
      'sliderValue': _sliderValue,
      'imagePath': _pickedImage?.path,
    };

    if (widget.initialEntry != null) {
      entriesList.removeWhere(
          (entry) => entry['date'] == widget.initialEntry!['date']);
    }

    entriesList.add(newEntry);

    await prefs.setString('diary_entries', jsonEncode(entriesList));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color cardColor =
        isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white;
    final Color inputFillColor =
        isDarkMode ? Colors.grey.shade800 : Colors.black12;
    final Color primaryTextColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
            widget.initialEntry != null ? 'تعديل اليومية' : 'إضافة يومية',
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_date.day} / ${_date.month} / ${_date.year}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    )),
                IconButton(
                    icon: Icon(Icons.calendar_month,
                        color: Theme.of(context).primaryColor),
                    onPressed: _pickDate),
              ],
            ),
            const SizedBox(height: 20),
            Text('شعورك اليوم',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor)),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: cardColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedEmoji = i),
                          child: Opacity(
                            opacity: _selectedEmoji == i ? 1.0 : 0.5,
                            child: Text(_emojiFromIndex(i),
                                style: const TextStyle(fontSize: 30)),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Slider(
                        value: _sliderValue,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (v) => setState(() => _sliderValue = v)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('إضافة صورة',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                    color: inputFillColor,
                    borderRadius: BorderRadius.circular(10)),
                child: _pickedImage == null
                    ? Center(
                        child: Text('أضف صورة...',
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white54
                                    : Colors.black45)))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_pickedImage!,
                            width: double.infinity,
                            height: 130,
                            fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 25),
            Text('اليومية',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor)),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              maxLines: 5,
              style: TextStyle(color: primaryTextColor),
              decoration: InputDecoration(
                hintText: 'ما الذي تريد إضافته اليوم',
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  String _emojiFromIndex(int i) {
    const list = ['😡', '☹️', '🙂', '😄', '😍'];
    if (i < 0 || i >= list.length) return '🙂';
    return list[i];
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (image != null) setState(() => _pickedImage = File(image.path));
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
