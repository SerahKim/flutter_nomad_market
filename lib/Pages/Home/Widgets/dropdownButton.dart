import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String? selectedValue;
  final List items;
  final ValueChanged onChanged;

  const DropdownButtonWidget({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      value: selectedValue,
      items: items.map((item) {
        // item이 Map인 경우와 String인 경우를 구분하여 처리
        String displayText = item is Map ? item['name'] : item.toString();
        String value = item is Map ? item['name'] : item.toString();

        return DropdownMenuItem(
          value: value,
          child: Text(
            displayText,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
