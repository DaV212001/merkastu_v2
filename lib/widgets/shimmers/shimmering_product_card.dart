import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';

class ShimmeringProductCard extends StatelessWidget {
  const ShimmeringProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: maincolor.withOpacity(0.4),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: MediaQuery.of(context).size.height * 0.15,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          height: 5,
                        ),
                        Shimmer.fromColors(
                          baseColor: maincolor.withOpacity(0.4),
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            height: 15,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
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
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Shimmer.fromColors(
              baseColor: maincolor.withOpacity(0.4),
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
