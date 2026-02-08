import 'package:everdo_app/auth/pin_service.dart';
import 'package:everdo_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:everdo_app/Providers/theme_provider.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final PinService _pinService = PinService();
  bool _hasPin = false;
  bool _hasSecurityQA = false;

  @override
  void initState() {
    super.initState();
    _checkSecurityStatus();
  }

  Future<void> _checkSecurityStatus() async {
    final pin = await _pinService.getPin();
    final qa = await _pinService.getSecurityQA();
    if (mounted) {
      setState(() {
        _hasPin = pin != null;
        _hasSecurityQA = qa != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأمان والحماية'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [IceColors.backgroundNight, const Color(0xFF001018)]
                  : [const Color(0xFFEAF9FC), Colors.white]),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionHeader('رمز القفل (PIN)'),
            const SizedBox(height: 10),
            _buildSecurityCard(
              context,
              title: _hasPin ? 'تغيير رمز القفل' : 'تعيين رمز قفل',
              subtitle: _hasPin
                  ? 'اضغط لتغيير الرمز الحالي'
                  : 'قم بحماية يومياتك برمز سري',
              icon: Icons.lock,
              color: _hasPin ? Colors.green : Colors.grey,
              onTap: _handlePinSetup,
            ),
            if (_hasPin) ...[
              const SizedBox(height: 10),
              _buildSecurityCard(
                context,
                title: 'حذف رمز القفل',
                subtitle: 'إلغاء الحماية عن التطبيق',
                icon: Icons.lock_open,
                color: Colors.red,
                onTap: _handleDeletePin,
              ),
            ],
            const SizedBox(height: 30),
            _buildSectionHeader('استعادة الحساب'),
            const SizedBox(height: 10),
            _buildSecurityCard(
              context,
              title: _hasSecurityQA ? 'تحديث سؤال الأمان' : 'تعيين سؤال أمان',
              subtitle: 'يستخدم لاستعادة الرمز في حال نسيانه',
              icon: Icons.security,
              color: _hasSecurityQA ? Colors.blue : Colors.orange,
              onTap: _handleSecurityQASetup,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor),
    );
  }

  Widget _buildSecurityCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isDark ? IceColors.surfaceNight : Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Future<void> _handlePinSetup() async {
    final savedPin = await _pinService.getPin();
    String? newPin;

    if (savedPin != null) {
      // Verify first
      final verified = await _showPinDialog(
          title: 'أدخل الرمز الحالي',
          isVerification: true,
          correctPin: savedPin);
      if (verified != true) return;
    }

    newPin = await _showPinDialog(title: 'أدخل الرمز الجديد');
    if (newPin != null && newPin.length >= 4) {
      await _pinService.savePin(newPin);
      _checkSecurityStatus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ الرمز بنجاح ✅')));

        // Prompt for Security Question if not set
        if (!_hasSecurityQA) {
          _handleSecurityQASetup();
        }
      }
    }
  }

  Future<void> _handleDeletePin() async {
    final savedPin = await _pinService.getPin();
    if (savedPin != null) {
      final verified = await _showPinDialog(
          title: 'أدخل الرمز للحذف',
          isVerification: true,
          correctPin: savedPin);
      if (verified == true) {
        await _pinService.deletePin();
        _checkSecurityStatus();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حذف الرمز بنجاح 🗑️')));
        }
      }
    }
  }

  Future<void> _handleSecurityQASetup() async {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    // Check existing
    final existingQA = await _pinService.getSecurityQA();
    if (existingQA != null) {
      questionController.text = existingQA['question']!;
      // intentionally not showing answer
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('سؤال الأمان',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'السؤال (مثـل: اسم صديقك المفضل)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'الإجابة',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (questionController.text.isNotEmpty &&
                      answerController.text.isNotEmpty) {
                    await _pinService.saveSecurityQA(
                        questionController.text, answerController.text);
                    Navigator.pop(context);
                    _checkSecurityStatus();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم حفظ سؤال الأمان ✅')));
                  }
                },
                child: const Text('حفظ'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showPinDialog({
    required String title,
    bool isVerification = false,
    String? correctPin,
  }) async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, letterSpacing: 5),
          decoration: const InputDecoration(hintText: '----'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              if (isVerification) {
                if (controller.text == correctPin) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرمز غير صحيح ❌')));
                  controller.clear();
                }
              } else {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
