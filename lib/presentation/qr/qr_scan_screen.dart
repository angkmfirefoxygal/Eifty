import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatelessWidget {
  const QRScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 코드 스캔'),
        backgroundColor: Colors.white, // ✅ 배경 흰색
        foregroundColor: Colors.black, // ✅ 텍스트/아이콘 검정
        elevation: 0, // ✅ 그림자 제거 (선택)
        iconTheme: const IconThemeData(color: Colors.black), // 뒤로가기 아이콘 색
      ),
      body: MobileScanner(
        controller: MobileScannerController(facing: CameraFacing.back),
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final code = barcodes.first.rawValue;
            if (code != null && context.mounted) {
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
