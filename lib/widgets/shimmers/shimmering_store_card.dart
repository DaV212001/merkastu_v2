import 'package:flutter/material.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmeringStoreCard extends StatelessWidget {
  const ShimmeringStoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: kCardShadow()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Shimmer.fromColors(
                baseColor: maincolor.withOpacity(0.4),
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: maincolor.withOpacity(0.4),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: maincolor.withOpacity(0.4),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 150,
                          height: 15,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: maincolor.withOpacity(0.4),
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 60,
                          height: 15,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
