import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final double? padding;
  final ValueChanged<String?>? onChanged;

  const CustomTextField(
      {Key? key,
      this.height,
      this.controller,
      this.hintText,
      this.prefix,
      this.suffix,
      this.width,
      this.padding,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 50 : height,
      width: (width == null ? 100.0.w : width)! -
          (padding == null ? 20 : padding!),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 1,
        ),
      ),
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        onChanged: this.onChanged,
        decoration: InputDecoration(
          suffixIcon: suffix,
          prefixIcon: prefix,
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final double? height;
  final double? width;
  final dynamic? value;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final double? padding;
  final ValueChanged? onChanged;

  final List<Map<String, dynamic>> dropDownItems;

  const CustomDropdownField(
      {Key? key,
      this.height,
      this.width,
      this.value,
      this.hintText,
      this.prefix,
      this.suffix,
      this.padding,
      required this.onChanged,
      required this.dropDownItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 50 : height,
      width: (width == null ? 100.0.w : width)! -
          (padding! == null ? 20 : padding!),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: hotPropertiesThemeColor,
          width: 1,
        ),
      ),
      child: DropdownButtonFormField(
        items: dropDownItems
            .map(
              (e) => DropdownMenuItem(
                child: Text(e["name"]),
                value: e["val"],
              ),
            )
            .toList(),
        value: value,
        style: TextStyle(color: Colors.black, fontSize: 16),
        onChanged: this.onChanged,
        decoration: InputDecoration(
          suffixIcon: suffix,
          prefixIcon: prefix,
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }
}
