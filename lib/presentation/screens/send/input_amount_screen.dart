import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/viewmodels/transaction_viewmodel.dart';

class InputAmountScreen extends StatefulWidget {
  const InputAmountScreen({super.key});

  @override
  State<InputAmountScreen> createState() => _InputAmountScreenState();
}

class _InputAmountScreenState extends State<InputAmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<String> _tokenOptions = ['POL', 'ETH'];

  @override
  void initState() {
    super.initState();

    final vm = context.read<TransactionViewModel>();

    // 기존 값 세팅
    _amountController.text = vm.amount?.toString() ?? '';

    // 수수료 조회 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchFeeEstimate();
    });
  }

  void _goNext() {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty || double.tryParse(amountText) == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이체 금액을 정확히 입력해주세요.')));
      return;
    }

    context.read<TransactionViewModel>().setAmount(double.parse(amountText));
    Navigator.pushNamed(context, '/send/confirm');
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: txVM.selectedToken,
              onChanged: (String? newToken) {
                if (newToken != null) {
                  final vm = context.read<TransactionViewModel>();
                  vm.setToken(newToken);
                  vm.fetchFeeEstimate();
                }
              },
              items:
                  _tokenOptions.map((String token) {
                    return DropdownMenuItem<String>(
                      value: token,
                      child: Text(token),
                    );
                  }).toList(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              icon: const Icon(Icons.arrow_drop_down),
              dropdownColor: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text('이체 금액', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) {
                final vm = context.read<TransactionViewModel>();
                final parsed = double.tryParse(value);
                if (parsed != null) {
                  vm.setAmount(parsed);
                  vm.fetchFeeEstimate();
                }
              },
              decoration: InputDecoration(
                suffixText: txVM.selectedToken,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ 수수료 텍스트 처리
            txVM.isLoading
                ? const Text(
                  '수수료 계산 중...',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                )
                : Text(
                  '수수료: ${txVM.fee} ${txVM.selectedToken}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
