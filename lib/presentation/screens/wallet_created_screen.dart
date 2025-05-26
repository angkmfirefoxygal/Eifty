import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';

class WalletCreatedScreen extends StatelessWidget {
  final bool isRecovery;

  const WalletCreatedScreen({super.key, this.isRecovery = false});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WalletViewModel>();
    final wallet = vm.selectedWallet;

    return Scaffold(
      appBar: AppBar(title: Text(isRecovery ? '지갑 복구 완료' : '지갑 생성 완료')),
      body:
          wallet == null
              ? const Center(child: CircularProgressIndicator())
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isRecovery ? '지갑이 성공적으로 복구되었습니다!' : '지갑이 성공적으로 생성되었습니다!',
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '지갑 이름: ${wallet.name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '주소:\n${wallet.address}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: const Text('홈으로 이동'),
                    ),
                  ],
                ),
              ),
    );
  }
}
