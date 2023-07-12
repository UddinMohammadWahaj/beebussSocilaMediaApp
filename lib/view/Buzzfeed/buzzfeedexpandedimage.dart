import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

class BuzzfeedExpandedImage extends StatefulWidget {
  List listofimages;
  var index;

  BuzzfeedExpandedImage({Key? key, this.index, this.listofimages = const []})
      : super(key: key);

  @override
  State<BuzzfeedExpandedImage> createState() => _BuzzfeedExpandedImageState();
}

class _BuzzfeedExpandedImageState extends State<BuzzfeedExpandedImage> {
  late PageController pageController;

  Widget listofimagecard() {
    // return Container();
    return PageView.builder(
      controller: pageController,
      itemBuilder: (context, index) => imageCard(index),
      itemCount: widget.listofimages.length,
      scrollDirection: Axis.horizontal,
    );

    return Container(
        child: ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(
          width: 2.0.w,
        );
      },
      shrinkWrap: true,
      itemCount: widget.listofimages.length,
      scrollDirection: Axis.horizontal,
      physics: PageScrollPhysics(), // this is what you are looking for
      itemBuilder: (context, index) {
        return imageCard(index);
      },
      // children: [imageCard(0), imageCard(1), imageCard(2), imageCard(3)],
    ));
  }

  Widget imageCard(imageindex) {
    return ClipRRect(
      child: Container(
        width: 100.0.h,
        child: ClipRRect(
          child: CachedNetworkImage(
            fit: BoxFit.contain,
            // placeholder: (context, url) => SkeletonAnimation(
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(2.0.w),
            //     child: Container(
            //       width: widget.listofimages.length == 1 ? 75.0.w : 35.0.w,
            //       color: Colors.grey[500],
            //     ),
            //   ),
            // ),
            imageUrl: widget.listofimages[imageindex],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    pageController = new PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // leading: IconButton(onPressed: (){navigator.}, icon: icon),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Container(
          color: Colors.black,
          height: 100.0.h,
          width: 100.0.h,
          child: listofimagecard()),
    );
  }
}
