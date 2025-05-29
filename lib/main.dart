import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/app/app.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:eifty/viewmodels/transaction_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(); // 💡 비동기로 .env 불러옴
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
