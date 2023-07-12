import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/shopbuzsearchbystorecontroller.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/BebuzeeShop/shopbuzstoresearchdetailinner.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../../models/BebuzeeShop/shopbuzsearchbystoredetailmodel.dart';
import '../../services/BebuzeeShop/bebuzeeshopmainproductdetailview.dart';
import '../Chat/detailed_direct_screen.dart';

class ShopBuzStoreSearchDetail extends StatefulWidget {
  ShopBuzSearchByStoreController? controller;
  BebuzeeShopManagerController? shopmanagercontroller;
  ShopBuzStoreSearchDetail(
      {Key? key, this.controller, this.shopmanagercontroller})
      : super(key: key);

  @override
  State<ShopBuzStoreSearchDetail> createState() =>
      _ShopBuzStoreSearchDetailState();
}

class _ShopBuzStoreSearchDetailState extends State<ShopBuzStoreSearchDetail> {
  @override
  void dispose() {
    widget.controller!.merchantStoreData.value = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget storeImage() {
      return Obx(() => widget.controller!.merchantStoreData.length == 0
          ? SkeletonAnimation(
              child: Card(
                child: Container(
                  height: 20.0.h,
                  width: 90.0.w,
                  color: Colors.grey,
                ),
              ),
            )
          : Container(
              height: 20.0.h,
              width: 90.0.w,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          widget.controller!.merchantStoreData[0].storeIcon!))),
            ));
    }

    Widget storeContact() {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailedDirectScreen(
                              from: "profile",
                              // setNavbar: widget
                              //     .setNavbar,
                              token: '',
                              name: widget
                                  .controller!.merchantStoreData[0].userName!,
                              image: widget.controller!.merchantStoreData[0]
                                  .userProfile!,
                              memberID: widget
                                  .controller!.merchantStoreData[0].userId
                                  .toString(),
                            )));
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
                print(
                    "store url= ${widget.controller!.merchantStoreData[0].websiteLink}");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebsiteView(
                            url:
                                "${widget.controller!.merchantStoreData[0].websiteLink}",
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

    Widget storeInfo() {
      return Obx(() => widget.controller!.merchantStoreData.length != 0
          ? ListTile(
              dense: true,
              title:
                  Text('${widget.controller!.merchantStoreData[0].storeName}'),
              subtitle: Text(
                  '${widget.controller!.merchantStoreData[0].storeDetails}'),
              // trailing: ElevatedButton.icon(
              //     style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all(Colors.black)),
              //     onPressed: () {},
              //     icon: Icon(CustomIcons.chat_icon),
              //     label: Text(
              //       'Contact Merchant',
              //       style: TextStyle(fontSize: 1.5.h),
              //     )),
            )
          : ListTile(
              title: SkeletonAnimation(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.grey.shade300,
                      height: 2.0.h,
                      width: 15.0.w,
                    )),
              ),
              subtitle: SkeletonAnimation(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: Colors.grey.shade300,
                      height: 2.0.h,
                      width: 10.0.w,
                    )),
              ),
            ));
      ;
    }

    Widget storeWidget() {
      return Card(
        child: Column(
          children: [storeImage(), storeInfo()],
        ),
      );
    }

    Widget customHeader({text: '', size: 10}) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontSize: size),
        ),
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

    Widget customProductWidget({
      productImgLink: '',
      productName: '',
      productPrice: '',
      productCurrency: '',
      productId: '',
    }) {
      return GestureDetector(
        onTap: () {
          widget.shopmanagercontroller!.getProductDetail(productId: productId);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BebuzeeShopMainProductDetail(
                    controller: widget.shopmanagercontroller,
                    from: 'store',
                  )));
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customProductImage(imgUrl: productImgLink),
              customProductInfo(
                  productCurrency: productCurrency,
                  productName: productName,
                  productPrice: productPrice)
            ],
          ),
        ),
      );
    }

    Widget noCustomProductImage() {
      return Container(
        height: 20.0.h,
        width: 35.0.w,
        color: Colors.grey,
      );
    }

    Widget nocustomProductInfo() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonAnimation(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Colors.grey.shade300,
                  height: 2.0.h,
                  width: 15.0.w,
                )),
          ),
          SizedBox(
            height: 1.0.h,
          ),
          SkeletonAnimation(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color: Colors.grey.shade300,
                  height: 2.0.h,
                  width: 15.0.w,
                )),
          ),
        ],
      );
    }

    Widget noCustomProductWidget() {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [noCustomProductImage(), nocustomProductInfo()],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new)),
        ),
        body: SingleChildScrollView(
            child: Container(
                width: 100.0.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    storeWidget(),
                    storeContact(),
                    Obx(() => widget.controller!.merchantStoreData.length != 0
                        ? FutureBuilder(
                            future: widget.controller!.bebuzeeshopapi
                                .getSearchByStoreDetailModel(widget
                                    .controller!.merchantStoreData[0].storeId),
                            builder: (ctx, dynamic snapshot) => snapshot
                                        .hasData ==
                                    false
                                ? Column(
                                    children: [
                                      SkeletonAnimation(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SkeletonAnimation(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Container(
                                                    color: Colors.grey.shade300,
                                                    height: 2.0.h,
                                                    width: 15.0.w,
                                                  )),
                                            ),
                                            SkeletonAnimation(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Container(
                                                    color: Colors.grey.shade300,
                                                    height: 2.0.h,
                                                    width: 15.0.w,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // customHeader(text: 'Shoes & Jwelery', size: 2.0.h),
                                      Container(
                                        height: 30.0.h,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: 3,
                                            itemBuilder: (context, index) {
                                              return customProductWidget();
                                            }),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, index) =>
                                        Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              customHeader(
                                                  text:
                                                      '${snapshot.data[index].subcategoryName}',
                                                  size: 2.0.h),
                                              GestureDetector(
                                                  onTap: () {
                                                    widget.controller!
                                                        .getProductListByFilterBySubCategory(
                                                            snapshot.data[index]
                                                                .subcategoryId
                                                                .toString());
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          StoreSearchDetailInnerView(
                                                              controller: widget
                                                                  .controller!,
                                                              productCat: snapshot
                                                                  .data[index]
                                                                  .subcategoryName),
                                                    ));
                                                  },
                                                  child: customHeader(
                                                      text: 'View All',
                                                      size: 2.0.h)),
                                            ],
                                          ),

                                          // customHeader(text: 'Shoes & Jwelery', size: 2.0.h),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            height: 30.0.h,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: snapshot.data[index]
                                                    .productData.length,
                                                itemBuilder:
                                                    (context, productindex) {
                                                  return customProductWidget(
                                                      productImgLink: snapshot
                                                          .data[index]
                                                          .productData[
                                                              productindex]
                                                          .productImages[0],
                                                      productCurrency: snapshot
                                                          .data[index]
                                                          .productData[
                                                              productindex]
                                                          .priseCurrency,
                                                      productId: snapshot
                                                          .data[index]
                                                          .productData[
                                                              productindex]
                                                          .productId,
                                                      productName: snapshot
                                                          .data[index]
                                                          .productData[
                                                              productindex]
                                                          .productName,
                                                      productPrice: snapshot
                                                          .data[index]
                                                          .productData[
                                                              productindex]
                                                          .productPrise);
                                                }),
                                          ),
                                        ])))
                        : Column(
                            children: [
                              SkeletonAnimation(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SkeletonAnimation(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            height: 2.0.h,
                                            width: 15.0.w,
                                          )),
                                    ),
                                    SkeletonAnimation(
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            color: Colors.grey.shade300,
                                            height: 2.0.h,
                                            width: 15.0.w,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              // customHeader(text: 'Shoes & Jwelery', size: 2.0.h),
                              Container(
                                height: 30.0.h,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return noCustomProductWidget();
                                    }),
                              ),
                            ],
                          )),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     customHeader(text: 'Shoes & Jwelery', size: 2.0.h),
                    //     customHeader(text: 'View All', size: 2.0.h),
                    //   ],
                    // ),
                    // Container(
                    //   height: 30.0.h,
                    //   child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       shrinkWrap: true,
                    //       itemCount: 18,
                    //       itemBuilder: (context, index) {
                    //         return customProductWidget();
                    //       }),
                    // ),
                  ],
                )))

        // ListView.builder(
        //     shrinkWrap: true, itemBuilder: (ctx, index) => customBox())

        // ),

        );
  }
}
