class ProductCreate {
  final String name;
  final int warehouseID;
  final int supplierID;
  final int quantity;
  final String productCode;

  ProductCreate({
    required this.name,
    required this.warehouseID,
    required this.supplierID,
    required this.quantity,
    required this.productCode,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'warehouseID': warehouseID,
        'supplierID': supplierID,
        'quantity': quantity,
        'productCode': productCode,
      };
}