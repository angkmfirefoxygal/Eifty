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
  double polBalance = 0.0;
  double polPrice = 0.0;

  final Color iconColor = const Color(0xFF667C8A);

  @override
  void initState() {
    super.initState();
    loadBalances();
  }

  Future<void> loadBalances() async {
    final address = await SecureStorageService.getSelectedWalletAddress();
    if (address == null) return;

    polBalance = await TransactionService.getPolBalance(address);
    polPrice = await fetchPrice('matic-network');

    setState(() {});
  }

  Future<double> fetchPrice(String coinId) async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=$coinId&vs_currencies=usd',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data[coinId]['usd'] ?? 0.0) as double;
    }
    return 0.0;
  }

  String get selectedSymbol => 'POL';
  double get selectedBalance => polBalance;
  double get selectedPrice => polPrice;

  String get formattedPrice =>
      '\$${(selectedBalance * selectedPrice).toStringAsFixed(2)}';

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('지갑 메인'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'POL',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Polygon', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade300,
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${selectedBalance.toStringAsFixed(4)} $selectedSymbol',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(formattedPrice, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _send,
                  icon: Icon(Icons.arrow_upward, color: iconColor),
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
                  icon: Icon(Icons.arrow_downward, color: iconColor),
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
