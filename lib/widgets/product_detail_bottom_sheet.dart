import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/constants/constants.dart';
import 'package:merkastu_v2/widgets/cached_image_widget_wrapper.dart';
import 'package:merkastu_v2/widgets/store_card.dart';

import '../controllers/home_controller.dart';
import '../models/product.dart';
import 'loading.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final HomeController homeController = Get.find<HomeController>(tag: 'home');

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        var addonsPrice = (widget.product.addons!
                    .where((addon) => (addon.amount ?? 0) > 0)
                    .map((addon) => addon.price! * addon.amount!)
                    .toList() // Convert to List
                    .isEmpty // Check if list is empty
                ? 0 // If empty, return 0
                : widget.product.addons!
                    .where((addon) => (addon.amount ?? 0) > 0)
                    .map((addon) => addon.price! * addon.amount!)
                    .reduce((value, element) => value + element)) ??
            0;

        var totalPriceForSpecificProduct =
            widget.product.price! * (widget.product.amount ?? 1) + addonsPrice;

        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Existing UI for Product Image, Name, Description
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cachedNetworkImageWrapper(
                              imageUrl: widget.product.image!,
                              imageBuilder: (context, imageProvider) =>
                                  SmallCardImageHolder(
                                image: Image.network(
                                  widget.product.image!,
                                  width:
                                      MediaQuery.of(context).size.height * 0.12,
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              placeholderBuilder: (context, path) => Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.12,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                child: const Loading(),
                              ),
                              errorWidgetBuilder: (context, path, obj) =>
                                  SmallCardImageHolder(
                                image: Image.asset(
                                  'assets/images/logo.png',
                                  width:
                                      MediaQuery.of(context).size.height * 0.12,
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.name!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: AutoSizeText(
                                      homeController.selectedStore.value.name!,
                                      maxLines: 1,
                                      minFontSize: 9,
                                      maxFontSize: 12,
                                      stepGranularity: 0.5,
                                      overflow: TextOverflow.visible,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: maincolor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'ETB ${widget.product.price}',
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: maincolor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    false
                                        ? EneftyIcons.heart_bold
                                        : EneftyIcons.heart_outline,
                                    color: Colors.grey,
                                  ),
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.height * 0.7,
                          child: Text(
                            widget.product.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black45),
                          ),
                        ),
                      ),
                      // Addon Section
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Addons',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text('Price: ETB $addonsPrice',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.product.addons?.length ?? 0,
                        itemBuilder: (context, index) {
                          final addon = widget.product.addons![index];

                          // Ensure addon has amount initialized if null
                          addon.amount ??= 0;

                          return Column(
                            children: [
                              CheckboxListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(addon.name!),
                                    Row(
                                      children: [
                                        Text('ETB ${addon.price}'),
                                        if (addon.amount! > 0)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    if (addon.amount! > 0) {
                                                      addon.amount =
                                                          addon.amount! - 1;
                                                    }
                                                  });
                                                  homeController.cart.refresh();
                                                },
                                              ),
                                              Text('${addon.amount}'),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  setState(() {
                                                    addon.amount =
                                                        addon.amount! + 1;
                                                  });
                                                  homeController.cart.refresh();
                                                },
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                value: addon.amount! > 0,
                                onChanged: (isSelected) {
                                  setState(() {
                                    addon.amount = isSelected! ? 1 : 0;
                                  });
                                  homeController.cart.refresh();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Existing bottom section with Add to Cart Button

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total amount: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'ETB $totalPriceForSpecificProduct',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: maincolor,
                                        fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => !homeController.cart.contains(widget.product)
                            ? Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if ((widget.product.amount ?? 1) > 1) {
                                          widget.product.amount =
                                              widget.product.amount! - 1;
                                        }
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: maincolor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: secondarycolor,
                                          ),
                                        )),
                                  ),
                                ),
                                Text('${widget.product.amount ?? 1}'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.product.amount =
                                            (widget.product.amount ?? 1) + 1;
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: maincolor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.add,
                                            color: secondarycolor,
                                          ),
                                        )),
                                  ),
                                ),
                              ])
                            : const SizedBox.shrink()),
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: Obx(() => ElevatedButton(
                                  onPressed: widget.product.amount == 0 ||
                                          widget.product.amount == null
                                      ? null
                                      : () => homeController.cart
                                              .contains(widget.product)
                                          ? homeController
                                              .removeProductFromCart(
                                              widget.product,
                                            )
                                          : homeController
                                              .addProductToCart(widget.product),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: maincolor,
                                      disabledBackgroundColor: Colors.grey),
                                  child: Text(
                                      homeController.cart
                                              .contains(widget.product)
                                          ? 'Remove from cart'
                                          : 'Add to cart',
                                      style: TextStyle(color: secondarycolor)),
                                )),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
