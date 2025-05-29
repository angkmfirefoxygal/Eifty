import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eifty/data/services/secure_storage_service.dart';
import 'package:eifty/data/services/transaction_service.dart';

class WalletMainScreen extends StatefulWidget {
  const WalletMainScreen({super.key});

  @override
  State<WalletMainScreen> createState() => _WalletMainScreenState();
}

class _WalletMainScreenState extends State<WalletMainScreen> {
  double ethBalance = 0.0;
  double ethPrice = 0.0;

  // @override
  // void initState() {
  //   super.initState();
  //   loadWalletBalance();
  //   fetchETHPrice();
  // }

  // Future<void> loadWalletBalance() async {
  //   final address = await SecureStorageService.getSelectedWalletAddress();
  //   if (address == null) return;

  //   final balance = await TransactionService.getEthBalance(address);
  //   setState(() {
  //     ethBalance = balance;
  //   });
  // }

  Future<void> fetchETHPrice() async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          ethPrice = data['ethereum']['usd'] ?? 0.0;
        });
      } else {
        print('가격 로딩 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  String get formattedPrice =>
      '\$${(ethBalance * ethPrice).toStringAsFixed(2)}';

  void _send() {
    Navigator.pushNamed(context, '/send/select-recipient');
  }

  void _receive() {
    Navigator.pushNamed(context, '/receive/qr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'ETH',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Ethereum', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.account_balance_wallet_outlined),
            ),
            const SizedBox(height: 10),
            Text(
              '${ethBalance.toStringAsFixed(4)} ETH',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(formattedPrice, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _send,
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('전송'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _receive,
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('수신'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const Divider(height: 40),
            Expanded(
              child: Center(
                child: Text(
                  '트랜잭션이 표시됩니다.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
