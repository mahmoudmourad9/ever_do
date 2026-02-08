import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'diary_pin';

  Future<void> savePin(String pin) async {
    await _storage.write(key: _key, value: pin);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: _key);
  }

  Future<bool> verifyPin(String pin) async {
    final saved = await getPin();
    return saved != null && saved == pin;
  }

  static const String _qaKey = 'diary_security_qa'; // Format: "Question|Answer"

  Future<void> saveSecurityQA(String question, String answer) async {
    await _storage.write(key: _qaKey, value: '$question|$answer');
  }

  Future<Map<String, String>?> getSecurityQA() async {
    final data = await _storage.read(key: _qaKey);
    if (data == null || !data.contains('|')) return null;
    final parts = data.split('|');
    return {'question': parts[0], 'answer': parts[1]};
  }

  Future<bool> verifySecurityAnswer(String answer) async {
    final qa = await getSecurityQA();
    if (qa == null) return false;
    return qa['answer']?.trim().toLowerCase() == answer.trim().toLowerCase();
  }

  Future<void> deletePin() async {
    await _storage.delete(key: _key);
    await _storage.delete(key: _qaKey);
  }
}
