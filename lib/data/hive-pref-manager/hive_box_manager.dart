import 'package:hive_flutter/hive_flutter.dart';

///This Hive is structred like shared preference
class HiveBoxPreference<T> {
  final dynamic key;

  //Constructor
  HiveBoxPreference({required this.key});

  //Variables
  static const String _boxName = "hive_box_preference";
  static late Box _box;

  //Initializer
  static Future<void> init({String? boxName}) async {
    await Hive.initFlutter();
    //Initialize box
    _box = await Hive.openBox(boxName ?? _boxName);
  }

  // SAVE / UPDATE
  Future<void> saveData({required T value}) async => await _box.put(key, value);
  // GET
  T? getData() => _box.get(key);
  // DELETE
  Future<void> deleteData() async => await _box.delete(key);
  // CLEAR
  Future<int> clearAll() async => await _box.clear();
}
