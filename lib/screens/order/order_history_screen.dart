import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:merkastu_v2/constants/assets.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/main_layout_controller.dart';
import 'package:merkastu_v2/controllers/order_controller.dart';
import 'package:merkastu_v2/utils/api_call_status.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/widgets/shimmers/shimmering_order_card.dart';

import '../../utils/animations.dart';
import '../../widgets/cards/error_card.dart';
import '../../widgets/cards/order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  final OrderController orderController =
      Get.put(OrderController(), tag: 'order');
  final MainLayoutController mainLayoutController =
      Get.find<MainLayoutController>(tag: 'main');

  OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: TabBar(
            controller: orderController.orderListTabController,
            tabs: const [
              Tab(
                  icon: Icon(
                    EneftyIcons.note_2_bold,
                    size: 16,
                  ),
                  text: 'Active Orders'),
              Tab(
                  icon: Icon(
                    Ionicons.refresh_circle,
                    size: 16,
                  ),
                  text: 'Order History'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: orderController.orderListTabController,
        children: [
          ActiveOrdersTab(orderController: orderController),
          OrderHistoryTab(orderController: orderController),
        ],
      ),
    );
  }
}

class OrderHistoryTab extends StatelessWidget {
  OrderHistoryTab({
    super.key,
    required this.orderController,
  });

  final OrderController orderController;
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 70),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => orderController.fetchingHistoryOrders.value == ApiCallStatus.loading
          ? ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ShimmeringOrderCard(),
                );
              })
          : orderController.fetchingHistoryOrders.value == ApiCallStatus.error
              ? Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: ErrorCard(
                      errorData:
                          orderController.errorFetchingHistoryOrders.value,
                      refresh: orderController.fetchHistoryOrders,
                    ),
                  ),
                )
              : orderController.groupedHistoryOrders.isEmpty
                  ? Center(
                      child: ErrorCard(
                        errorData: ErrorData(
                          title: 'No Order History',
                          body: '',
                          image: Assets.empty,
                          buttonText: 'Refresh',
                        ),
                        refresh: orderController.fetchHistoryOrders,
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          orderController.groupedHistoryOrders.keys.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var keys = orderController.groupedHistoryOrders.keys;
                        var currentKey = keys.toList()[index];
                        var currentListOfOrders =
                            orderController.groupedHistoryOrders[currentKey];
                        return Column(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     DateFormat('yMMMd')
                                //         .format(currentKey),
                                //     style: const TextStyle(
                                //         color: Colors.black54,
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 16),
                                //   ),
                                // ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: currentListOfOrders?.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return OrderCard(
                                            stores: currentListOfOrders![index]
                                                .stores!,
                                            orderStatus:
                                                currentListOfOrders[index]
                                                    .orderStatus!,
                                            totalPrice:
                                                currentListOfOrders[index]
                                                    .totalPrice!
                                                    .toStringAsFixed(2),
                                            paymentMethod:
                                                currentListOfOrders[index]
                                                    .payment!,
                                            orderedOn:
                                                currentListOfOrders[index]
                                                    .createdAt!,
                                          ).animateOnPageLoad(animationsMap[
                                              'containerOnPageLoadAnimation']!);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
    );
  }
}

class ActiveOrdersTab extends StatelessWidget {
  ActiveOrdersTab({
    super.key,
    required this.orderController,
  });

  final OrderController orderController;
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 70),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => orderController.fetchActiveOrders(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => orderController.fetchingActiveOrders.value ==
                      ApiCallStatus.loading
                  ? Flexible(
                      fit: FlexFit.loose,
                      child: ListView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ShimmeringOrderCard(),
                            );
                          }),
                    )
                  : orderController.fetchingActiveOrders.value ==
                          ApiCallStatus.error
                      ? Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: ErrorCard(
                              errorData: orderController
                                  .errorFetchingActiveOrders.value,
                              refresh: orderController.fetchActiveOrders,
                            ),
                          ),
                        )
                      : orderController.groupedActiveOrders.keys.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Center(
                                child: ErrorCard(
                                  errorData: ErrorData(
                                    title: 'No Active Orders',
                                    body: '',
                                    image: Assets.emptyCart,
                                    buttonText: 'Refresh',
                                  ),
                                  refresh: orderController.fetchActiveOrders,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: orderController
                                  .groupedActiveOrders.keys.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var keys =
                                    orderController.groupedActiveOrders.keys;
                                var currentKey = keys.toList()[index];
                                var currentListOfOrders = orderController
                                    .groupedActiveOrders[currentKey];
                                return Column(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: Text(
                                        //     DateFormat('yMMMd')
                                        //         .format(currentKey),
                                        //     style: const TextStyle(
                                        //         color: Colors.black54,
                                        //         fontWeight: FontWeight.bold,
                                        //         fontSize: 16),
                                        //   ),
                                        // ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    currentListOfOrders?.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      orderController
                                                              .selectedOrder
                                                              .value =
                                                          currentListOfOrders[
                                                              index];
                                                      orderController
                                                          .fetchOrderDetail();
                                                      Get.toNamed(Routes
                                                          .orderDetailRoute);
                                                    },
                                                    child: OrderCard(
                                                      stores:
                                                          currentListOfOrders![
                                                                  index]
                                                              .stores!,
                                                      orderStatus:
                                                          currentListOfOrders[
                                                                  index]
                                                              .orderStatus!,
                                                      totalPrice:
                                                          currentListOfOrders[
                                                                  index]
                                                              .totalPrice!
                                                              .toStringAsFixed(
                                                                  2),
                                                      paymentMethod:
                                                          currentListOfOrders[
                                                                  index]
                                                              .payment!,
                                                      orderedOn:
                                                          currentListOfOrders[
                                                                  index]
                                                              .createdAt!,
                                                    ),
                                                  ).animateOnPageLoad(animationsMap[
                                                      'containerOnPageLoadAnimation']!);
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
            ),
            SizedBox(
              height: 70.h,
            )
          ],
        ),
      ),
    );
  }
}
