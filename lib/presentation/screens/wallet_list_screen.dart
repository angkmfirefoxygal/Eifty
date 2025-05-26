import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/models/wallet_model.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';

class WalletListScreen extends StatelessWidget {
  const WalletListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WalletViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('지갑 목록')),
      body:
          vm.wallets.isEmpty
              ? const Center(child: Text('저장된 지갑이 없습니다.'))
              : ListView.separated(
                itemCount: vm.wallets.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final wallet = vm.wallets[index];
                  final isSelected =
                      wallet.address == vm.selectedWallet?.address;

                  return ListTile(
                    title: Text(wallet.name),
                    subtitle: Text(wallet.address),
                    trailing:
                        isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                    onTap: () => vm.selectWallet(wallet.address),
                    onLongPress: () => _showDeleteDialog(context, vm, wallet),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWalletOptions(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WalletViewModel vm,
    WalletModel wallet,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('지갑 삭제'),
            content: Text('${wallet.name} 지갑을 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await vm.deleteWallet(wallet.address);
                },
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }

  void _showAddWalletOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text('새 지갑 생성'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wallet/mnemonic');
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('지갑 복구'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/wallet/recover');
                },
              ),
            ],
          ),
    );
  }
}
