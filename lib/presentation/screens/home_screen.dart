import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WalletViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 화면 예시'),
        forceMaterialTransparency: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            vm.generateMnemonic(); // 니모닉 먼저 생성
            Navigator.pushNamed(context, '/wallet/mnemonic'); // 니모닉 확인 화면으로 이동
          },
          child: const Text('지갑 생성하기'),
        ),
      ),
    );
  }
}
