import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:merkastu_v2/widgets/cards/store_card.dart';

import '../../constants/constants.dart';
import '../animated_widgets/loading.dart';
import '../cached_image_widget_wrapper.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final String price;
  final bool favorited;
  final Function()? onHeartTap;
  final VoidCallback onImageTap;
  final bool? isSelected;
  final bool? forGhost;
  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.favorited,
    this.onHeartTap,
    required this.onImageTap,
    this.isSelected,
    this.forGhost,
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
                boxShadow: kCardShadow(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: onImageTap,
                      child: Stack(alignment: Alignment.center, children: [
                        cachedNetworkImageWrapper(
                          imageUrl: image,
                          imageBuilder: (context, imageProvider) =>
                              SmallCardImageHolder(
                            image: Image.network(
                              image,
                              width: MediaQuery.of(context).size.height * 0.12,
                              height: MediaQuery.of(context).size.height * 0.12,
                              fit: BoxFit.cover,
                            ),
                          ),
                          placeholderBuilder: (context, path) => Container(
                              width: MediaQuery.of(context).size.height * 0.12,
                              height: MediaQuery.of(context).size.height * 0.12,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey.withOpacity(0.2)),
                              child: const Loading()),
                          errorWidgetBuilder: (context, path, obj) =>
                              SmallCardImageHolder(
                            image: Image.asset(
                              'assets/images/logo.png',
                              width: MediaQuery.of(context).size.height * 0.12,
                              height: MediaQuery.of(context).size.height * 0.12,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isSelected == true)
                          Container(
                            width: MediaQuery.of(context).size.height * 0.12,
                            height: MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                // border: Border.all(color: Colors.white, width: 2),
                                color: Colors.white.withOpacity(0.65)),
                            child: Icon(
                              EneftyIcons.tick_circle_bold,
                              color: maincolor,
                              size: 50,
                            ),
                          )
                      ]),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (forGhost != true)
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Text(
                                  description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Colors.grey, fontSize: 10),
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
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: onHeartTap,
                  child: Icon(
                    favorited
                        ? EneftyIcons.heart_bold
                        : EneftyIcons.heart_outline,
                    color: maincolor,
                  ),
                )),
          ],
        ));
  }
}
