import 'package:hive_flutter/adapters.dart';

class HiveService {
  late Box _dataBox;

  Future<void> init() async {
    await Hive.openBox('dataBox');
    _dataBox = Hive.box('dataBox');
  }

  List get dataList => _dataBox.values.toList();

  Future<void> clearData() async {
    await _dataBox.clear();
  }

  Future<void> saveData(List newData) async {
    await clearData();
    for (var data in newData) {
      _dataBox.add(data);
    }
  }
}
