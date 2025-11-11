import 'package:everdo_app/Providers/theme_provide.dart';
import 'package:everdo_app/auth/auth_service.dart';
import 'package:everdo_app/auth/pin_settings.dart';
import 'package:everdo_app/auth/pin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.lock,
            title: 'إعدادات PIN',
            subtitle: 'قم بتغيير أو حذف رمز المرور',
            color: Colors.blue.shade700,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PinSettingsScreen(
                    pinService: PinService(),
                    authService: AuthService(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'الوضع الداكن',
            subtitle: 'تفعيل أو إلغاء الوضع الداكن',
            color: Colors.deepPurple.shade400,
            trailing: Switch(
              value: isDarkMode,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
