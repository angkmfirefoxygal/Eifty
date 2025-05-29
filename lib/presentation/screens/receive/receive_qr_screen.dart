import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:eifty/viewmodels/wallet_viewmodel.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ReceiveQRScreen extends StatelessWidget {
  const ReceiveQRScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletViewModel>().selectedWallet;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('받기'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [Tab(text: 'QR 코드 스캔'), Tab(text: '내 QR 코드')],
            labelColor: Colors.black, // 선택된 탭 글자색
            unselectedLabelColor: Colors.grey, // 선택 안된 탭
            indicatorColor: Colors.black, // 탭 아래 인디케이터 색
            labelStyle: TextStyle(
              // ✅ 선택된 탭 텍스트 스타일
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              // 선택되지 않은 탭
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        body:
            wallet == null
                ? const Center(child: Text('선택된 지갑이 없습니다.'))
                : TabBarView(
                  children: [
                    /// 🔹 QR 코드 스캔 화면
                    MobileScanner(
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final code = barcodes.first.rawValue;
                          if (code != null && context.mounted) {
                            Navigator.pop(context, code);
                          }
                        }
                      },
                    ),

                    /// 🔹 내 QR 코드 화면
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          QrImageView(
                            data: wallet.address,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            wallet.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(wallet.address, textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: wallet.address),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('주소가 복사되었습니다')),
                              );
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('주소 복사'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
