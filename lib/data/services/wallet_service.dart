import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'package:convert/convert.dart';

class WalletService {
  /// 니모닉 12단어 생성
  static String generateMnemonic() {
    return bip39.generateMnemonic(); // 기본 128bit → 12단어
  }

  /// 니모닉으로부터 지갑 생성 (MATIC 주소)
  static Future<Map<String, String>> generateWalletFromMnemonic(
    String mnemonic,
  ) async {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('유효하지 않은 니모닉입니다.');
    }

    // 니모닉 → 시드
    final seed = bip39.mnemonicToSeed(mnemonic);

    // 시드의 앞부분 32바이트 → private key로 사용
    final privateKey = seed.sublist(0, 32);
    final hexPrivateKey = hex.encode(privateKey);

    // Web3dart 지갑 생성
    final credentials = EthPrivateKey.fromHex(hexPrivateKey);
    final address = await credentials.extractAddress();

    return {
      'mnemonic': mnemonic,
      'privateKey': hexPrivateKey,
      'address': address.hexEip55,
    };
  }
}
