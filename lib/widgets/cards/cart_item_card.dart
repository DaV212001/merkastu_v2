import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:merkastu_v2/widgets/cards/store_card.dart';

import '../../constants/constants.dart';
import '../animated_widgets/loading.dart';
import '../cached_image_widget_wrapper.dart';

class CartItemCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  final String price;
  final String amount;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDuplicate;
  const CartItemCard({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.onAdd,
    required this.onRemove,
    required this.amount,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
                                  ?.copyWith(color: Colors.grey, fontSize: 10),
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
                          const SizedBox(
                            height: 5,
                          ),
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: onRemove,
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: maincolor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: amount != '1'
                                          ? Icon(
                                              Icons.remove,
                                              color: secondarycolor,
                                            )
                                          : const Icon(
                                              EneftyIcons.trash_outline,
                                              color: Colors.white,
                                            ),
                                    )),
                              ),
                            ),
                            Text(amount),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: GestureDetector(
                                onTap: onAdd,
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: maincolor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            ),
                          ])
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      Positioned(
        bottom: 10,
        right: 10,
        child: GestureDetector(
          onTap: onDuplicate,
          child: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              EneftyIcons.add_circle_outline,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ]);
  }
}
