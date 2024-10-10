import 'package:flutter/material.dart';

import '../../widgets/order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          children: [OrderCard()],
        ),
      ),
    );
  }
}
