import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadioTile extends StatelessWidget {
  final VoidCallback? onPressed;
  final String groupValue;
  final String value;
  final ValueChanged<String?>? onTap;
  CustomRadioTile({
    required this.onPressed,
    required this.value,
    required this.groupValue,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onTap ?? (value) {},
        ),
        title: Text(value),
      ),
    );
  }
}
