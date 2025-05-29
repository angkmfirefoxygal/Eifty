import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:math';

class TransactionService {
  static final String rpcUrl = 'https://polygon-rpc.com'; // 또는 Infura/Alchemy
  static final String privateKey = '<당신의 프라이빗 키>'; // 실제론 secure하게 관리할 것
  static final int chainId = 137; // Polygon Mainnet

  static Future<String> sendToken({
    required String recipientAddress,
    required double amount,
    required String tokenSymbol,
  }) async {
    final httpClient = Client();
    final ethClient = Web3Client(rpcUrl, httpClient);

    try {
      // 🔑 지갑 생성
      final credentials = EthPrivateKey.fromHex(privateKey);
      final senderAddress = await credentials.extractAddress();

      // 🎯 이더 단위 변환
      final valueInWei = BigInt.from(amount * pow(10, 18)); // 1 POL = 10^18 wei

      final transaction = Transaction(
        from: senderAddress,
        to: EthereumAddress.fromHex(recipientAddress),
        value: EtherAmount.inWei(valueInWei),
        gasPrice: await ethClient.getGasPrice(),
        maxGas: 21000,
      );

      // 🚀 트랜잭션 전송
      final txHash = await ethClient.sendTransaction(
        credentials,
        transaction,
        chainId: chainId,
      );

      return txHash;
    } catch (e) {
      print('트랜잭션 에러: $e');
      rethrow;
    } finally {
      ethClient.dispose();
    }
  }

  static Future<double> getEthBalance(String address) async {
    final ethClient = Web3Client(
      'https://mainnet.infura.io/v3/YOUR_INFURA_KEY',
      Client(),
    );

    try {
      final ethAddress = EthereumAddress.fromHex(address);
      final balance = await ethClient.getBalance(ethAddress);
      return balance.getValueInUnit(EtherUnit.ether);
    } catch (e) {
      print('ETH 잔액 조회 에러: $e');
      return 0.0;
    } finally {
      ethClient.dispose();
    }
  }

  static Future<double> getPolBalance(String address) async {
    final polClient = Web3Client('https://polygon-rpc.com', Client());

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
}
