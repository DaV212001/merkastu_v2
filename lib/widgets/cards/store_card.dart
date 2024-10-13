import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/widgets/animated_widgets/loading.dart';

import '../cached_image_widget_wrapper.dart';

class StoreCard extends StatelessWidget {
  final String name;
  final String location;
  final String image;
  final String deliveryTime;
  final bool favorited;
  final Function()? onHeartTap;

  const StoreCard(
      {super.key,
      required this.name,
      required this.location,
      required this.image,
      required this.deliveryTime,
      required this.favorited,
      this.onHeartTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: kCardShadow()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: cachedNetworkImageWrapper(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => LargeCardImageHolder(
                image: Image.network(
                  image,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  fit: BoxFit.cover,
                ),
              ),
              placeholderBuilder: (context, path) => const Loading(),
              errorWidgetBuilder: (context, path, object) =>
                  LargeCardImageHolder(
                image: Image.asset(
                  'assets/images/logo.png',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: onHeartTap,
                      child: Icon(
                        favorited
                            ? EneftyIcons.heart_bold
                            : EneftyIcons.heart_outline,
                        color: maincolor,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: maincolor,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: AutoSizeText(
                        location.trim(),
                        maxLines: 2,
                        minFontSize: 5,
                        maxFontSize: 10,
                        stepGranularity: 0.5,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.watch_later,
                      color: maincolor,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '$deliveryTime min',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LargeCardImageHolder extends StatelessWidget {
  const LargeCardImageHolder({
    super.key,
    required this.image,
  });

  final Image image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      child: image,
    );
  }
}

class SmallCardImageHolder extends StatelessWidget {
  const SmallCardImageHolder({
    super.key,
    required this.image,
  });

  final Image image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      child: image,
    );
  }
}

class CircularImageHolder extends StatelessWidget {
  const CircularImageHolder({
    super.key,
    required this.image,
  });

  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child:
            ClipRRect(borderRadius: BorderRadius.circular(100), child: image));
  }
}
