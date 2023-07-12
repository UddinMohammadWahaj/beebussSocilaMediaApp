import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  final List<String> list;
  final String hint;
  final ValueChanged<String?> onChange;
  final String value;
  CustomDropDownButton({
    required this.list,
    required this.onChange,
    required this.value,
    this.hint = '',
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: DropdownButton<String>(
        value: value,
        icon: Icon(Icons.arrow_drop_down),
        hint: Text(hint),
        iconSize: 24,
        elevation: 16,
        underline: Container(height: 0),
        onChanged: onChange,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
