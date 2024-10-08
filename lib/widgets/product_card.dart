import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:merkastu_v2/widgets/store_card.dart';

import '../constants/constants.dart';
import 'cached_image_widget_wrapper.dart';
import 'loading.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final String price;
  final bool favorited;
  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.favorited,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                    cachedNetworkImageWrapper(
                      imageUrl: image,
                      imageBuilder: (context, imageProvider) =>
                          SmallCardImageHolder(
                        image: Image.network(
                          image,
                          width: MediaQuery.of(context).size.height * 0.15,
                          height: MediaQuery.of(context).size.height * 0.15,
                          fit: BoxFit.cover,
                        ),
                      ),
                      placeholderBuilder: (context, path) => Container(
                          width: MediaQuery.of(context).size.height * 0.15,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.withOpacity(0.2)),
                          child: const Loading()),
                      errorWidgetBuilder: (context, path, obj) =>
                          SmallCardImageHolder(
                        image: Image.asset(
                          'assets/images/logo.png',
                          width: MediaQuery.of(context).size.height * 0.15,
                          height: MediaQuery.of(context).size.height * 0.15,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.height * 0.25,
                            child: Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'ETB $price',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
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
                child: Icon(
                  favorited
                      ? EneftyIcons.heart_bold
                      : EneftyIcons.heart_outline,
                  color: maincolor,
                )),
          ],
        ));
  }
}
