import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WalletMnemonicScreen extends StatelessWidget {
  const WalletMnemonicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WalletViewModel>();
    final mnemonicWords = vm.mnemonic?.split(' ') ?? [];

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
                        onPressed: () => Navigator.pop(context), // 닫기
                        child: const Text('계속 생성'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 모달 닫기
                          Navigator.pop(context); // 이전 화면으로 이동
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
            SizedBox(height: 15),
            // 타이틀
            Text(
              '생성된 니모닉 구절',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 경고 텍스트
            const Text(
              '이 구절은 지갑 복구에 필수적입니다.\n반드시 백업해 두세요!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 20),

            // 니모닉 1~12 라운드 박스
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: List.generate(6, (i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MnemonicItem(
                        index: i + 1,
                        word: mnemonicWords.length > i ? mnemonicWords[i] : '',
                      ),
                      _MnemonicItem(
                        index: i + 7,
                        word:
                            mnemonicWords.length > i + 6
                                ? mnemonicWords[i + 6]
                                : '',
                      ),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // 클립보드 복사
            GestureDetector(
              onTap: () {
                if (mnemonicWords.isNotEmpty) {
                  Clipboard.setData(
                    ClipboardData(text: mnemonicWords.join(' ')),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('클립보드에 복사되었습니다')),
                  );
                }
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

            // 확인 버튼
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    MnemonicWarningDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black87,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('확인'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> MnemonicWarningDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true, // 바깥 터치 시 닫힘
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '니모닉 구절을 분실하면\n지갑을 복구할 수 없습니다!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• 니모닉을 외부에 저장하지 마세요.'),
                          Text('• 다른 사람과 니모닉을 공유하지 마세요.'),
                          Text('• 니모닉은 오프라인 환경에 기록해 두는 것을 권장합니다.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // 모달 닫기

                          final vm = context.read<WalletViewModel>();
                          await vm.createAndSaveWallet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('확인'),
                      ),
                    ),
                  ],
                ),
              ),

              // 닫기 버튼 (X)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MnemonicItem extends StatelessWidget {
  final int index;
  final String word;

  const _MnemonicItem({super.key, required this.index, required this.word});

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
