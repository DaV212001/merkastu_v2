import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:merkastu_v2/constants/pages.dart';
import 'package:merkastu_v2/controllers/theme_mode_controller.dart';
import 'package:merkastu_v2/models/wallet_transaction.dart';

import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/wallet_controller.dart';
import '../../../utils/api_call_status.dart';
import '../../../utils/error_data.dart';
import '../../../widgets/animated_widgets/loading.dart';
import '../../../widgets/cards/error_card.dart';

class WalletHistoryScreen extends StatelessWidget {
  WalletHistoryScreen({super.key});
  final WalletController controller =
      Get.put(WalletController(), tag: 'wallet');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet history'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: kCardShadow()),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Wallet balance'),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              EneftyIcons.wallet_2_bold,
                              color: maincolor,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Obx(() => SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: AutoSizeText(
                                    UserController.walletBallance
                                        .toStringAsFixed(2),
                                    maxLines: 1,
                                    minFontSize: 9,
                                    maxFontSize: 40,
                                    stepGranularity: 1,
                                    style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Mont'),
                                  ),
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.fillWalletRoute),
                              child: Icon(
                                EneftyIcons.add_circle_bold,
                                color: maincolor,
                                size: 40,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              TabBar(controller: controller.tabController, tabs: const [
                Tab(
                    child: Text(
                  'Deposits',
                )),
                Tab(
                    child: Text(
                  'Withdrawals',
                )),
              ]),
              Obx(() => controller.gettingWalletHistory.value ==
                      ApiCallStatus.loading
                  ? const Loading()
                  : controller.gettingWalletHistory.value == ApiCallStatus.error
                      ? ErrorCard(
                          errorData: controller.errorGettingWalletHistory.value,
                          refresh: () => controller.fetchWalletHistory(),
                        )
                      : controller.walletHistory.isEmpty
                          ? ErrorCard(
                              errorData: ErrorData(
                                  title: '',
                                  body: 'No transactions found',
                                  image: Assets.empty,
                                  buttonText: 'Retry'),
                              refresh: () => controller.fetchWalletHistory(),
                            )
                          : Flexible(
                              fit: FlexFit.loose,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: TabBarView(
                                    controller: controller.tabController,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView.builder(
                                            itemCount: controller
                                                    .depositHistory.isEmpty
                                                ? 1
                                                : controller
                                                    .depositHistory.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              if (controller
                                                  .depositHistory.isEmpty) {
                                                return ErrorCard(
                                                    errorData: ErrorData(
                                                        title: 'No Deposits',
                                                        body:
                                                            'You haven\'t made any deposits yet, let\'s fill up that wallet',
                                                        image: Assets.empty));
                                              }
                                              var transactionId = controller
                                                  .depositHistory[index].id
                                                  .toString();
                                              var transactionDate = controller
                                                  .depositHistory[index]
                                                  .createdAt!;
                                              var isWithdrawal = controller
                                                      .depositHistory[index]
                                                      .transactionType !=
                                                  TransactionType.deposit;
                                              var transactionAmount = controller
                                                  .depositHistory[index].amount
                                                  .toString();
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: WalletTransactionCard(
                                                  transactionId: transactionId,
                                                  transactionDate:
                                                      transactionDate,
                                                  isWithdrawal: isWithdrawal,
                                                  transactionAmount:
                                                      transactionAmount,
                                                ),
                                              );
                                            }),
                                      ),
                                      ListView.builder(
                                          itemCount: controller
                                                  .withdrawalHistory.isEmpty
                                              ? 1
                                              : controller
                                                  .withdrawalHistory.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            if (controller
                                                .withdrawalHistory.isEmpty) {
                                              return ErrorCard(
                                                  errorData: ErrorData(
                                                      title: 'No withdrawals',
                                                      body:
                                                          'You haven\'t withdrawn from your wallet yet',
                                                      image: Assets.empty));
                                            }
                                            var transactionId = controller
                                                .withdrawalHistory[index].id
                                                .toString();
                                            var transactionDate = controller
                                                .withdrawalHistory[index]
                                                .createdAt!;
                                            var isWithdrawal = controller
                                                    .withdrawalHistory[index]
                                                    .transactionType !=
                                                TransactionType.deposit;
                                            var transactionAmount = controller
                                                .withdrawalHistory[index].amount
                                                .toString();
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: WalletTransactionCard(
                                                transactionId: transactionId,
                                                transactionDate:
                                                    transactionDate,
                                                isWithdrawal: isWithdrawal,
                                                transactionAmount:
                                                    transactionAmount,
                                              ),
                                            );
                                          }),
                                    ]),
                              ),
                            ))
            ],
          ),
        ),
      ),
    );
  }
}

class WalletTransactionCard extends StatelessWidget {
  const WalletTransactionCard({
    super.key,
    required this.transactionId,
    required this.transactionDate,
    required this.isWithdrawal,
    required this.transactionAmount,
  });

  final String transactionId;
  final DateTime transactionDate;
  final bool isWithdrawal;
  final String transactionAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: kCardShadow()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'ID: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: AutoSizeText(
                          transactionId,
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 16,
                          stepGranularity: 0.5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                            text: transactionId,
                          )).then((_) {
                            Get.snackbar('Copied', 'Copied to clipboard',
                                snackPosition: SnackPosition.BOTTOM);
                          });
                        },
                        child: Icon(
                          EneftyIcons.copy_outline,
                          color: maincolor,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy, hh:mm a').format(transactionDate),
                  ),
                ],
              ),
            ),
            // const Expanded(
            //   child: SizedBox(
            //     width: double.infinity,
            //   ),
            // ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        isWithdrawal ? '-' : '+',
                        style: TextStyle(
                            color: isWithdrawal ? Colors.red : maincolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        EneftyIcons.wallet_2_bold,
                        size: 16,
                        color: isWithdrawal ? Colors.red : maincolor,
                      ),
                      Text(
                        transactionAmount,
                        style: TextStyle(
                            color: ThemeModeController.isLightTheme.value
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
