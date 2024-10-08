class Addon {
  final String? id;
  final String? name;
  final num? price;
  final String? productId;
  int? amount;

  Addon({this.id, this.name, this.price, this.productId, this.amount});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'product_id': productId,
      'amount': amount
    };
  }

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      productId: json['product_id'],
    );
  }

  Addon.copy(Addon other)
      : id = other.id,
        name = other.name,
        price = other.price,
        productId = other.productId,
        amount = other.amount;

  static List<Addon> duplicateAddonList(List<Addon> addons) {
    List<Addon> newAddons = [];
    for (var addon in addons) {
      Addon newAddon = Addon.copy(addon);
      newAddons.add(newAddon);
    }
    return newAddons;
  }
}
