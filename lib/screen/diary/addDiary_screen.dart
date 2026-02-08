import 'dart:io';
import 'dart:ui';
import 'package:everdo_app/Providers/theme_provider.dart';
import 'package:everdo_app/core/theme/app_colors.dart';
import 'package:everdo_app/features/diary/domain/entities/diary_entry.dart';
import 'package:everdo_app/features/diary/presentation/notifiers/diary_provider.dart';
import 'package:everdo_app/widget/MoodCard.dart';
import 'package:everdo_app/widget/image_picker_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  final DiaryEntry? initialEntry;
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
      _controller.text = e.text;
      _selectedEmoji = e.emojiIndex;
      _sliderValue = e.sliderValue;
      _date = e.date;
      _originalDate = _date;

      if (e.imagePath != null && File(e.imagePath!).existsSync()) {
        _pickedImage = File(e.imagePath!);
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
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        SnackBar(
          content: const Text('الرجاء كتابة محتوى اليومية'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final provider = Provider.of<DiaryProvider>(context, listen: false);
    final entriesList = provider.entries;

    bool dateExists = entriesList.any((entry) {
      if (widget.initialEntry != null &&
          _isSameDay(entry.date, _originalDate!)) {
        return false;
      }
      return _isSameDay(entry.date, _date);
    });

    if (dateExists) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('لا يمكن إضافة أكثر من يومية في نفس اليوم'),
            backgroundColor: Colors.orange.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final newEntry = DiaryEntry(
      date: _date,
      text: _controller.text.trim(),
      emojiIndex: _selectedEmoji,
      sliderValue: _sliderValue,
      imagePath: _pickedImage?.path ?? widget.initialEntry?.imagePath,
    );

    await provider.add(newEntry);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.black45 : Colors.white60,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: _pickDate,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_month,
                            size: 18, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          '${_date.day} / ${_date.month} / ${_date.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Header Text
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: isDark
                              ? [Colors.white, const Color(0xFF8bebf9)]
                              : [primaryColor, const Color(0xFF005f73)],
                        ).createShader(bounds),
                        child: Text(
                          'كيف كان يومك؟',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Masked
                              ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Mood Section
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
                      const SizedBox(height: 25),

                      // Image Section
                      ImagePickerCard(
                        initialImage: _pickedImage,
                        isDarkMode: isDark,
                        onImagePicked: (image) {
                          setState(() => _pickedImage = image);
                        },
                      ),
                      const SizedBox(height: 30),

                      // Text Editor
                      Text(
                        'اكتب ذكرياتك',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor?.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white10
                                    : primaryColor.withOpacity(0.1),
                              ),
                            ),
                            child: TextField(
                              controller: _controller,
                              maxLines: 12,
                              style: TextStyle(fontSize: 16, color: textColor),
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                hintText: 'سجل لحظاتك المميزة هنا...',
                                hintTextDirection: TextDirection.rtl,
                                hintStyle: TextStyle(
                                  color:
                                      isDark ? Colors.white30 : Colors.black38,
                                ),
                                contentPadding: const EdgeInsets.all(20),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'حفظ اليومية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
