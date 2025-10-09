import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  

  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor:  Colors.white,
        title: Text(
          'الإعدادات',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
           
            Switch(
              value: isDarkMode,
              // ignore: deprecated_member_use
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            const Spacer(),
             Text(
              'الوضع الداكن',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
