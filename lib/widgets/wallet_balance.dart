import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_mode_controller.dart';
import 'animated_widgets/loading.dart';

class WalletBalance extends StatelessWidget {
  const WalletBalance({
    super.key,
    this.fromSettings,
  });
  final bool? fromSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => Container(
          decoration: BoxDecoration(
            color:
                // fromSettings == true
                //     ?
                !ThemeModeController.isLightTheme.value
                    ? maincolor
                    : Colors.white,
            // : maincolor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  // fromSettings == true
                  //     ?
                  !ThemeModeController.isLightTheme.value
                      ? Colors.white
                      : maincolor,
              // : Colors.white
            ),
          ),
          child: Obx(
            () => UserController.loadingBalance.value
                ? SizedBox(
                    height: 50,
                    width: 50,
                    child: Loading(
                      color:
                          // fromSettings == true
                          //     ?
                          !ThemeModeController.isLightTheme.value
                              ? Colors.white
                              : maincolor
                      // : Colors.white
                      ,
                      size: 40,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          EneftyIcons.wallet_2_bold,
                          color:
                              // fromSettings == true
                              //     ?
                              !ThemeModeController.isLightTheme.value
                                  ? Colors.white
                                  : maincolor
                          // : Colors.white
                          ,
                        ),
                        VerticalDivider(
                          color:
                              // fromSettings == true
                              //     ?
                              !ThemeModeController.isLightTheme.value
                                  ? Colors.white
                                  : maincolor
                          // : Colors.white
                          ,
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.11,
                            child: AutoSizeText(
                              UserController.walletBalance.value
                                  .toStringAsFixed(2),
                              // '100',
                              maxLines: 1,
                              minFontSize: 4,
                              maxFontSize: 12,
                              textAlign: TextAlign.center,
                              stepGranularity: 0.5,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      // fromSettings == true
                                      //     ?
                                      !ThemeModeController.isLightTheme.value
                                          ? Colors.white
                                          : maincolor
                                  // : Colors.white
                                  ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ))),
    );
  }
}
