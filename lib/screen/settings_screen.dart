import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  const SettingsScreen({super.key, this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedLanguage = 'العربية';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      selectedLanguage = prefs.getString('language') ?? 'العربية';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setString('language', selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004A63),
        title: const Text(
          'الإعدادات',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFEAF9FC),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الوضع الداكن',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Switch(
              value: isDarkMode,
              // ignore: deprecated_member_use
              activeColor: const Color(0xFF004A63),
              onChanged: (value) async {
                setState(() {
                  isDarkMode = value;
                });
                await _saveSettings();
                widget.onThemeChanged?.call(value); // دي اللي بتغير الثيم في باقي الأبلكيشن
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'اللغة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButton<String>(
                value: selectedLanguage,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                items: const [
                  DropdownMenuItem(value: 'العربية', child: Text('العربية')),
                  DropdownMenuItem(value: 'English', child: Text('English')),
                ],
                onChanged: (value) async {
                  setState(() {
                    selectedLanguage = value!;
                  });
                  await _saveSettings();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
