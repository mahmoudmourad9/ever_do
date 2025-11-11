import 'package:everdo_app/auth/pin_service.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class PinSettingsScreen extends StatelessWidget {
  final PinService pinService;
  final AuthService authService;

  const PinSettingsScreen({super.key, required this.pinService, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات PIN'),
        backgroundColor: const Color(0xFF004A63),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              context,
              icon: Icons.edit,
              color: Colors.blue.shade700,
              title: 'تغيير PIN',
              subtitle: 'قم بتغيير رمز المرور الحالي',
              onTap: () => _changePin(context),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.delete_forever,
              color: Colors.red.shade700,
              title: 'حذف PIN',
              subtitle: 'احذف رمز المرور الحالي',
              onTap: () => _deletePin(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required IconData icon,
      required Color color,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
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
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  /// تغيير PIN
  Future<void> _changePin(BuildContext context) async {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final savedPin = await pinService.getPin();

    if (savedPin == null) {
      final newPin = await _showPinInputDialog(context, 'إنشاء PIN جديد', 'PIN جديد');
      if (newPin != null && newPin.isNotEmpty) {
        await pinService.savePin(newPin);
        _showSnackBar(context, 'تم إنشاء PIN جديد ✅');
      }
      return;
    }

    final verified = await _showPinInputDialog(context, 'أدخل PIN الحالي', 'PIN الحالي', verify: true);
    if (verified == true) {
      final newPin = await _showPinInputDialog(context, 'أدخل PIN الجديد', 'PIN الجديد');
      if (newPin != null && newPin.isNotEmpty) {
        await pinService.savePin(newPin);
        _showSnackBar(context, 'تم تغيير PIN بنجاح ✅');
      }
    } else {
      _showSnackBar(context, 'PIN الحالي غير صحيح ❌');
    }
  }

  /// حذف PIN
  Future<void> _deletePin(BuildContext context) async {
    bool isAuth = await authService.authenticateUser();
    if (!isAuth) {
      final savedPin = await pinService.getPin();
      if (savedPin != null) {
        final verified = await _showPinInputDialog(context, 'أدخل PIN الحالي', 'PIN الحالي', verify: true);
        isAuth = verified == true;
      }
    }

    if (isAuth) {
      await pinService.deletePin();
      _showSnackBar(context, 'تم حذف PIN ✅');
    } else {
      _showSnackBar(context, 'فشل التحقق من الهوية ❌');
    }
  }

  Future<dynamic> _showPinInputDialog(BuildContext context, String title, String hint,
      {bool verify = false}) async {
    final controller = TextEditingController();
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
              onPressed: () async {
                if (verify) {
                  final ok = await pinService.verifyPin(controller.text);
                  Navigator.pop(context, ok);
                } else {
                  Navigator.pop(context, controller.text);
                }
              },
              child: const Text('تأكيد')),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
