import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmerchantcontroller.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedvideoplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Language/appLocalization.dart';
import 'bebuzeeshopvideoplayer.dart';

class BebuzeeShopProductDetail extends StatefulWidget {
  BebuzeeShopMerchantController? controller;
  BebuzeeShopProductDetail({Key? key, this.controller}) : super(key: key);

  @override
  State<BebuzeeShopProductDetail> createState() =>
      _BebuzeeShopProductDetailState();
}

class _BebuzeeShopProductDetailState extends State<BebuzeeShopProductDetail> {
  @override
  Widget build(BuildContext context) {
    Widget _customURLInfoCard(String domain) {
      return Container(
        color: Colors.grey.shade100,
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10),
          title: Text(
            '',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            domain,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade600),
          ),
        ),
      );
    }

    void openYouTube() async {
      String url = widget.controller!.productDetail[0].embedVideo!;
      print("youtube video =${url}");
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Widget _youtubeCard() {
      return GestureDetector(
        onTap: () => openYouTube(),
        child: Container(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.red.shade800,
              shape: BoxShape.rectangle,
            ),
            child: Icon(
              Icons.play_arrow,
              size: 30,
              color: Colors.white,
            ),
          ),

          //  Column(
          //   children: [
          //     Stack(
          //       children: [
          //         // _customImageCard(feed[0].video.videoThumb, 100.0.w),
          //         Positioned.fill(
          //           child: Align(
          //             alignment: Alignment.center,
          //             child: Container(
          //               padding:
          //                   EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          //               decoration: new BoxDecoration(
          //                 borderRadius: BorderRadius.all(Radius.circular(5)),
          //                 color: Colors.red.shade800,
          //                 shape: BoxShape.rectangle,
          //               ),
          //               child: Icon(
          //                 Icons.play_arrow,
          //                 size: 30,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     _customURLInfoCard("youtube.com")
          //   ],
          // ),
        ),
      );
    }

    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          widget.controller!.clearProductDetail();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.black,
          ),
          body: widget.controller!.productDetail.value.length == 0
              ? Container(
                  height: 100.0.h,
                  width: 100.0.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonAnimation(
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Stack(
                                  alignment: Alignment.topLeft,
                                  children: [
                                    Container(
                                      height: 50.0.h,
                                      width: 100.0.w,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Positioned(
                                            child: CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.arrow_back,
                                              color: Colors.black),
                                        )),
                                        Row(
                                          children: [
                                            Positioned(
                                                child: GestureDetector(
                                              onTap: () {},
                                              child: CircleAvatar(
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.5),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Icon(Icons.share,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            )),
                                            SizedBox(
                                              width: 1.0.w,
                                            ),
                                            Positioned(
                                                child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.5),
                                              child: Icon(
                                                  Icons
                                                      .favorite_border_outlined,
                                                  color: Colors.black),
                                            )),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 2.0.w,
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      SizedBox(
                                        width: 2.0.w,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                  color: Colors.grey[200],
                  height: 180.0.h,
                  width: 100.0.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  Container(
                                    height: 50.0.h,
                                    width: 100.0.w,
                                    child: PageView.builder(
                                      itemCount: widget
                                          .controller!
                                          .productDetail[0]
                                          .productImages!
                                          .length,
                                      itemBuilder: (context, index) =>
                                          Container(
                                        height: 50.0.h,
                                        width: 100.0.w,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        widget
                                                                .controller!
                                                                .productDetail[0]
                                                                .productImages![
                                                            index]))),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Positioned(
                                          child: CircleAvatar(
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.5),
                                        child: Icon(Icons.arrow_back,
                                            color: Colors.black),
                                      )),
                                      Row(
                                        children: [
                                          Positioned(
                                              child: GestureDetector(
                                            onTap: () {
                                              showBarModalBottomSheet(
                                                  context: context,
                                                  builder: (ctx) => Container(
                                                        height: 20.0.h,
                                                        width: 100.0.w,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              title: Text(
                                                                  'Share to News Feed'),
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                  'Share to Others'),
                                                              onTap: () {
                                                                Share.share(
                                                                    '${widget.controller!.productDetail[0].productName}',
                                                                    subject:
                                                                        '${widget.controller!.productDetail[0].buyLink}');
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ));
                                            },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.5),
                                              child: Icon(Icons.share,
                                                  color: Colors.black),
                                            ),
                                          )),
                                          SizedBox(
                                            width: 1.0.w,
                                          ),
                                          // Positioned(
                                          //     child: CircleAvatar(
                                          //   backgroundColor:
                                          //       Colors.grey.withOpacity(0.5),
                                          //   child: Icon(
                                          //       Icons.favorite_border_outlined,
                                          //       color: Colors.black),
                                          // )),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('Adidas ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 2.0.h,
                                            overflow: TextOverflow.ellipsis)),
                                    Text('Tshirt Men Full-Sleeve')
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                        '${widget.controller!.productDetail[0].productPrise}\$',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 2.5.h,
                                            decoration:
                                                TextDecoration.lineThrough)),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    Text(
                                        '${widget.controller!.productDetail[0].sellingPrise}\$',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 3.0.h,
                                        )),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Text('(58% off)',
                                        style: TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 2.5.h,
                                        )),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Sizes Available',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 5.3.w,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 5.0.w,
                                      backgroundColor: Colors.white,
                                      child: Text('XS',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 5.3.w,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 5.0.w,
                                      backgroundColor: Colors.white,
                                      child: Text('S',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 5.3.w,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: 5.0.w,
                                      backgroundColor: Colors.white,
                                      child: Text('M',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Product Details',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Swap your usual T-shirt with the HRX Men\'s Running T-shirt and feel your run become easier and more comfortable. Designed with Rapid Dry technology, it wicks away sweat to keep you cool and dry from start to finish.',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Size and Fit',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'The model (height 6\') is wearing a size L',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Features',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Rapid Dry technology wicks sweat and dries fast \n Lightweight fabric makes movement easierTypographic print across chest Neck: Round Neck Sleeve Style: Regular Sleeve Length: Short T-shirt Length: Regular Color: Jet Black Fit: Regular',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Material & Care',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('100% polyester \n Machine-wash',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                            height: 30.0.h, width: 90.0.w, child: _youtubeCard()
                            // ShopbuzSamplePlayer(
                            //   url: widget.controller.productDetail[0].embedVideo,
                            //   // url:
                            //   //     ,
                            // ),
                            ),
                      )
                    ],
                  ),
                )),
        ),
      ),
    );
  }
}
