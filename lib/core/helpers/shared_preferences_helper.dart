import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
  SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setValueForKey({required String key, required dynamic value}) {
    if (value is String) {
      _prefs.setString(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is bool) {
      _prefs.setBool(key, value);
    }
  }

  String getValueForString({
    required String key,
  }) {
    return _prefs.getString(key) ?? '';
  }

  int getValueForInt({
    required String key,
  }) {
    return _prefs.getInt(key) ?? 0;
  }

  bool getValueForBool({
    required String key,
  }) {
    return _prefs.getBool(key) ?? false;
  }

  void removeValueForKey({
    required String key,
  }) {
    _prefs.remove(key);
  }
}
