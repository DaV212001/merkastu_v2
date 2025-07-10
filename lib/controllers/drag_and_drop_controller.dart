import 'package:get/get.dart';
import 'package:merkastu_v2/models/product.dart';

import 'home_controller.dart';

class DragDropController extends GetxController {
  Rx<Product?> draggedProduct = Rx<Product?>(null); // The product being dragged

  // Start dragging a product
  void startDragging(Product product) {
    draggedProduct.value = product;
  }

  // Stop dragging (when drag is canceled or finished)
  void stopDragging() {
    draggedProduct.value = null;
  }

  // Add product to the cart
  void addToCart(Product product) {
    final CartController cartController = Get.find<CartController>(tag: 'cart');
    cartController.addProductToCart(product);
    stopDragging(); // Clear the dragged product
  }
}
