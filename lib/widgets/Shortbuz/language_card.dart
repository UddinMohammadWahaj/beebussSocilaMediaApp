import 'package:bizbultest/models/shortbuz/shortbuzz_language_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShortbuzLanguageCard extends StatelessWidget {
  final ShortbuzzLanguageModelLanguage? language;
  final String? selectedLanguage;
  final VoidCallback? onTap;

  const ShortbuzLanguageCard(
      {Key? key, this.language, this.selectedLanguage, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: onTap ?? () {},
        leading: selectedLanguage == language!.languageName!
            ? Icon(
                Icons.check,
                size: 3.0.h,
                color: Colors.black,
              )
            : Container(
                height: 0,
                width: 0,
              ),
        title: Text(
          language!.languageName!,
          style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
        ),
      ),
    );
  }
}
