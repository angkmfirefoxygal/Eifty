import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WalletMnemonicScreen extends StatefulWidget {
  const WalletMnemonicScreen({super.key});

  @override
  State<WalletMnemonicScreen> createState() => _WalletMnemonicScreenState();
}

class _WalletMnemonicScreenState extends State<WalletMnemonicScreen> {
  String? mnemonic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<WalletViewModel>();
      final generated = vm.generateAndReturnMnemonic();
      setState(() {
        mnemonic = generated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mnemonicWords = mnemonic?.split(' ') ?? List.filled(12, '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('니모닉 생성'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (_) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('지갑 생성 취소'),
                    content: const Text('지갑 생성을 중단하시겠어요?\n진행 중인 정보는 모두 삭제됩니다.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('계속 생성'),
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
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              '생성된 니모닉 구절',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '이 구절은 지갑 복구에 필수적입니다.\n반드시 백업해 두세요!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: List.generate(6, (i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MnemonicItem(index: i + 1, word: mnemonicWords[i]),
                      _MnemonicItem(index: i + 7, word: mnemonicWords[i + 6]),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: mnemonicWords.join(' ')));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('클립보드에 복사되었습니다'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.copy, size: 18),
                  SizedBox(width: 6),
                  Text('클립보드에 복사'),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      mnemonic == null
                          ? null
                          : () async {
                            final vm = context.read<WalletViewModel>();
                            await vm.createAndSaveWallet(context, mnemonic!);
                            Navigator.pushNamed(context, '/wallet/confirm');
                          },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('니모닉 확인하기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MnemonicItem extends StatelessWidget {
  final int index;
  final String word;

  const _MnemonicItem({required this.index, required this.word});

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
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(word, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
