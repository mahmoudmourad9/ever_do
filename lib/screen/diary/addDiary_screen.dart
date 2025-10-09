import 'dart:convert';
import 'dart:io';
import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:everdo_app/widget/MoodCard.dart';
import 'package:everdo_app/widget/image_picker_card.dart';
import 'package:flutter/material.dart';
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
        e['date'] ?? DateTime.now().millisecondsSinceEpoch,
      );
      _originalDate = _date;

      final imagePath = e['imagePath'];
      if (imagePath != null && File(imagePath).existsSync()) {
        _pickedImage = File(imagePath);
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.light(primary: Theme.of(context).primaryColor),
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
      'imagePath': _pickedImage?.path ?? widget.initialEntry?['imagePath'],
    };

    if (widget.initialEntry != null) {
      entriesList.removeWhere(
          (entry) => entry['date'] == widget.initialEntry!['date']);
    }

    entriesList.add(newEntry);
    await prefs.setString('diary_entries', jsonEncode(entriesList));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

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
          style: const TextStyle( color:  Colors.white,),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_date.day} / ${_date.month} / ${_date.year}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryTextColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF006C8D),
                    child: IconButton(
                      icon: const Icon(Icons.calendar_month,
                         color: Colors.white,),
                      onPressed: _pickDate,
                    ),
                  ),
                ],
              ),

              Text(
                'شعورك اليوم',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor),
              ),
              const SizedBox(height: 10),

              MoodCard(
                selectedEmoji: _selectedEmoji,
                sliderValue: _sliderValue,
                onEmojiSelected: (i) {
                  setState(() {
                    _selectedEmoji = i;
                    _sliderValue = i / 4;
                  });
                },
                onSliderChanged: (v) {
                  setState(() {
                    _sliderValue = v;
                    _selectedEmoji = (v * 4).round();
                  });
                },
              ),

              const SizedBox(height: 20),

           
              ImagePickerCard(
                initialImage: _pickedImage,
                isDarkMode: isDarkMode,
                onImagePicked: (image) {
                  setState(() {
                    _pickedImage = image;
                  });
                },
              ),

              const SizedBox(height: 25),

              Text(
                'اليومية',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _controller,
                maxLines: 15,
                style: TextStyle(color: primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'ما الذي تريد إضافته اليوم',
                  hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey : Colors.black38),
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
                  child: const Text(
                    'حفظ',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
