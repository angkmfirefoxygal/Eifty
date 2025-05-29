import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WalletViewModel extends ChangeNotifier {
  final String walletAddress = '0xYourEthereumAddressHere';
  final String rpcUrl = 'https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID';

  double? ethBalance;
  double? usdValue;

  bool isLoading = true;

  Future<void> loadBalance() async {
    try {
      final client = Web3Client(rpcUrl, http.Client());
      final address = EthereumAddress.fromHex(walletAddress);
      final balance = await client.getBalance(address);
      ethBalance = balance.getValueInUnit(EtherUnit.ether).toDouble();

      final res = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd',
        ),
      );
      final price = json.decode(res.body)['ethereum']['usd'];
      usdValue = ethBalance! * price;

      client.dispose();
    } catch (e) {
      print('Error loading balance: $e');
      ethBalance = 0;
      usdValue = 0;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class WalletHomeScreen extends StatefulWidget {
  const WalletHomeScreen({super.key});

  @override
  State<WalletHomeScreen> createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<WalletViewModel>().loadBalance());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WalletViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'ETH',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Ethereum',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${vm.ethBalance?.toStringAsFixed(4) ?? "0"} ETH',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${vm.usdValue?.toStringAsFixed(2) ?? "0.00"}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _ActionButton(icon: Icons.arrow_upward, label: '전송'),
                        SizedBox(width: 20),
                        _ActionButton(icon: Icons.arrow_downward, label: '수신'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Divider(thickness: 1),
                    const Expanded(
                      child: Center(
                        child: Text(
                          '트랜잭션이 표시됩니다.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
