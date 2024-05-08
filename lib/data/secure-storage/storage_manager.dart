import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  static const String _keyRefreshToken = 'refreshToken';

  Future setRefreshToken({required String token}) async {
    var writeData = await _storage.write(key: _keyRefreshToken, value: token);
    return writeData;
  }

  Future getRefreshToken() async {
    var readData = await _storage.read(key: _keyRefreshToken);
    return readData;
  }

  Future deleteRefreshToken() async {
    var deleteData = await _storage.delete(key: _keyRefreshToken);
    return deleteData;
  }
}
