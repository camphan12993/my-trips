import 'package:get_storage/get_storage.dart';

class Storage {
  static setValue(String key, value) async {
    final box = GetStorage();
    await box.write(key, value);
  }

  static getValue(String key) {
    final box = GetStorage();
    return box.read(key);
  }

  static clear() {
    final box = GetStorage();
    box.erase();
  }

  // user
  static get user => getValue('user');
  static set user(value) => setValue('user', value);
}
