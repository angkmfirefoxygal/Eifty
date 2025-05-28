import 'package:eifty/presentation/screens/home_screen.dart';
import 'package:eifty/presentation/screens/wallet_list_screen.dart';
import 'package:eifty/presentation/screens/wallet_created_screen.dart';
import 'package:eifty/view/wallet/main_screen.dart';
import 'package:eifty/view/wallet/wallet_mnemonic_confirm_screen.dart';
import 'package:eifty/view/wallet/wallet_mnemonic_screen.dart';
import 'package:eifty/view/wallet/wallet_recovery_screen.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalletViewModel()..loadWallets(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eifty',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/wallet/mnemonic': (context) => const WalletMnemonicScreen(),
          '/wallet/confirm': (context) => const WalletMnemonicConfirmScreen(),
          '/wallet/created': (context) => const WalletCreatedScreen(),
          '/wallet/recover': (context) => const WalletRecoveryScreen(),
          '/wallet/list': (context) => const WalletListScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}
