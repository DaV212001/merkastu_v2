import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:merkastu_v2/models/order.dart';

import '../constants/constants.dart';
import 'animated_widgets/loading.dart';
import 'cached_image_widget_wrapper.dart';

class ImageGrid extends StatelessWidget {
  final List<StoreSmall> stores;

  ImageGrid({required this.stores});

  @override
  Widget build(BuildContext context) {
    return _buildGrid();
  }

  Widget _buildGrid() {
    int storeCount = stores.length;
    StoreSmall? storeWithMostProducts;
    int? maxProductCount = 0;

    for (var store in stores) {
      if (store.productCount! > maxProductCount!) {
        maxProductCount = store.productCount;
        storeWithMostProducts = store;
      }
    }
    List<StoreSmall> sortedStores = List.from(stores);
    sortedStores.remove(storeWithMostProducts);
    sortedStores.insert(0, storeWithMostProducts!);
    if (storeCount == 1) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageTile(stores[0])),
              ],
            ),
          ),
        ],
      );
    } else if (storeCount == 2) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageTile(stores[0])),
                Expanded(child: _buildImageTile(stores[1])),
              ],
            ),
          ),
        ],
      );
    } else if (storeCount == 3) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageTile(stores[0])),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(flex: 2, child: _buildImageTile(stores[1])),
                      Expanded(flex: 2, child: _buildImageTile(stores[2])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageTile(stores[0])),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(flex: 2, child: _buildImageTile(stores[1])),
                      Expanded(flex: 2, child: _buildImageTile(stores[2])),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: maincolor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '+${storeCount - 3} more ${{
                                (storeCount - 3) > 1 ? 'stores' : 'store'
                              }}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Add a card with a plus icon for adding more images
        ],
      );
    }
  }

  List<Widget> _buildImageTiles() {
    return stores.map((imageUrl) => _buildImageTile(imageUrl)).toList();
  }

  Widget _buildImageTile(StoreSmall store) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          cachedNetworkImageWrapper(
            imageUrl: store.coverImage!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  store.coverImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            placeholderBuilder: (context, path) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey.withOpacity(0.2)),
                child: const Loading()),
            errorWidgetBuilder: (context, path, obj) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.asset(
                  'assets/images/logo.png', // Fallback image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.9), // semi-transparent black
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 8.0,
              right: 8.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    store.storeName!,
                    maxLines: 1,
                    minFontSize: 6,
                    maxFontSize: 15,
                    stepGranularity: 1,
                    style: const TextStyle(
                      color: Colors.white, // For contrast
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  AutoSizeText(
                    '${store.productCount} ${store.productCount == 1 ? 'product' : 'products'}',
                    maxLines: 1,
                    minFontSize: 5,
                    maxFontSize: 9,
                    stepGranularity: 0.5,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
