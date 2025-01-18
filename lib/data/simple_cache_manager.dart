import 'package:shared_preferences/shared_preferences.dart';

//Cache Manager: uses sharedPreferences to cache string data
//mainly (posts) 
class CacheManager {
  final SharedPreferences _prefs;
  static const String _timestampKeySuffix = '_timestamp';
  //make cache duration one day (consideration for making it variable)
  static const Duration _expirationDuration = Duration(days: 1);

  CacheManager(this._prefs);

  static Future<CacheManager> create() async {
    final prefs = await SharedPreferences.getInstance();
    return CacheManager(prefs);
  }

  Future<bool> saveData(String key, String data) async {
    try {
      await _prefs.setString(key, data);
      //save time to denote when this data was cached
      await _prefs.setInt(
        key + _timestampKeySuffix,
        DateTime.now().millisecondsSinceEpoch,
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

    // Check if timestamp exists
    final timestamp = _prefs.getInt(key + _timestampKeySuffix);
    if (timestamp == null) return false;

    //check cache is still valid or has expired
    final savedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(savedDate);

    return difference <= _expirationDuration;
  }

  //Refresh cache 
  Future<bool> refreshData(String key, Future<String> Function() fetchNewData) async {
    try {
      final newData = await fetchNewData();
      return await saveData(key, newData);
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
      return true;
    } catch (e) {
      print('Error clearing cached data: $e');
      return false;
    }
  }
}