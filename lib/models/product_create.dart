class ProductCreate {
  final String name;
  final double price;
  final String? code;
  final int warehouseID;
  final int supplierID;
  final int initialQuantity;

  ProductCreate({
    required this.name,
    required this.price,
    this.code,
    required this.warehouseID,
    required this.supplierID,
    required this.initialQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'code': code,
      'warehouseID': warehouseID,
      'supplierID': supplierID,
      'initialQuantity': initialQuantity,
    };
  }
}
