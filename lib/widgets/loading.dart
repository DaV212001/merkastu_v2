import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/constants.dart';

class Loading extends StatelessWidget {
  final double? size;
  final Color? color;
  const Loading({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
          color: color ?? maincolor,
          size: size ?? MediaQuery.of(context).size.width * 0.2),
    );
  }
}
