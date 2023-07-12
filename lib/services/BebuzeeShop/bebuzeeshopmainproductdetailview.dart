import 'dart:async';

import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmerchantcontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/shopbuzsearchbystorecontroller.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedvideoplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../Language/appLocalization.dart';
import '../../utilities/custom_icons.dart';
import '../../view/BebuzeeShop/shopbuzstoresearchdetail.dart';
import '../../view/Chat/detailed_direct_screen.dart';
import '../../view/Wallet/widgets/percentindicator.dart';
import '../../view/web_view.dart';
import '../../widgets/Stories/multiple_story_files.dart';
import 'bebuzeeshopvideoplayer.dart';

class BebuzeeShopMainProductDetail extends StatefulWidget {
  BebuzeeShopManagerController? controller;
  String? from;
  BebuzeeShopMainProductDetail({Key? key, this.controller, this.from = ''})
      : super(key: key);

  @override
  State<BebuzeeShopMainProductDetail> createState() =>
      _BebuzeeShopMainProductDetailState();
}

class _BebuzeeShopMainProductDetailState
    extends State<BebuzeeShopMainProductDetail> {
  void initState() {
    print("data transaction error");
    printError(info: 'data log error');
  }

  @override
  Widget build(BuildContext context) {
    Widget _contactButton(
        IconData icon, String value, VoidCallback onTap, double padding) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50.0.w - padding,
          height: 55,
          color: Colors.red.shade800,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 25,
                  )),
              Text(
                AppLocalizations.of(value),
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              )
            ],
          ),
        ),
      );
    }

    Widget _contactAdvertiserRow() {
      return VisibilityDetector(
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction > 0) {
            widget.controller!.isContactVisible.value = true;
            print("visible");
          } else {
            widget.controller!.isContactVisible.value = false;
            print("not visible");
          }
        },
        key: ObjectKey(widget.controller!.visibilityKey),
        child: Container(
          margin: EdgeInsets.only(bottom: 15, top: 30),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _contactButton(
                  Icons.email,
                  AppLocalizations.of(
                    "CONTACT",
                  ),
                  () {},
                  15),
            ],
          ),
        ),
      );
    }

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

    Widget customProductInfo(
        {productName: '', productPrice: '', productCurrency: ''}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 1.0.w, top: 0.5.h),
            child: Text(productName,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 1.0.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 1.0.w),
            child: Text(
              '${productPrice} $productCurrency',
              style: TextStyle(color: Colors.grey.shade400),
            ),
          )
        ],
      );
    }

    Widget customProductImage({imgUrl: ''}) {
      return Container(
        height: 20.0.h,
        width: 35.0.w,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: CachedNetworkImageProvider(imgUrl))),
      );
    }

    Widget customProductWidget({
      productImgLink: '',
      productName: '',
      productPrice: '',
      productCurrency: '',
      productId: '',
    }) {
      return GestureDetector(
        onTap: () {},
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customProductImage(
                  imgUrl: widget.controller!.productList[0].productImages![0]),
              customProductInfo(
                  productCurrency: 'AUD',
                  productName: 'T-shirt',
                  productPrice: '999')
            ],
          ),
        ),
      );
    }

    Widget storeContact() {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                // Navigator.push(
                //     context,
                // MaterialPageRoute(
                //     builder: (context) => DetailedDirectScreen(
                //           from: "profile",
                //           // setNavbar: widget
                //           //     .setNavbar,
                //           token: '',
                //           name: widget
                //               .controller.merchantStoreData[0].userName,
                //           image: widget
                //               .controller.merchantStoreData[0].userProfile,
                //           memberID: widget
                //               .controller.merchantStoreData[0].userId
                //               .toString(),
                //         )));
              },
              icon: Icon(CustomIcons.chat_icon, color: Colors.black),
              label: Text(
                'Contact Merchant',
                style: TextStyle(fontSize: 1.5.h, color: Colors.black),
              )),
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebsiteView(
                            url:
                                "${widget.controller!.productDetail[0].buyLink}",
                            heading: "")));
              },
              icon: Icon(Icons.shop_2_outlined),
              label: Text(
                'Visit Store',
                style: TextStyle(fontSize: 1.5.h),
              )),
        ],
      );
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
          //         ),f
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
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  widget.controller!.clearProductDetail();
                  Navigator.of(context).pop();
                }),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50.0.h,
                              width: 100.0.w,
                              child: PageView.builder(
                                itemCount: widget.controller!.productDetail[0]
                                    .productImages!.length,
                                itemBuilder: (context, index) => Container(
                                  height: 50.0.h,
                                  width: 100.0.w,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              widget
                                                  .controller!
                                                  .productDetail[0]
                                                  .productImages![index]))),
                                ),
                              ),
                            ),
                            // Center(
                            //   child: Stack(
                            //     alignment: Alignment.topLeft,
                            //     children: [
                            // Container(
                            //   height: 50.0.h,
                            //   width: 100.0.w,
                            //   child: PageView.builder(
                            //     itemCount: widget
                            //         .controller
                            //         .productDetail[0]
                            //         .productImages
                            //         .length,
                            //     itemBuilder: (context, index) =>
                            //         Container(
                            //       height: 50.0.h,
                            //       width: 100.0.w,
                            //       decoration: BoxDecoration(
                            //           image: DecorationImage(
                            //               image:
                            //                   CachedNetworkImageProvider(
                            //                       widget
                            //                               .controller
                            //                               .productDetail[0]
                            //                               .productImages[
                            //                           index]))),
                            //     ),
                            //   ),
                            // ),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Positioned(
                            //         child: CircleAvatar(
                            //       backgroundColor:
                            //           Colors.grey.withOpacity(0.5),
                            //       child: Icon(Icons.arrow_back,
                            //           color: Colors.black),
                            //     )),
                            //     Row(
                            //       children: [
                            //         Positioned(
                            //             child: GestureDetector(
                            //           onTap: () {
                            //             showBarModalBottomSheet(
                            //                 context: context,
                            //                 builder: (ctx) => Container(
                            //                       height: 20.0.h,
                            //                       width: 100.0.w,
                            //                       child: Column(
                            //                         children: [
                            //                           ListTile(
                            //                             onTap: () {
                            //                               Navigator.push(
                            //                                   context,
                            //                                   MaterialPageRoute(
                            //                                       builder: (context) =>
                            //                                           MultipleStoriesView(
                            //                                             assetsList: [],
                            //                                             // whereFrom: widget.whereFrom,
                            //                                             // refreshFromMultipleStories: widget.refreshFromMultipleStories,
                            //                                             file: null,
                            //                                             flip: false,
                            //                                             from: "shopbuz",
                            //                                             shoppingItemtitle: widget.controller.productDetail[0].productName,
                            //                                             shoppingItemsubtitle: widget.controller.productDetail[0].productBrand,
                            //                                             shoppingItemPrice: '${widget.controller.productDetail[0].priseCurrency} ${widget.controller.productDetail[0].sellingPrise}',
                            //                                             shoppingStore: widget.controller.productDetail[0].storeIcon,
                            //                                             shoppingImage: widget.controller.productDetail[0].productImages[0],
                            //                                             // questionsReplyTextData: '',
                            //                                           )));
                            //                             },
                            //                             title: Text(
                            //                                 'Share to Story'),
                            //                           ),
                            //                           ListTile(
                            //                             title: Text(
                            //                                 'Share to Others'),
                            //                             onTap: () {
                            //                               Share.share(
                            //                                   '${widget.controller.productDetail[0].productName}',
                            //                                   subject:
                            //                                       '${widget.controller.productDetail[0].buyLink}');
                            //                             },
                            //                           )
                            //                         ],
                            //                       ),
                            //                     ));
                            //           },
                            //           child: CircleAvatar(
                            //             backgroundColor:
                            //                 Colors.grey.withOpacity(0.5),
                            //             child: Icon(Icons.share,
                            //                 color: Colors.black),
                            //           ),
                            //         )),
                            //         SizedBox(
                            //           width: 1.0.w,
                            //         ),
                            //         // Positioned(
                            //         //     child: CircleAvatar(
                            //         //   backgroundColor:
                            //         //       Colors.grey.withOpacity(0.5),
                            //         //   child: Icon(
                            //         //       Icons.favorite_border_outlined,
                            //         //       color: Colors.black),
                            //         // )),
                            //       ],
                            //     )
                            //   ],
                            // )
                            //     ],
                            //   ),
                            // ),
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
                      widget.from == 'store'
                          ? Container()
                          : Card(
                              child: ListTile(
                                onTap: () {
                                  // widget.controller.clearProductDetail();
                                  // Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebsiteView(
                                              url:
                                                  "${widget.controller!.productDetail[0].buyLink}",
                                              heading: "")));
                                  return;
                                  Get.delete<ShopBuzSearchByStoreController>();
                                  ShopBuzSearchByStoreController
                                      shopBuzSearchByStoreController =
                                      Get.put(ShopBuzSearchByStoreController());

                                  shopBuzSearchByStoreController
                                      .fetchMerchantStoreDetails(widget
                                          .controller!
                                          .productDetail[0]
                                          .storeId);
                                  Timer(Duration(seconds: 1), () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                ShopBuzStoreSearchDetail(
                                                  controller:
                                                      shopBuzSearchByStoreController,
                                                  shopmanagercontroller:
                                                      widget.controller!,
                                                )));
                                  });
                                },
                                leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        '${widget.controller!.productDetail[0].storeIcon}')),
                                title: Text('Visit Store'),
                                trailing: Icon(Icons.arrow_right_alt_outlined),
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
                              child: Text('Colors Available',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 10.0.h,
                                width: 100.0.w,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                    )
                                  ],
                                ),

                                // ListView.builder(
                                //   shrinkWrap: true,
                                //   scrollDirection: Axis.horizontal,
                                //   itemCount: widget.controller.productDetail[0]
                                //               .productColor
                                //               .toString()
                                //               .length ==
                                //           1
                                //       ? 1
                                //       : widget.controller.productDetail[0]
                                //           .productColor
                                //           .split(',')
                                //           .length,
                                //   itemBuilder: (ctx, index) => CircleAvatar(
                                //       backgroundColor: HexColor(
                                //           '#${widget.controller.productDetail[0].productColor.toString().length == 1 ? widget.controller.productDetail[0].colorlist : widget.controller.productDetail[0].colorlist.split(',')[index]}')),
                                // ),
                              ),
                            ),
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
                                  '${widget.controller!.productDetail[0].productDetails}',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            //
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
                      ),
                      storeContact(),
                      Card(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Rating and Review',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '4.3',
                                          style: TextStyle(fontSize: 5.0.h),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.green,
                                        )
                                      ],
                                    ),
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 15.0.h,
                                      width: 0.2.w,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 15.0.h,
                                      child: Column(
                                        children: [
                                          LinearPercentIndicator(
                                            width: 100.0,
                                            lineHeight: 0.5.h,
                                            percent: 0.9,
                                            leading: Row(children: [
                                              Text('5'),
                                              Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                                size: 1.0.h,
                                              )
                                            ]),
                                            progressColor: Colors.green,
                                          ),
                                          LinearPercentIndicator(
                                            width: 100.0,
                                            lineHeight: 0.5.h,
                                            percent: 0.5,
                                            leading: Row(children: [
                                              Text('4'),
                                              Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                                size: 1.0.h,
                                              )
                                            ]),
                                            progressColor: Colors.green,
                                          ),
                                          LinearPercentIndicator(
                                            width: 100.0,
                                            lineHeight: 0.5.h,
                                            percent: 0.3,
                                            leading: Row(children: [
                                              Text('3'),
                                              Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                                size: 0.5.h,
                                              )
                                            ]),
                                            progressColor: Colors.green,
                                          ),
                                          LinearPercentIndicator(
                                            width: 100.0,
                                            lineHeight: 0.5.h,
                                            percent: 0.2,
                                            leading: Row(children: [
                                              Text('2'),
                                              Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                                size: 1.0.h,
                                              )
                                            ]),
                                            progressColor: Colors.yellow,
                                          ),
                                          LinearPercentIndicator(
                                            width: 100.0,
                                            lineHeight: 0.5.h,
                                            percent: 0.1,
                                            leading: Row(children: [
                                              Text('1'),
                                              Icon(
                                                Icons.star,
                                                color: Colors.grey,
                                                size: 1.0.h,
                                              )
                                            ]),
                                            progressColor: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                height: 0.5.h,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('What Customers said',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 15.0.h,
                                  child: Column(
                                    children: [
                                      LinearPercentIndicator(
                                        width: 100.0,
                                        lineHeight: 0.5.h,
                                        percent: 0.9,
                                        leading: Row(children: [
                                          Text('Excellent',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ]),
                                        progressColor: Colors.green,
                                      ),
                                      LinearPercentIndicator(
                                        width: 100.0,
                                        lineHeight: 0.5.h,
                                        percent: 0.5,
                                        leading: Row(children: [
                                          Text('Very Good',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ]),
                                        progressColor: Colors.green,
                                      ),
                                      LinearPercentIndicator(
                                        width: 100.0,
                                        lineHeight: 0.5.h,
                                        percent: 0.3,
                                        leading: Row(children: [
                                          Text('Good',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ]),
                                        progressColor: Colors.green,
                                      ),
                                      LinearPercentIndicator(
                                        width: 100.0,
                                        lineHeight: 0.5.h,
                                        percent: 0.2,
                                        leading: Row(children: [
                                          Text('Average',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ]),
                                        progressColor: Colors.yellow,
                                      ),
                                      LinearPercentIndicator(
                                        width: 100.0,
                                        lineHeight: 0.5.h,
                                        percent: 0.1,
                                        leading: Row(children: [
                                          Text('Awful',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ]),
                                        progressColor: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(() => widget.controller!.submit.value
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Write your Experience',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            onChanged: (val) {},
                                            onTap: () {},
                                            maxLines: 10,
                                            controller: TextEditingController(),
                                            keyboardType: TextInputType.text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            decoration: InputDecoration(
                                              hintText: AppLocalizations.of(
                                                "Tell us your experience",
                                              ),
                                              border: OutlineInputBorder(),

                                              // 48 -> icon width
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Rate the product',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 70.0.w,
                                            child: Row(children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    widget.controller!.rate(0);
                                                  },
                                                  child: Icon(
                                                    Icons.star_border,
                                                    color: widget.controller!
                                                            .rating[0]
                                                        ? Colors.yellow
                                                        : Colors.black,
                                                  )),
                                              GestureDetector(
                                                  onTap: () {
                                                    onTap:
                                                    widget.controller!.rate(1);
                                                  },
                                                  child: Icon(
                                                    Icons.star_border,
                                                    color: widget.controller!
                                                            .rating[1]
                                                        ? Colors.yellow
                                                        : Colors.black,
                                                  )),
                                              GestureDetector(
                                                  onTap: () {
                                                    widget.controller!.rate(2);
                                                  },
                                                  child: Icon(
                                                    Icons.star_border,
                                                    color: widget.controller!
                                                            .rating[2]
                                                        ? Colors.yellow
                                                        : Colors.black,
                                                  )),
                                              GestureDetector(
                                                  onTap: () {
                                                    widget.controller!.rate(3);
                                                  },
                                                  child: Icon(
                                                    Icons.star_border,
                                                    color: widget.controller!
                                                            .rating[3]
                                                        ? Colors.yellow
                                                        : Colors.black,
                                                  )),
                                              GestureDetector(
                                                  onTap: () {
                                                    widget.controller!.rate(4);
                                                  },
                                                  child: Icon(
                                                    Icons.star_border,
                                                    color: widget.controller!
                                                            .rating[4]
                                                        ? Colors.yellow
                                                        : Colors.black,
                                                  )),
                                            ]),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black)),
                                              onPressed: () {
                                                widget.controller!.submit
                                                    .value = true;
                                              },
                                              child: Text(
                                                'Submit',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )),
                                      ],
                                    )
                                  : Container())
                            ]),
                      ),
//                       Card(
//                           child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text('View Similar',
//                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                           ),
// // FutureBuilder(
// //   builder: (context, snapshot) => ,
// //   future: wid,
// // )
//                           Container(
//                             height: 30.0.h,
//                             child:

//                              ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 shrinkWrap: true,
//                                 itemCount: 18,
//                                 itemBuilder: (context, index) {
//                                   return customProductWidget();
//                                 }),
//                           ),
//                         ],
//                       )),
                      // Card(
                      //     child: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text('Recently Viewed',
                      //           style: TextStyle(fontWeight: FontWeight.bold)),
                      //     ),
                      //     Container(
                      //       height: 30.0.h,
                      //       child: ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           shrinkWrap: true,
                      //           itemCount: 18,
                      //           itemBuilder: (context, index) {
                      //             return customProductWidget();
                      //           }),
                      //     ),
                      //   ],
                      // ))
                    ],
                  ),
                ),
          bottomNavigationBar: Container(
            height: 5.0.h,
            width: 100.0.w,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WebsiteView(url: "www.dior.com", heading: "")));
              },
              child: Center(
                  child: Text(
                'BUY',
                style: TextStyle(
                    fontSize: 2.0.h,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
            ),
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
