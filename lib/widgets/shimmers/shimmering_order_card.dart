import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';

class ShimmeringOrderCard extends StatelessWidget {
  const ShimmeringOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
              // Simulating the ImageGrid shimmer
              Shimmer.fromColors(
                baseColor: maincolor.withOpacity(0.4),
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Shimmer for order status
                  Shimmer.fromColors(
                    baseColor: maincolor.withOpacity(0.4),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  // Shimmer for total price
                  Shimmer.fromColors(
                    baseColor: maincolor.withOpacity(0.4),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Shimmer for payment method (if applicable)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: maincolor.withOpacity(0.4),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 150,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Shimmer for order time
              Shimmer.fromColors(
                baseColor: maincolor.withOpacity(0.4),
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 80,
                  height: 15,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
