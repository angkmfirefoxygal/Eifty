import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:eifty/models/wallet_model.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyWallets = 'wallets'; // 전체 지갑 리스트
  static const _keySelected = 'selected_wallet'; // 선택된 지갑 주소

  /// 전체 지갑 저장
  static Future<void> saveWalletList(List<WalletModel> wallets) async {
    final data = jsonEncode(wallets.map((w) => w.toJson()).toList());
    await _storage.write(key: _keyWallets, value: data);
  }

  /// 지갑 리스트 불러오기
  static Future<List<WalletModel>> loadWalletList() async {
    final jsonStr = await _storage.read(key: _keyWallets);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List;
    return list.map((e) => WalletModel.fromJson(e)).toList();
  }

  /// 기본 지갑 선택 저장
  static Future<void> setSelectedWallet(String address) async {
    await _storage.write(key: _keySelected, value: address);
  }

  /// 선택된 지갑 주소 가져오기
  static Future<String?> getSelectedWalletAddress() async {
    return await _storage.read(key: _keySelected);
  }

  /// 지갑 삭제
  static Future<void> deleteWallet(String address) async {
    final wallets = await loadWalletList();
    final updated = wallets.where((w) => w.address != address).toList();
    await saveWalletList(updated);

    final selected = await getSelectedWalletAddress();
    if (selected == address && updated.isNotEmpty) {
      await setSelectedWallet(updated.first.address);
    } else if (updated.isEmpty) {
      await _storage.delete(key: _keySelected);
    }
  }

  /// 전체 초기화
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
