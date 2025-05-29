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
  bool isLoading = true;
  List<Map<String, dynamic>> transactions = [];
  String? address;

  final Color iconColor = const Color(0xFF667C8A);

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    address = await SecureStorageService.getSelectedWalletAddress();
    if (address == null) {
      print('❌ 지갑 주소가 null입니다.');
      return;
    }

    print('🔍 현재 선택된 지갑 주소: $address');

    final balance = await TransactionService.getPolBalance(address!);
    final price = await fetchPrice('matic-network');
    await fetchTransactionHistory(address!);

    setState(() {
      polBalance = balance;
      polPrice = price;
      isLoading = false;
    });
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

  Future<void> fetchTransactionHistory(String address) async {
    final url = Uri.parse(
      'https://api-amoy.polygonscan.com/api?module=account&action=txlist'
      '&address=$address&startblock=0&endblock=99999999&sort=desc',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == '1') {
        final result = data['result'] as List;
        setState(() {
          transactions = result.cast<Map<String, dynamic>>();
        });
      } else {
        print('⚠️ 트랜잭션 없음');
      }
    } else {
      print('❌ 트랜잭션 조회 실패');
    }
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'POL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                      child:
                          transactions.isEmpty
                              ? Center(
                                child: Text(
                                  '최근 트랜잭션이 없습니다.',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              )
                              : ListView.builder(
                                itemCount: transactions.length.clamp(0, 10),
                                itemBuilder: (context, index) {
                                  final tx = transactions[index];
                                  final from =
                                      tx['from'].toString().toLowerCase();
                                  final to = tx['to'].toString().toLowerCase();
                                  final isSend =
                                      from == (address ?? '').toLowerCase();
                                  final value =
                                      BigInt.parse(tx['value']) /
                                      BigInt.from(10).pow(18);
                                  final time =
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(tx['timeStamp']) * 1000,
                                      );

                                  return ListTile(
                                    leading: Icon(
                                      isSend
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: isSend ? Colors.red : Colors.green,
                                    ),
                                    title: Text(isSend ? '보냄' : '받음'),
                                    subtitle: Text(
                                      isSend
                                          ? 'To: ${to.substring(0, 8)}...'
                                          : 'From: ${from.substring(0, 8)}...',
                                    ),
                                    trailing: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${value.toStringAsFixed(5)} POL',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${time.month}/${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}
