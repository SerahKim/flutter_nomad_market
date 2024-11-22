import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownButtonWidget({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedValue,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
