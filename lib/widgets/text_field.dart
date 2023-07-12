import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final double? inputWidth;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final IconData icon;
  final VoidCallback? onPressedIcon;
  final bool showIcon;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Color? iconColor;
  CustomTextField({
    required this.label,
    required this.icon,
    required this.textEditingController,
    required this.focusNode,
    this.obscureText = false,
    this.inputWidth,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.onPressedIcon,
    this.showIcon = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: inputWidth != null
                ? inputWidth! / 1.15
                : MediaQuery.of(context).size.width / 1.5,
            child: TextField(
              controller: textEditingController,
              focusNode: focusNode,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration.collapsed(
                hintText: label,
                hintStyle: greyNormal,
              ),
              cursorColor: primaryBlackColor,
            ),
          ),
          showIcon
              ? InkWell(
                  onTap: onPressedIcon ?? () {},
                  child: Icon(
                    icon,
                    color: iconColor ?? Colors.red,
                    size: 20,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
