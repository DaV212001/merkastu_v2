import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../widgets/cached_image_widget_wrapper.dart';
import '../../widgets/loading.dart';

class RestaurantDetailScreenTopSection extends StatelessWidget {
  final String image;
  final String name;
  final String location;
  final bool favorited;
  const RestaurantDetailScreenTopSection({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.favorited,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: maincolor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: secondarycolor,
                    ),
                  )),
                ),
              ),
            ),
            cachedNetworkImageWrapper(
              imageUrl: image,
              imageBuilder: (context, imageProvider) => Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  // color: maincolor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholderBuilder: (context, path) => Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  // color: maincolor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Loading(),
                ),
              ),
              errorWidgetBuilder: (context, path, object) => Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  // color: maincolor,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Container(
            //   width: 50,
            //   height: 50,
            //   decoration: const BoxDecoration(
            //     // color: maincolor,
            //     shape: BoxShape.circle,
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(100),
            //     child: Image.network(
            //       'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: AutoSizeText(
                      location,
                      maxLines: 1,
                      minFontSize: 9,
                      maxFontSize: 12,
                      stepGranularity: 0.5,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: maincolor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                favorited ? EneftyIcons.heart_bold : EneftyIcons.heart_outline,
                color: Colors.grey,
              ),
            )),
          ),
        )
      ],
    );
  }
}
