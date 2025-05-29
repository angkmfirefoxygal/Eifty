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
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('지갑 목록'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child:
            vm.uniqueWallets.isEmpty
                ? const Center(
                  child: Text(
                    '저장된 지갑이 없습니다.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                : ListView.separated(
                  itemCount: vm.uniqueWallets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final wallet = vm.uniqueWallets[index];
                    final isSelected =
                        wallet.address == vm.selectedWallet?.address;

                    return GestureDetector(
                      onTap: () => vm.selectWallet(wallet.address),
                      onLongPress: () => _showDeleteDialog(context, vm, wallet),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.grey.shade100 : Colors.white,
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.green
                                    : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wallet.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              wallet.address,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            if (isSelected)
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '선택됨',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWalletOptions(context),
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
            backgroundColor: Colors.white,
            title: const Text('지갑 삭제'),
            content: Text('"${wallet.name}" 지갑을 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await vm.deleteWallet(wallet.address);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${wallet.name}" 지갑이 삭제되었습니다.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }

  void _showAddWalletOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text('새 지갑 생성'),
                onTap: () {
                  Navigator.pop(context);
                  _showNameInputDialog(context);
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
              const SizedBox(height: 16),
            ],
          ),
    );
  }

  void _showNameInputDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('지갑 이름 설정'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: '예: 내 첫 번째 지갑'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  final name = nameController.text.trim();
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
}
