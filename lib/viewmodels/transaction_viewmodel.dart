import 'package:flutter/material.dart';
import 'package:eifty/data/services/secure_storage_service.dart';
import 'package:eifty/data/services/transaction_service.dart';

class TransactionViewModel extends ChangeNotifier {
  String? recipientAddress;
  double? amount;
  String selectedToken = 'POL'; // 기본값
  double fee = 0.1; // 기본 수수료
  bool isLoading = false;
  String? transactionHash;

  /// 수신자 주소 설정
  void setRecipientAddress(String address) {
    recipientAddress = address;
    notifyListeners();
  }

  /// 금액 설정
  void setAmount(double value) {
    amount = value;
    notifyListeners();
  }

  /// 토큰 설정
  void setToken(String token) {
    selectedToken = token;
    notifyListeners();
  }

  /// 수수료 설정
  void setFee(double value) {
    fee = value;
    notifyListeners();
  }

  /// 수수료 계산
  Future<void> fetchFeeEstimate() async {
    try {
      isLoading = true;
      notifyListeners();

      final selectedAddress =
          await SecureStorageService.getSelectedWalletAddress();
      if (selectedAddress == null) throw Exception('선택된 지갑이 없습니다.');

      final service = TransactionService();

      await service.init(
        rpcUrl: 'https://rpc-amoy.polygon.technology',
        chainId: 80002,
      );

      final estimatedFee = await service.estimateGasFee(gasLimit: 21000);
      fee = double.parse(estimatedFee.toStringAsFixed(6)); // 소수 6자리
    } catch (e) {
      debugPrint('수수료 계산 실패: $e');
      fee = 0.0; // fallback
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 트랜잭션 실행
  Future<bool> sendTransaction() async {
    if (recipientAddress == null || amount == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      final selectedAddress =
          await SecureStorageService.getSelectedWalletAddress();
      if (selectedAddress == null) throw Exception('선택된 지갑이 없습니다.');

      final privateKey = await SecureStorageService.getPrivateKey(
        selectedAddress,
      );
      if (privateKey == null) throw Exception('Private Key가 존재하지 않습니다.');

      final service = TransactionService();

      await service.init(
        rpcUrl: 'https://rpc-amoy.polygon.technology',
        chainId: 80002,
      );

      final hash = await service.sendToken(
        recipientAddress: recipientAddress!,
        amount: amount!,
        tokenSymbol: selectedToken,
        privateKey: privateKey,
      );

      transactionHash = hash;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('트랜잭션 실패: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 초기화
  void reset() {
    recipientAddress = null;
    amount = null;
    selectedToken = 'POL';
    fee = 0.1;
    transactionHash = null;
    isLoading = false;
    notifyListeners();
  }
}
