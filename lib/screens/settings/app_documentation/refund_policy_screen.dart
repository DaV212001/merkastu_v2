import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merkastu_v2/utils/error_data.dart';
import 'package:merkastu_v2/widgets/animated_widgets/loading.dart';

import '../../../controllers/app_info_controller.dart';
import '../../../utils/api_call_status.dart';
import '../../../widgets/cards/error_card.dart';

class RefundPolicyScreen extends StatelessWidget {
  RefundPolicyScreen({super.key});

  final controller = Get.find<AppInfoController>(tag: 'appInfo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund Policy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Obx(
                () => controller.gettingRefundPolicy.value ==
                        ApiCallStatus.loading
                    ? const Loading()
                    : controller.gettingRefundPolicy.value ==
                            ApiCallStatus.error
                        ? Center(
                            child: ErrorCard(
                              errorData: controller.errorGettingRefundPolicy,
                              refresh: () => controller.fetchRefundPolicy(),
                            ),
                          )
                        : controller.appInfoRefundPolicy.value.isEmpty
                            ? Center(
                                child: ErrorCard(
                                  errorData: ErrorData(
                                      title: 'No info',
                                      body:
                                          'No information found, please try later',
                                      image: 'assets/images/empty.svg'),
                                  refresh: () => controller.fetchRefundPolicy(),
                                ),
                              )
                            : Text(controller.appInfoRefundPolicy.value),
              )
            ],
          ),
        ),
      ),
    );
  }
}
