import 'package:flutter/material.dart';
import 'package:eifty/data/services/secure_storage_service.dart';
import 'package:eifty/models/wallet_model.dart';
import 'package:eifty/data/services/wallet_service.dart';
import 'package:eifty/presentation/screens/wallet_created_screen.dart';

class WalletViewModel extends ChangeNotifier {
  List<WalletModel> _wallets = [];
  WalletModel? _selectedWallet;
  bool isLoading = false;
  String? _generatedMnemonic;

  List<WalletModel> get wallets => _wallets;
  WalletModel? get selectedWallet => _selectedWallet;
  String? get mnemonic => _generatedMnemonic;

  // 기본 지갑 생성(지갑 하나도 없을 때)

  /// 전체 지갑 로드
  Future<void> loadWallets() async {
    _wallets = await SecureStorageService.loadWalletList();
    final selectedAddress =
        await SecureStorageService.getSelectedWalletAddress();

    if (_wallets.isEmpty) {
      // 👉 기본 지갑 자동 생성
      final mnemonic = WalletService.generateMnemonic();
      final walletData = await WalletService.generateWalletFromMnemonic(
        mnemonic,
      );

      final defaultWallet = WalletModel(
        name: '기본 지갑',
        address: walletData['address']!,
        privateKey: walletData['privateKey']!,
        createdAt: DateTime.now(),
      );

      _wallets.add(defaultWallet);
      await SecureStorageService.saveWalletList(_wallets);
      await SecureStorageService.setSelectedWallet(defaultWallet.address);
      _selectedWallet = defaultWallet;
    } else {
      _selectedWallet = _wallets.firstWhere(
        (w) => w.address == selectedAddress,
        orElse: () => _wallets.first,
      );
    }

    notifyListeners();
    // _wallets = await SecureStorageService.loadWalletList();
    // final selectedAddress =
    //     await SecureStorageService.getSelectedWalletAddress();

    // if (_wallets.isEmpty) {
    //   _selectedWallet = null;
    // } else {
    //   _selectedWallet = _wallets.firstWhere(
    //     (w) => w.address == selectedAddress,
    //     orElse: () => _wallets.first,
    //   );
    // }

    // notifyListeners();
  }

  /// 지갑 이름 설정
  String? tempWalletName;

  void setTempWalletName(String name) {
    tempWalletName = name;
    notifyListeners();
  }

  /// 니모닉 생성 및 반환
  String generateAndReturnMnemonic() {
    _generatedMnemonic = WalletService.generateMnemonic();
    notifyListeners();
    return _generatedMnemonic!;
  }

  /// 지갑 생성 중단
  void discardTempWallet() {
    _generatedMnemonic = null;
    tempWalletName = null;
    notifyListeners();
  }

  /// 새 지갑 생성 및 저장
  Future<void> createAndSaveWallet(
    BuildContext context,
    String mnemonic,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      final walletData = await WalletService.generateWalletFromMnemonic(
        mnemonic,
      );
      final newWallet = WalletModel(
        name: tempWalletName ?? '지갑 ${_wallets.length + 1}',
        address: walletData['address']!,
        privateKey: walletData['privateKey']!,
        createdAt: DateTime.now(),
      );

      _wallets.add(newWallet);
      await SecureStorageService.saveWalletList(_wallets);
      await selectWallet(newWallet.address);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const WalletCreatedScreen(isRecovery: false),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('지갑 생성 실패: $e'), duration: Duration(seconds: 1)),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 지갑 복구
  Future<void> recoverWalletFromMnemonic(
    BuildContext context,
    String mnemonicInput,
  ) async {
    if (mnemonicInput.trim().split(' ').length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('12개의 니모닉 단어를 정확히 입력해주세요.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    try {
      final walletData = await WalletService.generateWalletFromMnemonic(
        mnemonicInput.trim(),
      );
      final newWallet = WalletModel(
        name: '복구 지갑 ${_wallets.length + 1}',
        address: walletData['address']!,
        privateKey: walletData['privateKey']!,
        createdAt: DateTime.now(),
      );

      _wallets.add(newWallet);
      await SecureStorageService.saveWalletList(_wallets);
      await selectWallet(newWallet.address);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const WalletCreatedScreen(isRecovery: true),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('복구 실패: $e'), duration: Duration(seconds: 1)),
      );
    }
  }

  /// 선택
  Future<void> selectWallet(String address) async {
    _selectedWallet = _wallets.firstWhere((w) => w.address == address);
    await SecureStorageService.setSelectedWallet(address);
    notifyListeners();
  }

  /// 삭제
  Future<void> deleteWallet(String address) async {
    await SecureStorageService.deleteWallet(address);
    await loadWallets();
  }

  /// 전체 초기화
  Future<void> clearAllWallets() async {
    await SecureStorageService.clearAll();
    _wallets.clear();
    _selectedWallet = null;
    notifyListeners();
  }
}
