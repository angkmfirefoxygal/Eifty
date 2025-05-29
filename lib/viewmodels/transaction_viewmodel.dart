import 'package:flutter/material.dart';
import 'package:eifty/models/transaction_model.dart';
import 'package:eifty/data/services/transaction_service.dart';

class TransactionViewModel extends ChangeNotifier {
  String? recipientAddress;
  double? amount;
  String selectedToken = 'POL'; // 기본값: POL
  double fee = 0.1; // 추후 동적 수수료 처리 가능
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

  /// 토큰 종류 선택
  void setToken(String token) {
    selectedToken = token;
    notifyListeners();
  }

  /// 수수료 동적으로 계산할 수도 있음
  void setFee(double value) {
    fee = value;
    notifyListeners();
  }

  /// 트랜잭션 실행
  Future<bool> sendTransaction() async {
    if (recipientAddress == null || amount == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      final service = TransactionService(); // 👈 인스턴스 생성
      final hash = await service.sendToken(
        recipientAddress: recipientAddress!,
        amount: amount!,
        tokenSymbol: selectedToken,
      );

      transactionHash = hash;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('트랜잭션 실패: $e');
      return false;
    }
  }

  /// 초기화 (다음 전송을 위해)
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
