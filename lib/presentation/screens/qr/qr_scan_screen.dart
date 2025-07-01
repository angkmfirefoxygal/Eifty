import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:eifty/viewmodels/transaction_viewmodel.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool isScanned = false; // ✅ 중복 스캔 방지
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(facing: CameraFacing.back);
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카메라 권한이 필요합니다. 설정에서 허용해주세요.')),
      );
      Navigator.pop(context);
    }
  }

  void _handleBarcode(String code) async {
    if (isScanned) return; // 이미 처리했으면 무시

    setState(() {
      isScanned = true;
    });

    final address = code.trim();
    final isValid = RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(address);

    if (!isValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('유효한 지갑 주소가 아닙니다.')));
      return;
    }

    // 스캔 성공 시 카메라 멈춤
    await controller.stop();

    // 유효한 주소면 저장 후 다음 화면으로 이동
    context.read<TransactionViewModel>().setRecipientAddress(address);
    Navigator.pushReplacementNamed(context, '/send/input-amount');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 코드 스캔'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) {
          try {
            final code = capture.barcodes.first.rawValue;
            if (code != null && context.mounted) {
              _handleBarcode(code);
            }
          } catch (e) {
            debugPrint('QR 인식 중 오류: $e');
          }
        },
      ),
    );
  }
}
