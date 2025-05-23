import '../models/order.dart';
import '../models/product.dart';
import '../models/store.dart';

class CalculationHelper {
  static String calculateSpecificProductPrice(Product product) {
    // Calculate the base price of the product
    double basePrice = (product.price ?? 0.0) * (product.amount ?? 1) / 1;

    // Calculate the total price of addons
    double addonsPrice = 0.0;

    // Check if product.addons is not null and has elements
    if (product.addons != null && product.addons!.isNotEmpty) {
      // Use map to calculate the total addon price, and use fold to avoid "No element" error
      addonsPrice = product.addons!
          .map((e) => (e.price ?? 0.0) * (e.amount ?? 1))
          .fold(0.0, (sum, element) => sum + element);
    }

    // Calculate total price
    double totalPrice = basePrice + addonsPrice;

    // Return total price as a string
    return totalPrice.toString();
  }

  static String calculateStoreDeliveryFee(
      String storeId, List<Product> cart, List<Store> storeList) {
    // Retrieve the list of products from the specific store
    List<Product> storeProducts =
        cart.where((product) => product.storeId == storeId).toList();

    if (storeProducts.isEmpty) {
      return '0.0'; // No products from this store, so no delivery fee
    }

    // Retrieve the store's delivery fee from the store list
    num storeDeliveryFee =
        storeList.firstWhere((store) => store.id == storeId).deliveryFee ??
            10.00; // Default delivery fee if not specified

    // Calculate total quantity of products in this store
    int totalQuantity =
        storeProducts.fold(0, (sum, product) => sum + (product.amount ?? 1));

    // Calculate the number of product batches (e.g., 3 products per batch)
    int productBatches = (totalQuantity / 3).ceil();

    // Calculate the total delivery fee for this store based on the number of batches
    num deliveryFee = productBatches * storeDeliveryFee;

    return deliveryFee.toString();
  }

  static int calculateTotalQuantityOfProductsFromSpecificStore(
      String storeId, List<Product> cart) {
    // Retrieve the list of products from the specific store
    List<Product> storeProducts =
        cart.where((product) => product.storeId == storeId).toList();

    // Calculate total quantity of products in this store
    int totalQuantity =
        storeProducts.fold(0, (sum, product) => sum + (product.amount ?? 1));

    return totalQuantity;
  }

  static double calculateTotalProductPrice(List<Product> cart) {
    double totalProductPrice = 0.0;
    for (var product in cart) {
      totalProductPrice +=
          ((product.price ?? 0.0).toDouble() * (product.amount ?? 1));
      for (var addon in product.addons ?? []) {
        totalProductPrice +=
            ((addon.price ?? 0.0).toDouble() * (addon.amount ?? 1));
      }
    }
    return totalProductPrice;
  }
}

class OrdersHelper {
  static Map<DateTime, List<Order>> groupOrdersByDate(List<Order> orders) {
    Map<DateTime, List<Order>> groupedOrders = {};

    for (var order in orders) {
      // Convert UTC time to Ethiopian time (UTC+3)
      final ethiopianDateTime =
          order.createdAt?.toUtc().add(const Duration(hours: 3));

      // Create a DateTime key with only the year, month, and day part (strip the time)
      DateTime dateKey = DateTime(
        ethiopianDateTime!.year,
        ethiopianDateTime.month,
        ethiopianDateTime.day,
      );

      // Add the order to the corresponding date group
      if (!groupedOrders.containsKey(dateKey)) {
        groupedOrders[dateKey] = [];
      }
      groupedOrders[dateKey]!.add(order);
    }

    // Sort the grouped orders by date in descending order (most recent first)
    final sortedGroupedOrders = Map<DateTime, List<Order>>.fromEntries(
      groupedOrders.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );

    // Sort the orders within each group by createdAt in descending order
    sortedGroupedOrders.forEach((date, ordersList) {
      ordersList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    });

    return sortedGroupedOrders;
  }

  static Map<String, List<Product>> groupOrderProductsByStoreId(
      List<Product> products) {
    Map<String, List<Product>> groupedOrderProducts = {};
    for (var product in products) {
      if (!groupedOrderProducts.containsKey(product.storeId)) {
        groupedOrderProducts[product.storeId!] = [];
      }
      groupedOrderProducts[product.storeId]!.add(product);
    }
    return groupedOrderProducts;
  }
}
