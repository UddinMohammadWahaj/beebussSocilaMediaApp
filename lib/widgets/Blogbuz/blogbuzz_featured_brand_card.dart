import 'package:bizbultest/models/blogbuzz_brand_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/brands_main_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:sizer/sizer.dart';

class FeaturedBrandCard extends StatefulWidget {
  final BrandModel? brand;
  final int? index;
  final int? lastIndex;

  const FeaturedBrandCard({Key? key, this.brand, this.index, this.lastIndex})
      : super(key: key);

  @override
  _FeaturedBrandCardState createState() => _FeaturedBrandCardState();
}

class _FeaturedBrandCardState extends State<FeaturedBrandCard> {
  @override
  void initState() {
    print(widget.lastIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0.w,
      height: 50.0.h,
      child: Stack(
        // overflow: Overflow.visible,
        children: [
          Container(
            color: Colors.grey.shade200,
            child: Image.network(
              widget.brand!.image!,
              fit: BoxFit.cover,
              width: 100.0.w,
              height: 50.0.h,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 95.0.w,
                color: Colors.grey.shade100,
                // height: 15.0.h,
                child: Padding(
                  padding: EdgeInsets.all(2.0.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.brand!.brandCategory!.toUpperCase(),
                        style: TextStyle(fontSize: 8.0.sp),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Container(
                            width: 80.0.w,
                            child: Text(
                              parse(widget.brand!.content)
                                  .documentElement!
                                  .text,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'Georgie'),
                              maxLines: 2,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Text(
                          widget.brand!.name!,
                          style: TextStyle(fontSize: 8.0.sp),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
