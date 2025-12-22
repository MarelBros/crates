class Product {
  final int productID;
  final String name;
  final int warehouseID;
  final int supplierID;
  final int quantity;
  final String productCode;

  Product({
    required this.productID,
    required this.name,
    required this.warehouseID,
    required this.supplierID,
    required this.quantity,
    required this.productCode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['productID'],
      name: json['name'],
      warehouseID: json['warehouseID'],
      supplierID: json['supplierID'],
      quantity: json['quantity'],
      productCode: json['productCode'],
    );
  }
}
