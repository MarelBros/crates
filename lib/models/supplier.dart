class Supplier {
  final int supplierID;
  final String name;

  Supplier({required this.supplierID, required this.name});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      supplierID: json['supplierID'],
      name: json['name'],
    );
  }
}