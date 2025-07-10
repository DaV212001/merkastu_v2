import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/models/order.dart';

import '../controllers/home_controller.dart'; // adjust the import as needed

class OrderOptionSelector extends StatefulWidget {
  // final OrderType initialSelection;
  final ValueChanged<OrderType> onSelectionChanged;

  const OrderOptionSelector({
    Key? key,
    // this.initialSelection = OrderType.delivery,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _OrderOptionSelectorState createState() => _OrderOptionSelectorState();
}

class _OrderOptionSelectorState extends State<OrderOptionSelector> {
  OrderType _selectedOption = OrderType.delivery;
  final CartController cartController = Get.find<CartController>(tag: 'cart');

  @override
  void initState() {
    super.initState();
    // Initialize the CartController's orderOption with the initial value.
    // cartController.orderType.value = _selectedOption;
  }

  void _handleSelection(OrderType? value) {
    if (value != null) {
      setState(() {
        _selectedOption = value;
      });
      // Update the order option in the CartController.
      cartController.orderType.value = value;
      widget.onSelectionChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<OrderType>(
          title: const Text("Eat In"),
          value: OrderType.eatIn,
          groupValue: _selectedOption,
          onChanged: _handleSelection,
        ),
        RadioListTile<OrderType>(
          title: const Text("Takeaway"),
          value: OrderType.takeaway,
          groupValue: _selectedOption,
          onChanged: _handleSelection,
        ),
        RadioListTile<OrderType>(
          title: const Text("Delivery"),
          subtitle: const Text(
            "If you choose delivery, you will pay the price of the food here in full and the delivery charge to the delivery person when your order is delivered.",
            style: TextStyle(fontSize: 12),
          ),
          value: OrderType.delivery,
          groupValue: _selectedOption,
          onChanged: _handleSelection,
        ),
      ],
    );
  }
}
