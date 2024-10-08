import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:merkastu_v2/constants/constants.dart';

import '../models/product.dart';

class ProductCheckOutCard extends StatelessWidget {
  const ProductCheckOutCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${product.name}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (product.addons != null && product.addons!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.addons!
                      .where(
                          (addon) => addon.amount != null && addon.amount! > 0)
                      .map(
                        (addon) => AutoSizeText(
                          "${addon.name} (x${addon.amount}) - ${addon.price! * (addon.amount ?? 1)} Birr",
                          maxLines: 1,
                          minFontSize: 9,
                          maxFontSize: 12,
                          stepGranularity: 0.5,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              color: maincolor, fontWeight: FontWeight.bold),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        AutoSizeText(
          'Amount: ${product.amount ?? 1}',
          maxLines: 1,
          minFontSize: 9,
          maxFontSize: 12,
          stepGranularity: 0.5,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        AutoSizeText(
          'Product price: ${product.price} Birr',
          maxLines: 1,
          minFontSize: 9,
          maxFontSize: 12,
          stepGranularity: 0.5,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (product.addons != null &&
            product.addons!.isNotEmpty &&
            product.addonsTotalPrice() != '0.00')
          AutoSizeText(
            "Add-ons price: ${product.addonsTotalPrice()} Birr",
            maxLines: 1,
            minFontSize: 9,
            maxFontSize: 12,
            stepGranularity: 0.5,
            overflow: TextOverflow.visible,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        AutoSizeText(
          "Subtotal product price: ${product.totalPrice()} Birr",
          maxLines: 1,
          minFontSize: 9,
          maxFontSize: 12,
          stepGranularity: 0.5,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Divider(
            // color: Colors.white,
            )
      ],
    );
  }
}
