class TransactionModel {
  final int transactionID;
  final String productName;
  final String? supplierName;
  final int quantity;
  final String transactionType;
  final DateTime transactionDate;

  TransactionModel({
    required this.transactionID,
    required this.productName,
    this.supplierName,
    required this.quantity,
    required this.transactionType,
    required this.transactionDate,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionID: json['transactionID'],
      productName: json['productName'],
      supplierName: json['supplierName'],
      quantity: json['quantity'],
      transactionType: json['transactionType'],
      transactionDate: DateTime.parse(json['transactionDate']),
    );
  }
}
