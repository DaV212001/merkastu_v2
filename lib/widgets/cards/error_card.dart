import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/error_data.dart';

class ErrorCard extends StatelessWidget {
  final ErrorData errorData;
  final VoidCallback? refresh;

  const ErrorCard({super.key, this.refresh, required this.errorData});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          errorData.image,
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            errorData.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Text(
            errorData.body,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.unselectedWidgetColor,
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        buildButton(errorData.buttonText)
      ],
    );
  }

  Widget buildButton(String? text) {
    if (text == null || refresh == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: 300,
      height: 40,
      child: ElevatedButton(
        onPressed: refresh,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
