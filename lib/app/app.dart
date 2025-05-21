import 'package:eifty/presentation/screens/home_screen.dart';
import 'package:eifty/presentation/screens/wallet_created_screen.dart';
import 'package:eifty/view/wallet/wallet_mnemonic_screen.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WalletViewModel())],
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
          '/wallet/created': (context) => const WalletCreatedScreen(),
        },
      ),
    );
  }
}
