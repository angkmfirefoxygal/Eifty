import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WalletViewModel>();
    final wallet = vm.selectedWallet;

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 지갑 홈'),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () => Navigator.pushNamed(context, '/wallet/list'),
          ),
        ],
      ),
      body: Center(
        child:
            wallet == null
                ? const Text('선택된 지갑이 없습니다.')
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('선택된 지갑', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      '이름: ${wallet.name}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('주소: ${wallet.address}', textAlign: TextAlign.center),
                  ],
                ),
      ),
    );
  }
}
