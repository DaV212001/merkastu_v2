import 'package:flutter/material.dart';
import 'package:merkastu_v2/constants/constants.dart';

class AnimatedSearchBar extends StatefulWidget {
  final void Function(String)? onChanged;
  const AnimatedSearchBar({required this.onChanged, super.key});
  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      onTapCancel: () {
        setState(() {
          isExpanded = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: isExpanded ? MediaQuery.of(context).size.width * 0.45 : 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: maincolor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isExpanded)
                Expanded(
                  child: TextField(
                    autofocus: true,
                    onTapOutside: (event) {
                      isExpanded = !isExpanded;
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: widget.onChanged,
                    onChanged: widget.onChanged,
                  ),
                ),
              if (!isExpanded)
                Icon(
                  Icons.search_outlined,
                  color: maincolor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
