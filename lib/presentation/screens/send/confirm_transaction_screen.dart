import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/viewmodels/transaction_viewmodel.dart';

class ConfirmTransactionScreen extends StatefulWidget {
  const ConfirmTransactionScreen({super.key});

  @override
  State<ConfirmTransactionScreen> createState() =>
      _ConfirmTransactionScreenState();
}

class _ConfirmTransactionScreenState extends State<ConfirmTransactionScreen> {
  @override
  void initState() {
    super.initState();
    // 수수료는 화면이 처음 로드될 때 한 번만 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final txVM = context.read<TransactionViewModel>();
      txVM.fetchFeeEstimate();
    });
  }

  Future<void> _submitTransaction(BuildContext context) async {
    final txVM = context.read<TransactionViewModel>();

    final success = await txVM.sendTransaction();

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ 전송 성공!')));
      Navigator.popUntil(context, ModalRoute.withName('/'));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ 전송 실패')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final txVM = context.watch<TransactionViewModel>();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${txVM.recipientAddress}로',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '${txVM.amount} ${txVM.selectedToken}을 보내시겠습니까?',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            txVM.isLoading
                ? const Text(
                  '수수료 계산 중...',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
                : Text(
                  '수수료: ${txVM.fee} ${txVM.selectedToken}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    txVM.isLoading ? null : () => _submitTransaction(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    txVM.isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                        : const Text('보내기'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: txVM.isLoading ? null : () => Navigator.pop(context),
                child: const Text('취소', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
