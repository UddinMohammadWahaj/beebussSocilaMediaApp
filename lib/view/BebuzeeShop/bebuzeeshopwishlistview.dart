import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopcollectioncontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';

import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeeshopcollection.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeeshopcreatecollection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../services/BebuzeeShop/bebuzeeshopmainproductdetailview.dart';
import '../../services/BebuzeeShop/shopbuzwishlistcontroller.dart';
import '../../utilities/custom_icons.dart';
import '../../widgets/Properbuz/property/filter_bottom_sheet.dart';

enum shopaction { select, none }

class BebuzeeShopWishlistView extends StatefulWidget {
  shopaction action;
  BebuzeeShopManagerController? shopmanagercontroller;
  ShopbuzWishlistController? wishlistcontroller;
  BebuzeeShopCollectionController? shopcollectioncontroller;
  BebuzeeShopWishlistView(
      {Key? key,
      this.action = shopaction.none,
      this.shopmanagercontroller,
      this.wishlistcontroller,
      this.shopcollectioncontroller})
      : super(key: key);

  @override
  State<BebuzeeShopWishlistView> createState() =>
      _BebuzeeShopWishlistViewState();
}

class _BebuzeeShopWishlistViewState extends State<BebuzeeShopWishlistView> {
  @override
  void dispose() {
    Get.delete<ShopbuzWishlistController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var widget.wishlistcontroller = Get.put(ShopbuzWishlistController());
    var products = [
      {
        "name": "Clothing",
        "url":
            "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/amazon-fashion-1567536428.jpg?crop=1xw:1xh;center,top&resize=480:*"
      },
      {
        "name": "Electronics",
        "url":
            'https://m.economictimes.com/thumb/msid-71337200,width-1200,height-900,resizemode-4,imgsize-91210/prime-users-get-special-access-to-discounts-on-saturday-.jpg'
      },
      {
        "name": "Beauty",
        "url":
            "https://inc42.com/wp-content/uploads/2021/02/feature-2021-02-05T130656.416.jpg",
      },
      {
        "name": "Shoes",
        "url":
            'https://assets.myntassets.com/dpr_1.5,q_60,w_400,c_limit,fl_progressive/assets/images/11391306/2020/2/12/10b9eea6-35be-4b7d-8c39-826d4d3500c11581485549564-US-Polo-Assn-Men-Casual-Shoes-4671581485548936-1.jpg'
      },
      {
        "name": "Sports and Fitness",
        "url":
            'https://cdn.shopify.com/s/files/1/1564/6971/articles/GymEquipment_en62b3d902b24c8f3293fcb8a216643540_cdf0e5b5-a39a-42be-a940-33dae68c44bb_1024x1024.jpg?v=1614636083'
      },
      {
        "name": "Accessories",
        "url": "https://img.faballey.com/images/Product/EBG00006/1.jpg"
      }
    ];

    Widget customGridView() {
      return Obx(() => widget
                  .wishlistcontroller!.currentSelectedCategory.value !=
              'All'
          ? GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 40.0.h,
                  childAspectRatio: 1,
                  mainAxisExtent: 40.0.h,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0),
              itemCount: widget.wishlistcontroller!.filterwishlistdata.length,
              itemBuilder: (ctx, index) {
                return Container(
                  height: 60.0.h,
                  width: 30.0.w,
                  color: Colors.white,
                  child: GestureDetector(
                    child: Card(
                      child: Column(children: [
                        Stack(alignment: Alignment.topRight, children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                height: 25.0.h,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          '${widget.wishlistcontroller!.filterwishlistdata[index].productImages![0]}',
                                        ))),
                              ),
                              Positioned(
                                bottom: 10,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              '4.3',
                                              style: TextStyle(fontSize: 1.5.h),
                                            ),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.green,
                                            size: 2.0.h,
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                          widget.action == shopaction.select
                              ? GestureDetector(
                                  onTap: () {
                                    // widget.shopmanagercontroller
                                    //     .addToWishlist(index);
                                    widget.wishlistcontroller!
                                        .selectForCollection(index);
                                  },
                                  child: Obx(
                                    () => CircleAvatar(
                                      radius: 2.h,
                                      backgroundColor: widget
                                              .wishlistcontroller!
                                              .wishlistlistdata[index]
                                              .isCollection!
                                              .value
                                          ? HexColor('#232323')
                                          : Colors.black.withOpacity(0.2),
                                      child: widget
                                              .wishlistcontroller!
                                              .wishlistlistdata[index]
                                              .isCollection!
                                              .value
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : null,
                                      // child: Center(
                                      //   child: IconButton(
                                      //       onPressed: () {},
                                      //       icon: Icon(Icons.circle,
                                      //           size: 1.7.h, color: Colors.white)),
                                      // )
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 2.h,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: IconButton(
                                        onPressed: () async {
                                          showBarModalBottomSheet(
                                              context: context,
                                              builder: (ctx) => Container(
                                                    height: 20.0.h,
                                                    width: 100.0.w,
                                                    child: Column(children: [
                                                      ListTile(
                                                        onTap: () {
                                                          widget
                                                              .wishlistcontroller!
                                                              .removeWishlistData(widget
                                                                  .wishlistcontroller!
                                                                  .filterwishlistdata[
                                                                      index]
                                                                  .productId);
                                                          Navigator.of(context)
                                                              .pop();
                                                          Get.snackbar(
                                                              'Success',
                                                              'Removed from wishlist successfully',
                                                              backgroundColor:
                                                                  Colors.white,
                                                              animationDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          650));
                                                        },
                                                        title: Text(
                                                            'Remove from Wishlist'),
                                                        trailing:
                                                            Icon(Icons.delete),
                                                      )
                                                    ]),
                                                  ));
                                        },
                                        icon: Icon(Icons.more_vert_outlined,
                                            size: 1.7.h, color: Colors.white)),
                                  ))
                        ]),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                                // trailing: IconButton(
                                //     onPressed: () {},
                                //     icon: Icon(
                                //       Icons.favorite_border_outlined,
                                //       size: 3.0.h,
                                //     )),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          '${widget.wishlistcontroller!.filterwishlistdata[index].productBrand} ${widget.wishlistcontroller!.wishlistlistdata[index].productName}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    // Expanded(
                                    //     child: IconButton(
                                    //         onPressed: () {},
                                    //         icon: Icon(
                                    //           Icons.favorite_border_outlined,
                                    //           size: 3.0.h,
                                    //         )))
                                  ],
                                ),
                                isThreeLine: true,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${widget.wishlistcontroller!.filterwishlistdata[index].categoryName}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                    Text(
                                        '${widget.wishlistcontroller!.filterwishlistdata[index].productPrise} ${widget.wishlistcontroller!.wishlistlistdata[index].priseCurrency}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                    // Text('Delivery by 25 Sep',
                                    //     style:
                                    //         TextStyle(fontWeight: FontWeight.normal)),
                                  ],
                                )),
                          ),
                        )
                      ]),
                    ),
                    onTap: () {
                      print('tapped on wishist itm');
                      widget.shopmanagercontroller!.getProductDetail(
                          productId: widget.wishlistcontroller!
                              .filterwishlistdata[index].productId);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BebuzeeShopMainProductDetail(
                                controller: widget.shopmanagercontroller,
                                from: 'store',
                              )));
                    },
                  ),
                );
              })
          : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 40.0.h,
                  childAspectRatio: 1,
                  mainAxisExtent: 40.0.h,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0),
              itemCount: widget.wishlistcontroller!.wishlistlistdata.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    print('tapped on wishist itm');
                    widget.shopmanagercontroller!.getProductDetail(
                        productId: widget.wishlistcontroller!
                            .wishlistlistdata[index].productId);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BebuzeeShopMainProductDetail(
                              controller: widget.shopmanagercontroller,
                              from: 'store',
                            )));
                  },
                  child: Container(
                    height: 60.0.h,
                    width: 30.0.w,
                    color: Colors.white,
                    child: Card(
                      child: Column(children: [
                        Stack(alignment: Alignment.topRight, children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                height: 25.0.h,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          '${widget.wishlistcontroller!.wishlistlistdata[index].productImages![0]}',
                                        ))),
                              ),
                              Positioned(
                                bottom: 10,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              '4.3',
                                              style: TextStyle(fontSize: 1.5.h),
                                            ),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.green,
                                            size: 2.0.h,
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                          widget.action == shopaction.select
                              ? GestureDetector(
                                  onTap: () {
                                    // widget.shopmanagercontroller
                                    //     .addToWishlist(index);
                                    widget.wishlistcontroller!
                                        .selectForCollection(index);
                                  },
                                  child: Obx(
                                    () => CircleAvatar(
                                      radius: 2.h,
                                      backgroundColor: widget
                                              .wishlistcontroller!
                                              .wishlistlistdata[index]
                                              .isCollection!
                                              .value
                                          ? HexColor('#232323')
                                          : Colors.black.withOpacity(0.2),
                                      child: widget
                                              .wishlistcontroller!
                                              .wishlistlistdata[index]
                                              .isCollection!
                                              .value
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : null,
                                      // child: Center(
                                      //   child: IconButton(
                                      //       onPressed: () {},
                                      //       icon: Icon(Icons.circle,
                                      //           size: 1.7.h, color: Colors.white)),
                                      // )
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 2.h,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: IconButton(
                                        onPressed: () async {
                                          // print(
                                          //     "tapped on =${widget.wishlistcontroller.filterwishlistdata.length}");
                                          // widget.wishlistcontroller
                                          //     .removeWishlistData(widget
                                          //         .wishlistcontroller
                                          //         .wishlistlistdata[index]
                                          //         .productId);
                                          // Get.snackbar('Success',
                                          //     'Removed from wishlist successfully',
                                          //     backgroundColor: Colors.white,
                                          //     animationDuration:
                                          //         Duration(seconds: 1));
                                          showBarModalBottomSheet(
                                              context: context,
                                              builder: (ctx) => Container(
                                                    height: 20.0.h,
                                                    width: 100.0.w,
                                                    child: Column(children: [
                                                      ListTile(
                                                        trailing:
                                                            Icon(Icons.close),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      ListTile(
                                                        onTap: () {
                                                          widget
                                                              .wishlistcontroller!
                                                              .removeWishlistData(widget
                                                                  .wishlistcontroller!
                                                                  .wishlistlistdata[
                                                                      index]
                                                                  .productId);
                                                          // Get.snackbar('Success',
                                                          //     'Removed from wishlist successfully',
                                                          //     backgroundColor: Colors.white,
                                                          //     animationDuration:
                                                          //         Duration(seconds: 1));
                                                          // widget
                                                          //     .wishlistcontroller
                                                          //     .removeWishlistData(widget
                                                          //         .wishlistcontroller
                                                          //         .filterwishlistdata[
                                                          //             index]
                                                          //         .productId);
                                                          Navigator.of(context)
                                                              .pop();
                                                          Get.snackbar(
                                                              'Success',
                                                              'Removed from wishlist successfully',
                                                              backgroundColor:
                                                                  Colors.white,
                                                              animationDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                          650));
                                                        },
                                                        title: Text(
                                                            'Remove from Wishlist'),
                                                        trailing:
                                                            Icon(Icons.delete),
                                                      )
                                                    ]),
                                                  ));
                                        },
                                        icon: Icon(Icons.more_vert_outlined,
                                            size: 1.7.h, color: Colors.white)),
                                  ))
                        ]),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                                // trailing: IconButton(
                                //     onPressed: () {},
                                //     icon: Icon(
                                //       Icons.favorite_border_outlined,
                                //       size: 3.0.h,
                                //     )),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          '${widget.wishlistcontroller!.wishlistlistdata[index].productBrand} ${widget.wishlistcontroller!.wishlistlistdata[index].productName}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    // Expanded(
                                    //     child: IconButton(
                                    //         onPressed: () {},
                                    //         icon: Icon(
                                    //           Icons.favorite_border_outlined,
                                    //           size: 3.0.h,
                                    //         )))
                                  ],
                                ),
                                isThreeLine: true,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${widget.wishlistcontroller!.wishlistlistdata[index].productBrand}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                    Text(
                                        '${widget.wishlistcontroller!.wishlistlistdata[index].productPrise} ${widget.wishlistcontroller!.wishlistlistdata[index].priseCurrency}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                    // Text('Delivery by 25 Sep',
                                    //     style:
                                    //         TextStyle(fontWeight: FontWeight.normal)),
                                  ],
                                )),
                          ),
                        )
                      ]),
                    ),
                  ),
                );
              }));
    }

    Widget customProductBox(
        String productType, String productTypeImage, index) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(productType,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black)),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            productTypeImage,
                          )),
                      borderRadius: BorderRadius.circular(15)),
                  // child: Image.network(
                  //     'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/amazon-fashion-1567536428.jpg?crop=1xw:1xh;center,top&resize=480:*'),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget _settingsCard(String value, IconData icon, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
            color: Colors.transparent,
            width: 50.0.w,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child:
                        Icon(icon, size: 25, color: hotPropertiesThemeColor)),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 16,
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )),
      );
    }

    Widget allTag() {
      return Obx(
        () => GestureDetector(
          onTap: () {
            if (widget.wishlistcontroller!.currentSelectedCategory.value !=
                'All') {
              widget.wishlistcontroller!.currentSelectedCategory.value = 'All';
            }
          },
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                shape: BoxShape.rectangle,
                border: new Border.all(
                  color: widget.wishlistcontroller!.currentSelectedCategory
                              .value !=
                          'All'
                      ? Colors.black
                      : Colors.red,
                  width: 1,
                ),
              ),
              child: Container(
                child: Text(
                  "All",
                  style: TextStyle(
                      color: widget.wishlistcontroller!.currentSelectedCategory
                                  .value !=
                              'All'
                          ? Colors.black
                          : Colors.red,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ),
      );
    }

    Widget _tagCard(int index, BuildContext context) {
      return GestureDetector(
        onTap: () async {
          if (widget.wishlistcontroller!.wishlistcategories[index] ==
              widget.wishlistcontroller!.currentSelectedCategory.value) {
            // widget.wishlistcontroller.currentSelectedCategory.value = '';
            return;
          } else {
            widget.wishlistcontroller!.currentSelectedCategory.value =
                widget.wishlistcontroller!.wishlistcategories[index];
            widget.wishlistcontroller!.filterWishlistByCat();
          }
        }

        //  =>
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             TagsFeedsView(tag: "${controller.tags[index]}")))

        ,
        child: Obx(
          () => Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                shape: BoxShape.rectangle,
                border: new Border.all(
                  color: widget.wishlistcontroller!.currentSelectedCategory
                              .value !=
                          widget.wishlistcontroller!.wishlistcategories[index]
                      ? Colors.black
                      : Colors.red,
                  width: 1,
                ),
              ),
              child: Container(
                child: Text(
                  "${widget.wishlistcontroller!.wishlistcategories[index]}",
                  style: TextStyle(
                      color: widget.wishlistcontroller!.currentSelectedCategory
                                  .value !=
                              widget
                                  .wishlistcontroller!.wishlistcategories[index]
                          ? Colors.black
                          : Colors.red,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ),
      );
    }

    Widget _tagsBuilder(BuildContext context) {
      return Obx(
        () => Container(
          height: 35,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  widget.wishlistcontroller!.wishlistcategories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return allTag();
                return _tagCard(index - 1, context);
              }),
        ),
      );
    }

    Widget _settingsRow() {
      return Container(
        height: 57,
        color: Colors.white,
        child: Row(
          children: [
            _settingsCard(
                AppLocalizations.of(
                  "FILTERS",
                ),
                CustomIcons.filter, () {
              Get.bottomSheet(FilterPropertyBottomSheet(index: -1, val: -1),
                  enableDrag: false,
                  isScrollControlled: true,
                  ignoreSafeArea: false,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))));
            }),
            _settingsCard(
                AppLocalizations.of(
                  "SORT BY",
                ),
                CustomIcons.sort, () {
              // Get.bottomSheet(
              //   SearchSortPropertyBottomSheet(),
              //   isScrollControlled: true,
              //   ignoreSafeArea: false,
              //   backgroundColor: Colors.white,
              // );
            }),
          ],
        ),
      );
    }

    return Scaffold(
        // appBar: AppBar(
        //     backgroundColor: HexColor('#232323'),
        //     // bottom: AppBar(actions: [
        //     //   ClipRRect(
        //     //       child: Container(
        //     //     child: Text('T-shirt'),
        //     //   ))
        //     // ]),
        //     title:
        //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //       Text('Wishlist', style: TextStyle(fontWeight: FontWeight.w300)),
        //       Text(
        //         '10 items',
        //         style: TextStyle(
        //           fontSize: 1.5.h,
        //         ),
        //       )
        //     ])),
        body: NestedScrollView(
      floatHeaderSlivers: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: 100.0.w,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() =>
                        widget.wishlistcontroller!.wishlistlistdata.length != 0
                            ? customGridView()
                            : Center(
                                child: loadingAnimation(),
                              ))
                  ],
                ),
              )),
        ),
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(57),
                child: Container(
                  padding: EdgeInsets.only(bottom: 15),
                  child: widget.action == shopaction.select
                      ? Container(
                          child: Text(
                              'Select your favorite items for the collection'),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                icon: Icon(Icons.add_box_outlined,
                                    color: Colors.black, size: 1.8.h),
                                onPressed: () {
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (context) =>
                                  //       BebuzeeShopCollections(),
                                  // ));
                                  // widget.shopcollectioncontroller
                                  //     .getUserCollection();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        BebuzeeShopCollections(
                                            wishlistController:
                                                widget.wishlistcontroller,
                                            shopCollectionController: widget
                                                .shopcollectioncontroller),
                                  ));
                                },
                                label: Text(
                                  'Collections',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 1.5.h),
                                )),
                            Expanded(child: _tagsBuilder(context))
                          ],
                        ),
                )),
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.black),
            backgroundColor: Colors.white,
            actions: [
              Container(
                margin: EdgeInsets.only(bottom: 0.5.h),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        fixedSize:
                            MaterialStateProperty.all(Size.fromHeight(1.0.h))),
                    onPressed: () {
                      print(
                          "selected items=${widget.wishlistcontroller!.productForCollection[0].wishlistId}");
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BebuzeeShopCreateCollection(
                            shopCollectionController:
                                widget.shopcollectioncontroller,
                            selectedProducts:
                                widget.wishlistcontroller!.productForCollection,
                            shopmanager: widget.shopmanagercontroller),
                      ));
                    },
                    child: widget.action == shopaction.select
                        ? Text(
                            'ADD',
                            style:
                                TextStyle(color: Colors.black, fontSize: 1.7.h),
                          )
                        : Container()),
              )
            ],
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Wishlist',
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black)),
              Obx(
                () => Text(
                  '${widget.wishlistcontroller!.wishlistlistdata.length} items',
                  style: TextStyle(
                    fontSize: 1.5.h,
                    color: Colors.black,
                  ),
                ),
              )
            ]),
          ),
        ];
      },
    )

        // SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Container(
        //         width: 100.0.w,
        //         child: Center(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [customGridView()],
        //           ),
        //         )

        //         ),
        //   ),
        // ),
        );
  }
}
