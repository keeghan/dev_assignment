import 'package:shared_preferences/shared_preferences.dart';

//Cache Manager: uses sharedPreferences to cache string data
//mainly (posts)
class CacheManager {
  final SharedPreferences _prefs;
  static const String _timestampKeySuffix = '_timestamp';
  static const String _durationKeySuffix = '_duration';

  CacheManager(this._prefs);

  static Future<CacheManager> create() async {
    final prefs = await SharedPreferences.getInstance();
    return CacheManager(prefs);
  }

  Future<bool> saveData(String key, String data, Duration expirationDuration) async {
    try {
      await _prefs.setString(key, data);
      //save time to denote when this data was cached
      await _prefs.setInt(
        key + _timestampKeySuffix,
        DateTime.now().millisecondsSinceEpoch,
      );
      //save the duration for the data
      await _prefs.setInt(
        key + _durationKeySuffix,
        expirationDuration.inMilliseconds,
      );
      return true;
    } catch (e) {
      print('Error saving cached data: $e');
      return false;
    }
  }

  //check validity of cache and return
  String? getData(String key) {
    if (!hasValidCache(key)) {
      return null;
    }
    return _prefs.getString(key);
  }

  bool hasValidCache(String key) {
    // Check if data exists
    final data = _prefs.getString(key);
    if (data == null) return false;

    // Check if timestamp and duration exists
    final timestamp = _prefs.getInt(key + _timestampKeySuffix);
    final duration = _prefs.getInt(key + _durationKeySuffix);
    if (timestamp == null || duration == null) return false;

    //check cache is still valid by comparing
    //savedDate - currentDate to expirationDuration
    final savedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(savedDate);
    final expirationDuration = Duration(milliseconds: duration);

    return difference <= expirationDuration;
  }

  //Refresh cache
  Future<bool> refreshData(
      String key, Future<String> Function() fetchNewData, Duration expirationDuration) async {
    try {
      final newData = await fetchNewData();
      return await saveData(key, newData, expirationDuration);
    } catch (e) {
      print('Error refreshing cached data: $e');
      return false;
    }
  }

  //clear the cache
  Future<bool> clearCache(String key) async {
    try {
      await _prefs.remove(key);
      await _prefs.remove(key + _timestampKeySuffix);
      await _prefs.remove(key + _durationKeySuffix);
      return true;
    } catch (e) {
      print('Error clearing cached data: $e');
      return false;
    }
  }
}
