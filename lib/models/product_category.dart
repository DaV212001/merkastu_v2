class ProductCategory {
  final String? id;
  final String? name;
  final String? restaurantId;

  ProductCategory({this.id, this.name, this.restaurantId});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
        id: json['id'], name: json['name'], restaurantId: json['store_id']);
  }
}
