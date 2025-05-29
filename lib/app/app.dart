import 'package:eifty/presentation/screens/home_screen.dart';
import 'package:eifty/presentation/screens/send/input_amount_screen.dart';
import 'package:eifty/presentation/screens/wallet_list_screen.dart';
import 'package:eifty/presentation/screens/wallet_created_screen.dart';
import 'package:eifty/presentation/screens/main_screen.dart';
import 'package:eifty/view/wallet/wallet_mnemonic_confirm_screen.dart';
import 'package:eifty/view/wallet/wallet_mnemonic_screen.dart';
import 'package:eifty/view/wallet/wallet_recovery_screen.dart';
import 'package:flutter/material.dart';
//transaction 관련 import
import 'package:eifty/presentation/screens/send/select_recipient_screen.dart';
import 'package:eifty/presentation/screens/receive/receive_qr_screen.dart';
import 'package:eifty/presentation/screens/send/confirm_transaction_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eifty',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            splashFactory: NoSplash.splashFactory,
          ),
        ),
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

        // 메인 화면
        '/main': (context) => const MainScreen(),

        // 트랜잭션 관련
        '/send/select-recipient': (context) => const SelectRecipientScreen(),
        '/send/input-amount': (context) => const InputAmountScreen(),
        '/send/confirm': (context) => const ConfirmTransactionScreen(),
        '/receive/qr': (context) => const ReceiveQRScreen(),
      },
    );
  }
}
