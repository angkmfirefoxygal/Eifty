import 'package:flutter/material.dart';
import 'package:eifty/data/services/wallet_service.dart';
import 'package:eifty/data/services/secure_storage_service.dart';

class WalletViewModel extends ChangeNotifier {
  String? mnemonic;
  String? address;
  String? privateKey;
  bool isLoading = false;

  /// 니모닉 생성
  void generateMnemonic() {
    mnemonic = WalletService.generateMnemonic();
    notifyListeners();
  }

  /// 니모닉으로 지갑 생성 후 저장
  Future<void> createAndSaveWallet(BuildContext context) async {
    if (mnemonic == null) return;

    isLoading = true;
    notifyListeners();

    try {
      final wallet = await WalletService.generateWalletFromMnemonic(mnemonic!);
      privateKey = wallet['privateKey'];
      address = wallet['address'];

      await SecureStorageService.saveWallet(privateKey!, address!);

      Navigator.pushReplacementNamed(context, '/wallet/created');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('지갑 생성 실패: $e')));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
