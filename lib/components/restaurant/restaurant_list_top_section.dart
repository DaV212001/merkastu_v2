import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../controllers/home_controller.dart';

List<String> restaurantCategories = ['All', 'Inside AASTU', 'Outside AASTU'];

class RestaurantListTopSection extends StatelessWidget {
  const RestaurantListTopSection({
    super.key,
    required this.homeController,
  });

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for your favorite restaurants',
                hintStyle: const TextStyle(fontSize: 10),
                prefixIcon: Icon(
                  EneftyIcons.search_normal_outline,
                  color: maincolor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: maincolor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: maincolor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: maincolor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: maincolor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) {
                homeController.searchForStores(value);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Restaurants',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Obx(() => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  homeController.selectedIndex.value = index;
                                  if (index == 0) {
                                    homeController.all.value = true;
                                    homeController.filterStores();
                                  } else if (index == 1) {
                                    homeController.all.value = false;
                                    homeController.insideAastu.value = true;
                                    homeController.filterStores();
                                  } else if (index == 2) {
                                    homeController.all.value = false;
                                    homeController.insideAastu.value = false;
                                    homeController.filterStores();
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(
                                      color:
                                          homeController.selectedIndex.value ==
                                                  index
                                              ? maincolor
                                              : Colors.grey,
                                      width:
                                          homeController.selectedIndex.value ==
                                                  index
                                              ? 2
                                              : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 70,
                                      child: AutoSizeText(
                                        restaurantCategories[index],
                                        maxLines: 1,
                                        minFontSize: 5,
                                        maxFontSize: 9,
                                        stepGranularity: 0.5,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            fontWeight: homeController
                                                        .selectedIndex.value ==
                                                    index
                                                ? FontWeight.w600
                                                : null,
                                            color: homeController
                                                        .selectedIndex.value ==
                                                    index
                                                ? maincolor
                                                : null),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      }),
                ),
              ],
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
