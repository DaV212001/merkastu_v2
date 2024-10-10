import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../widgets/custom_input_field.dart';

class DeliveryAddressSelection extends StatelessWidget {
  const DeliveryAddressSelection({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 16.0, top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            label: 'Block',
            inputController: TextEditingController(
                text: homeController.block.value.toString()),
            hintText: 'Enter block number',
            onChanged: (value) {
              homeController.block.value = int.parse(value);
            },
            validator: (value) {
              if (!value!.isNumericOnly) {
                return 'Block number should only contain numbers';
              }
              if (value.length > 2) {
                return 'Block number should only be 2 digits';
              }
              if (int.parse(value) > 28 || int.parse(value) < 1) {
                return 'Block number should be between 1 and 28';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          CustomInputField(
            label: 'Room',
            inputController: TextEditingController(
                text: homeController.room.value.toString()),
            hintText: 'Enter room number',
            onChanged: (value) {
              homeController.room.value = int.parse(value);
            },
            validator: (value) {
              if (!value!.isNumericOnly) {
                return 'Room number should only contain numbers';
              }
              if (value.length > 3) {
                return 'Room number should only be 2 digits';
              }
              if (int.parse(value) > 1 || int.parse(value) < 499) {
                return 'Room number should be between 001 and 4xx';
              }
              return null;
            },
          )
        ],
      ),
    );
  }
}
