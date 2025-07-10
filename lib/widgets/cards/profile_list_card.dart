import 'package:flutter/material.dart';
import 'package:merkastu_v2/constants/constants.dart';

import '../../controllers/theme_mode_controller.dart';

class ProfileListCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool? isFirstTile;
  final bool? isLastTile;
  final void Function() onTap;

  const ProfileListCard({
    super.key,
    required this.name,
    required this.icon,
    this.isFirstTile,
    this.isLastTile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius;
    final bool bottomDivider;
    final Offset boxShadowOffset;
    final double blurRadius;
    Color shadowColor = ThemeModeController.isLightTheme.value
        ? Colors.grey.withOpacity(0.3)
        : Colors.transparent;

    const cornerRadius = 7.0;
    if (isFirstTile == true && isLastTile == true) {
      borderRadius = const BorderRadius.all(Radius.circular(cornerRadius));
      bottomDivider = false;
      boxShadowOffset = Offset.zero;
      shadowColor = const Color(0x34202020);
      blurRadius = 10;
    } else if (isFirstTile == true) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(cornerRadius),
        topLeft: Radius.circular(cornerRadius),
      );
      bottomDivider = true;
      boxShadowOffset = const Offset(0, -5);
      blurRadius = 5;
    } else if (isLastTile == true) {
      borderRadius = const BorderRadius.only(
        bottomRight: Radius.circular(cornerRadius),
        bottomLeft: Radius.circular(cornerRadius),
      );
      bottomDivider = false;
      boxShadowOffset = const Offset(0, 5);
      blurRadius = 5;
    } else {
      borderRadius = const BorderRadius.only();
      bottomDivider = true;
      boxShadowOffset = Offset.zero;
      blurRadius = 0;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 60,
            margin: EdgeInsets.only(top: isFirstTile == true ? 16.0 : 0.0),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                    blurRadius: blurRadius,
                    color: shadowColor,
                    offset: boxShadowOffset,
                    spreadRadius: 0)
              ],
            ),
            child: Material(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              child: InkWell(
                borderRadius: borderRadius,
                onTap: onTap,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Icon(
                              icon,
                              color: maincolor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(name),
                          ),
                        ],
                      ),
                    ),
                    if (bottomDivider == true)
                      const Padding(
                        padding: EdgeInsets.only(left: 65, right: 25),
                        child: Divider(
                          thickness: 0.5,
                          height: 1,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
