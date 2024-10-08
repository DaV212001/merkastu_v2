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
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
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
                      width: 150,
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
                          width: 100,
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
