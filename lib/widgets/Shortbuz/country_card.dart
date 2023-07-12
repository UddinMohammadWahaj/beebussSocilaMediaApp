import 'package:bizbultest/models/shortbuz/shortbuzz_country_model.dart';
import 'package:bizbultest/models/update_channel_categories_model.dart';
import 'package:bizbultest/models/update_channel_video_country_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShortbuzCountryCard extends StatelessWidget {
  final ShortbuzzCountryModelCountry? country;
  final String? selectedCountry;
  final VoidCallback? onTap;

  const ShortbuzCountryCard(
      {Key? key, this.country, this.selectedCountry, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: onTap ?? () {},
        leading: selectedCountry == country!.countryName!
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
          country!.countryName!,
          style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
        ),
      ),
    );
  }
}
