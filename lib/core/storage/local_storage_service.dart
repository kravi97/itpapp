/// Local storage service using SharedPreferences
library;

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  late SharedPreferences _preferences;

  /// Initialize the storage service
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Save a string value
  Future<bool> saveString(String key, String value) async {
    return _preferences.setString(key, value);
  }

  /// Get a string value
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// Save an integer value
  Future<bool> saveInt(String key, int value) async {
    return _preferences.setInt(key, value);
  }

  /// Get an integer value
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// Save a double value
  Future<bool> saveDouble(String key, double value) async {
    return _preferences.setDouble(key, value);
  }

  /// Get a double value
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// Save a boolean value
  Future<bool> saveBool(String key, bool value) async {
    return _preferences.setBool(key, value);
  }

  /// Get a boolean value
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// Save a list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    return _preferences.setStringList(key, value);
  }

  /// Get a list of strings
  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  /// Check if a key exists
  bool hasKey(String key) {
    return _preferences.containsKey(key);
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    return _preferences.remove(key);
  }

  /// Clear all data
  Future<bool> clear() async {
    return _preferences.clear();
  }

  /// Clear specific keys
  Future<bool> clearKeys(List<String> keys) async {
    for (final key in keys) {
      await _preferences.remove(key);
    }
    return true;
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _preferences.getKeys();
  }
}
