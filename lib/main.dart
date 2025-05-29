import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/app/app.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:eifty/viewmodels/transaction_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletViewModel()..loadWallets()),
        ChangeNotifierProvider(
          create: (_) => TransactionViewModel(),
        ), // ✅ 트랜잭션 추가
      ],
      child: const MyApp(),
    ),
  );
}
