import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyPrivateKey = 'private_key';
  static const _keyAddress = 'wallet_address';

  /// 저장
  static Future<void> saveWallet(String privateKey, String address) async {
    await _storage.write(key: _keyPrivateKey, value: privateKey);
    await _storage.write(key: _keyAddress, value: address);
  }

  /// 불러오기
  static Future<String?> getPrivateKey() async =>
      await _storage.read(key: _keyPrivateKey);

  static Future<String?> getAddress() async =>
      await _storage.read(key: _keyAddress);

  /// 삭제
  static Future<void> clear() async => await _storage.deleteAll();
}
