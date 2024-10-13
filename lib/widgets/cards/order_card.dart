import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../models/order.dart';
import '../../utils/order_status.dart';
import '../../utils/payment_methods.dart';
import '../image_grid.dart';

class OrderCard extends StatelessWidget {
  final List<StoreSmall> stores;
  final OrderStatus orderStatus;
  final String totalPrice;
  final PaymentMethod paymentMethod;
  final DateTime orderedOn;
  OrderCard({
    super.key,
    required this.stores,
    required this.orderStatus,
    required this.totalPrice,
    required this.paymentMethod,
    required this.orderedOn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 16.0, top: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: kCardShadow(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.17,
                  child: ImageGrid(stores: stores)),
              // Additional UI components like Order status, Total price, etc.
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: maincolor,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                          child: Text(orderStatus.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12))),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total price:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      Text(' $totalPrice Birr',
                          style: TextStyle(
                              color: maincolor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ],
                  ),
                ],
              ),
              if (orderStatus != OrderStatus.inactive)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Paid with:',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                        Text(' ${paymentMethod.name}',
                            style: TextStyle(
                                color: maincolor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  DateFormat('hh:mm a')
                      .format(orderedOn.toUtc().add(const Duration(hours: 3)))
                      .toString(),
                  style: TextStyle(color: maincolor, fontSize: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
