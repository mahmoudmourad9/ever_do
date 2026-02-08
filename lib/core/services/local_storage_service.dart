import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageService {
  Future<void> init();
  dynamic getData(String key);
  Future<bool> saveData(String key, String value);
  Future<bool> removeData(String key);
  bool containsKey(String key);
}

class LocalStorageServiceImpl implements LocalStorageService {
  SharedPreferences? _sharedPreferences;

  @override
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  dynamic getData(String key) {
    return _sharedPreferences?.get(key);
  }

  @override
  Future<bool> saveData(String key, String value) async {
    if (_sharedPreferences == null) await init();
    return await _sharedPreferences!.setString(key, value);
  }

  @override
  Future<bool> removeData(String key) async {
    if (_sharedPreferences == null) await init();
    return await _sharedPreferences!.remove(key);
  }

  @override
  bool containsKey(String key) {
    return _sharedPreferences?.containsKey(key) ?? false;
  }
}
