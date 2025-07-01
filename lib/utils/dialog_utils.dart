import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:eifty/models/wallet_model.dart';

/// 지갑 생성 시 이름 입력 다이얼로그
Future<void> showWalletNameInputDialog(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  await showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('지갑 이름 설정'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: '예: 내 첫 번째 지갑'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  context.read<WalletViewModel>().setTempWalletName(name);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wallet/mnemonic');
                }
              },
              child: const Text('확인'),
            ),
          ],
        ),
  );
}

/// 지갑 이름 변경 다이얼로그
Future<void> showWalletRenameDialog(
  BuildContext context,
  WalletModel wallet,
) async {
  final vm = context.read<WalletViewModel>();
  final controller = TextEditingController(text: wallet.name);

  await showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('지갑 이름 변경'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  await vm.renameWallet(wallet.address, newName);
                  Navigator.pop(context);
                }
              },
              child: const Text('확인'),
            ),
          ],
        ),
  );
}
