import 'package:flutter/material.dart';

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
    Color shadowColor = const Color(0x348E8E8E);

    const cornerRadius = 15.0;
    if (isFirstTile == true && isLastTile == true) {
      borderRadius = const BorderRadius.all(Radius.circular(cornerRadius));
      bottomDivider = false;
      boxShadowOffset = Offset.zero;
      shadowColor = const Color(0x34202020);
      blurRadius = cornerRadius;
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
                )
              ],
            ),
            child: Material(
              // color: maincolor,
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
                            child: Icon(icon),
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
