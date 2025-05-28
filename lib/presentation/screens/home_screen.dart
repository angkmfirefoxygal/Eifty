// import 'package:eifty/viewmodels/wallet_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<WalletViewModel>();
//     final wallet = vm.selectedWallet;

//     return Scaffold(
//       appBar: AppBar(
//         forceMaterialTransparency: true,
//         title: const Text('내 지갑 홈'),
//         centerTitle: true,
//         elevation: 0,
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.account_balance_wallet_outlined),
//         //     onPressed: () => Navigator.pushNamed(context, '/wallet/list'),
//         //   ),
//         // ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child:
//             wallet == null
//                 ? const Center(
//                   child: Text(
//                     '선택된 지갑이 없습니다.',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 )
//                 : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       '현재 선택된 지갑',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             wallet.name,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           const Text(
//                             '주소',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             wallet.address,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/wallet/list');
//                         },
//                         icon: const Icon(Icons.manage_accounts),
//                         label: const Text('지갑 변경 / 관리'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//       ),
//     );
//   }
// }

import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // loadWallets는 한 번만 호출되도록 설정
    if (!_isLoaded) {
      context.read<WalletViewModel>().loadWallets();
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WalletViewModel>();
    final wallet = vm.selectedWallet;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('내 지갑 홈'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child:
            vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : wallet == null
                ? const Center(
                  child: Text(
                    '선택된 지갑이 없습니다.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '현재 선택된 지갑',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallet.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '주소',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            wallet.address,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/wallet/list');
                        },
                        icon: const Icon(Icons.manage_accounts),
                        label: const Text('지갑 변경 / 관리'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
