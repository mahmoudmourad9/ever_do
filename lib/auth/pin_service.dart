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

  Future<void> deletePin() async {
    await _storage.delete(key: _key);
  }
}
