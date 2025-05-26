class WalletModel {
  final String name;
  final String address;
  final String privateKey;
  final DateTime createdAt;

  WalletModel({
    required this.name,
    required this.address,
    required this.privateKey,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'address': address,
    'privateKey': privateKey,
    'createdAt': createdAt.toIso8601String(),
  };

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    name: json['name'] ?? '이름 없음',
    address: json['address'] ?? '',
    privateKey: json['privateKey'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}
