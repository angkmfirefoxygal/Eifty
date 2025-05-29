import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eifty/viewmodels/transaction_viewmodel.dart';
import 'package:eifty/presentation/screens/qr/qr_scan_screen.dart';

class SelectRecipientScreen extends StatefulWidget {
  const SelectRecipientScreen({super.key});

  @override
  State<SelectRecipientScreen> createState() => _SelectRecipientScreenState();
}

class _SelectRecipientScreenState extends State<SelectRecipientScreen> {
  final TextEditingController _addressController = TextEditingController();
  final List<Map<String, String>> _recentAddresses = [
    {
      'name': 'Account 2',
      'address': '0x156f1aF64D4ca0Bc7cA5d903aAfB537A6763D88e',
    },
    {'name': 'Account 3', 'address': '0x23d554677d9809'},
    {'name': 'Account 4', 'address': '0xcd065095034gflv4'},
  ];

  void _selectAddress(String address) {
    _addressController.text = address;
    context.read<TransactionViewModel>().setRecipientAddress(address);
  }

  void _scanQRCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScanScreen()),
    );
  }

  void _goNext() {
    final address = _addressController.text.trim();
    if (address.isNotEmpty) {
      context.read<TransactionViewModel>().setRecipientAddress(address);
      Navigator.pushNamed(context, '/send/input-amount');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('수신자 주소를 입력해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('수신자 주소 입력', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanQRCode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: '수신자 주소 입력',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _addressController.clear(),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '최근 보낸 주소',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _recentAddresses.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final item = _recentAddresses[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(
                        item['name']![8],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(item['name']!),
                    subtitle: Text(item['address']!),
                    onTap: () => _selectAddress(item['address']!),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
