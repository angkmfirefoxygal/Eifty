import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';

class WalletMnemonicScreen extends StatelessWidget {
  const WalletMnemonicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WalletViewModel>();
    final mnemonicWords = vm.mnemonic?.split(' ') ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('니모닉 구절')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...List.generate(6, (i) {
              final left = mnemonicWords[i];
              final right = mnemonicWords[i + 6];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text('${i + 1}. $left'), Text('${i + 7}. $right')],
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  vm.isLoading ? null : () => vm.createAndSaveWallet(context),
              child:
                  vm.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
