class Warehouse {
  final int warehouseID;
  final String name;

  Warehouse({
    required this.warehouseID,
    required this.name,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      warehouseID: json['warehouseID'],
      name: json['name'],
    );
  }
}