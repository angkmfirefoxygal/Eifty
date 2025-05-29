import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 📦 dotenv 사용
import 'dart:math';

class TransactionService {
  late final Web3Client _ethClient;
  late final EthPrivateKey _credentials;
  late final EthereumAddress _senderAddress;
  late final int _chainId; // ✅ 클래스 멤버로 정의

  // ✅ 비동기 초기화
  Future<void> init() async {
    final rpcUrl = dotenv.env['RPC_URL'];
    final privateKey = dotenv.env['PRIVATE_KEY'];
    final chainId = int.parse(dotenv.env['CHAIN_ID']!);

    if (rpcUrl == null || privateKey == null) {
      throw Exception('❗️환경변수(RPC_URL 또는 PRIVATE_KEY)가 설정되지 않았습니다.');
    }

    final httpClient = Client();
    _ethClient = Web3Client(rpcUrl, httpClient);
    _credentials = EthPrivateKey.fromHex(privateKey);
    _senderAddress = await _credentials.extractAddress();
    _chainId = chainId; // ✅ 멤버에 저장
  }

  Future<String> sendToken({
    required String recipientAddress,
    required double amount,
    required String tokenSymbol, // ✨ 향후 확장 대비 포함
  }) async {
    try {
      final valueInWei = BigInt.from(
        amount * pow(10, 18),
      ); // 1 MATIC = 10^18 wei

      final transaction = Transaction(
        from: _senderAddress,
        to: EthereumAddress.fromHex(recipientAddress),
        value: EtherAmount.inWei(valueInWei),
        gasPrice: await _ethClient.getGasPrice(),
        maxGas: 21000,
      );

      final txHash = await _ethClient.sendTransaction(
        _credentials,
        transaction,
        chainId: _chainId,
      );

      return txHash;
    } catch (e) {
      print('🚨 트랜잭션 에러: $e');
      rethrow;
    }
  }

  static Future<double> getPolBalance(String address) async {
    final polClient = Web3Client(
      'https://rpc-amoy.polygon.technology',
      Client(),
    );

    try {
      final ethAddress = EthereumAddress.fromHex(address);
      final balance = await polClient.getBalance(ethAddress);
      return balance.getValueInUnit(EtherUnit.ether); // 단위는 ETH와 동일 (wei 기반)
    } catch (e) {
      print('POL 잔액 조회 에러: $e');
      return 0.0;
    } finally {
      polClient.dispose();
    }
  }

  void dispose() {
    _ethClient.dispose();
  }
}
