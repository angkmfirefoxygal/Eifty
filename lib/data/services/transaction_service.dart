import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:math';

class TransactionService {
  late final Web3Client _ethClient;
  late final int _chainId;

  Future<void> init({required String rpcUrl, required int chainId}) async {
    final httpClient = Client();
    _ethClient = Web3Client(rpcUrl, httpClient);
    _chainId = chainId;
  }

  // 가스비 조회
  Future<double> estimateGasFee({int gasLimit = 21000}) async {
    final gasPrice = await _ethClient.getGasPrice(); // Wei 단위
    final feeInWei = gasPrice.getInWei * BigInt.from(gasLimit);
    final feeInEther = feeInWei / BigInt.from(10).pow(18); // ETH 단위
    return feeInEther.toDouble();
  }

  Future<String> sendToken({
    required String recipientAddress,
    required double amount,
    required String tokenSymbol,
    required String privateKey,
  }) async {
    final credentials = EthPrivateKey.fromHex(privateKey);
    final sender = await credentials.extractAddress();

    try {
      final valueInWei = BigInt.from(amount * pow(10, 18));

      final transaction = Transaction(
        from: sender,
        to: EthereumAddress.fromHex(recipientAddress),
        value: EtherAmount.inWei(valueInWei),
        gasPrice: await _ethClient.getGasPrice(),
        maxGas: 21000,
      );

      final txHash = await _ethClient.sendTransaction(
        credentials,
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
      return balance.getValueInUnit(EtherUnit.ether);
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
