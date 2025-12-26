class Product {
  final int productID;
  final String name;
  final double price;
  final String code;
  final String warehouse;
  final int quantity;

  Product({
    required this.productID,
    required this.name,
    required this.price,
    required this.code,
    required this.warehouse,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['productID'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      code: json['code'],
      warehouse: json['warehouse'],
      quantity: json['quantity'],
    );
  }
}
