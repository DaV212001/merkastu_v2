import 'package:collection/collection.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/models/addon.dart';

class Product {
  final String? id;
  final num? price;
  final String? name;
  final String? description;
  final String? image;
  final String? storeId;
  final String? categoryId;
  final List<Addon>? addons;
  int? amount = 1;
  bool? favorited = false;
  bool? isSelected = false;

  Product(
      {this.id,
      this.price,
      this.name,
      this.description,
      this.image,
      this.storeId,
      this.categoryId,
      this.addons,
      this.amount,
      this.favorited = false});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'name': name,
      'description': description,
      'image': image,
      'store_id': storeId,
      'category_id': categoryId,
      'addons': addons != null
          ? addons
              ?.map((addon) => {
                    'id': addon.id,
                    'name': addon.name,
                    'price': addon.price,
                    'product_id': addon.productId,
                  })
              .toList()
          : []
    };
  }

  bool isTheSameAs(Product product) {
    bool isSame = (id == product.id &&
        const UnorderedIterableEquality().equals(addons, product.addons));
    return isSame;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        price: json['price'],
        name: (json['name'] as String).trim(),
        description: (json['description'] as String).trim(),
        image: kProductImagebaseUrl + json['image'],
        storeId: json['store_id'],
        categoryId: json['category_id'],
        addons: ((json['Addon'] ?? []) as List)
            .map((addon) => Addon(
                  id: addon['id'],
                  name: addon['name'],
                  price: addon['price'],
                  productId: addon['product_id'],
                ))
            .toList(),
        amount: 1);
  }
  factory Product.fromOrderDetailJson(
      Map<String, dynamic> json, String storeId) {
    return Product(
        id: json['id'],
        price: json['product_price'],
        name: (json['product_name'] as String).trim(),
        storeId: storeId,
        addons: ((json['order_addons'] ?? []) as List)
            .map((addon) => Addon(
                  id: addon['addon_id'],
                  name: addon['name'],
                  price: addon['price'],
                  productId: json['id'],
                  amount: addon['amount'],
                ))
            .toList(),
        amount: json['amount']);
  }

  Product.copy(Product other)
      : id = other.id,
        price = other.price,
        name = other.name,
        description = other.description,
        image = other.image,
        storeId = other.storeId,
        categoryId = other.categoryId,
        addons = Addon.duplicateAddonList(other.addons ?? []),
        amount = other.amount;

  String totalPrice() {
    double totalPrice = 0.00;

    if (addons != null) {
      for (var addon in addons!) {
        totalPrice +=
            ((addon.price ?? 0).toDouble() * (addon.amount ?? 1).toDouble());
      }
    }
    return ((totalPrice + price!) * (amount ?? 1)).toStringAsFixed(2);
  }

  String addonsTotalPrice() {
    double addonsTotalPrice = 0.00;

    if (addons != null) {
      for (var addon in addons!) {
        addonsTotalPrice +=
            ((addon.price ?? 0).toDouble() * (addon.amount ?? 1).toDouble());
      }
    }
    return addonsTotalPrice.toStringAsFixed(2);
  }
}
