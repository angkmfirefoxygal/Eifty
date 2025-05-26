import 'package:bip39/bip39.dart' as bip39;
import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletRecoveryScreen extends StatefulWidget {
  const WalletRecoveryScreen({super.key});

  @override
  State<WalletRecoveryScreen> createState() => _WalletRecoveryScreenState();
}

class _WalletRecoveryScreenState extends State<WalletRecoveryScreen> {
  final List<TextEditingController> _controllers = List.generate(
    12,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(12, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool _isMnemonicFilled() {
    return _controllers.every((c) => c.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = _isMnemonicFilled();

    return Scaffold(
      appBar: AppBar(
        title: const Text('지갑 복구'),
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('지갑 복구 취소'),
                    content: const Text('지갑 복구를 중단하시겠어요?\n진행 중인 정보는 모두 삭제됩니다.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('계속 복구'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('나가기'),
                      ),
                    ],
                  ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '니모닉 구절을 입력하세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: List.generate(6, (i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MnemonicInputField(
                        index: i + 1,
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        onFieldSubmitted:
                            (_) => _focusNodes[i + 1].requestFocus(),
                      ),
                      _MnemonicInputField(
                        index: i + 7,
                        controller: _controllers[i + 6],
                        focusNode: _focusNodes[i + 6],
                        onFieldSubmitted: (_) {
                          if (i + 6 < 11) {
                            _focusNodes[i + 7].requestFocus();
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                    ],
                  );
                }),
              ),
            ),
            ElevatedButton(
              onPressed:
                  isFilled
                      ? () {
                        final mnemonic = _controllers
                            .map((c) => c.text.trim())
                            .join(' ');
                        final vm = context.read<WalletViewModel>();
                        vm.recoverWalletFromMnemonic(context, mnemonic);
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFilled ? Colors.black : Colors.grey.shade300,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('복구하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MnemonicInputField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onFieldSubmitted;

  const _MnemonicInputField({
    required this.index,
    required this.controller,
    required this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.38,
        child: Row(
          children: [
            Text('$index', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.next,
                onSubmitted: onFieldSubmitted,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
