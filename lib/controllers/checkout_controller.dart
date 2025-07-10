import 'package:get/get.dart';

import '../models/order.dart';
import '../models/product.dart';
import 'home_controller.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>(tag: 'cart');
  final HomeController homeController = Get.find<HomeController>(tag: 'home');

  var subTotalPrice = 0.0.obs;
  var deliveryCharge = 0.0.obs;
  var serviceCharge = 0.0.obs;
  var grandTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    calculateTotals();
    cartController.cart.listen((_) => calculateTotals());
    cartController.orderType.listen((_) => calculateTotals());
  }

  void calculateTotals() {
    double subTotal = 0.0;
    double delivery = 0.0;
    double service = 0.0;
    double grand = 0.0;
    if (cartController.recalculateTotals.value) {
      // Calculate subtotal
      for (var product in cartController.cart) {
        subTotal += num.parse(product.totalPrice());
      }

      // Group products by store and calculate store-specific delivery fees
      Map<String, List<Product>> groupedProducts =
          cartController.groupCartItemsByStore();
      groupedProducts.forEach((storeId, storeProducts) {
        num storeDeliveryFee = homeController.storeList
                .firstWhereOrNull((store) => store.id == storeId)
                ?.deliveryFee ??
            10.00;
        int totalQuantity = storeProducts.fold(
            0, (sum, product) => sum + (product.amount ?? 1));
        int productBatches = (totalQuantity / 3).ceil();
        delivery += productBatches * storeDeliveryFee;
      });

      // Determine grand total based on order type
      if (cartController.orderType.value == OrderType.delivery) {
        grand = subTotal + delivery;
      } else {
        grand = subTotal;
        delivery = 0.0;
      }

      // Calculate service charge
      service = (grand * 0.05);
      // Logger().d(service);
      // Logger().i(grand);

      // Update totals
      subTotalPrice.value = subTotal;
      deliveryCharge.value = delivery;
      serviceCharge.value = service;
      grandTotal.value = grand + service;
    }
  }
}
