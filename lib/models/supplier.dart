class Supplier {
  final int supplierID;
  final String name;
  final String? address;
  final String? inn;
  final String? phone;

  Supplier({
    required this.supplierID,
    required this.name,
    this.address,
    this.inn,
    this.phone,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      supplierID: json['supplierID'],
      name: json['name'],
      address: json['address'],
      inn: json['inn'],
      phone: json['phone'],
    );
  }}