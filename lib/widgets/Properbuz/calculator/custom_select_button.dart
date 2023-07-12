import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class CustomSelectButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? val;
  const CustomSelectButton({Key? key, this.onTap, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 50,
        width: 100.0.w - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              val!,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
            )
          ],
        ),
      ),
    );
  }
}
