import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';

class WalletMnemonicConfirmScreen extends StatefulWidget {
  const WalletMnemonicConfirmScreen({super.key});

  @override
  State<WalletMnemonicConfirmScreen> createState() =>
      _WalletMnemonicConfirmScreenState();
}

class _WalletMnemonicConfirmScreenState
    extends State<WalletMnemonicConfirmScreen> {
  late List<String> correctWords;
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  int failCount = 0;

  @override
  void initState() {
    super.initState();
    final vm = context.read<WalletViewModel>();
    correctWords = vm.mnemonic?.split(' ') ?? [];
    controllers = List.generate(12, (_) => TextEditingController());
    focusNodes = List.generate(12, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _validateAll() {
    final inputs = controllers.map((c) => c.text.trim()).toList();
    bool allMatch = true;
    for (int i = 0; i < 12; i++) {
      if (inputs[i] != correctWords[i]) {
        allMatch = false;
        break;
      }
    }

    if (allMatch) {
      Navigator.pushReplacementNamed(context, '/wallet/created');
    } else {
      setState(() {
        failCount += 1;
      });

      if (failCount >= 3) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('다시 확인해주세요'),
                content: const Text('입력한 단어들이 모두 일치하지 않습니다.\n니모닉을 다시 확인하시겠어요?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('아니오'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('/wallet/mnemonic'),
                      );
                    },
                    child: const Text('니모닉 보기'),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('단어가 일치하지 않습니다. 다시 시도해주세요.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Widget _buildWordInput(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.38,
        child: Row(
          children: [
            Text(
              '${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    if (index < 11) {
                      focusNodes[index + 1].requestFocus();
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: '단어 입력',
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('니모닉 확인'),
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
                          final vm = context.read<WalletViewModel>();
                          vm.discardTempWallet(); // 생성 중인 지갑 정보 삭제

                          Navigator.pop(context); // 다이얼로그 닫기
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          ); // 홈으로 이동
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
              '니모닉을 순서대로 입력해 주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '입력한 단어가 정확하지 않으면\n지갑 생성을 완료할 수 없습니다.',
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
                    children: [_buildWordInput(i), _buildWordInput(i + 6)],
                  );
                }),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
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
}
