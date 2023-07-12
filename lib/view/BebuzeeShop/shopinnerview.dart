import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import 'package:bizbultest/view/BebuzeeShop/shopbuzseachbystoreview.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../api/api.dart';
import '../../services/BebuzeeShop/bebuzeeshopmainproductdetailview.dart';
import '../../services/BebuzeeShop/bebuzeeshopproductdetailpage.dart';
import '../../utilities/custom_icons.dart';
import '../../utilities/loading_indicator.dart';

class BebuzeeShopInnerView extends StatefulWidget {
  BebuzeeShopManagerController? controller;

  BebuzeeShopInnerView({Key? key, this.controller}) : super(key: key);

  @override
  State<BebuzeeShopInnerView> createState() => _BebuzeeShopInnerViewState();
}

class _BebuzeeShopInnerViewState extends State<BebuzeeShopInnerView> {
  @override
  void dispose() {
    widget.controller!.productList.value = [];
    widget.controller!.productList.refresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget customProductCategoryTile(catName, catImage, index) {
      return ListTile(
        title: Text(catName),
        leading:
            CircleAvatar(backgroundImage: CachedNetworkImageProvider(catImage)),
        trailing: Icon(Icons.arrow_drop_down_circle),
      );
    }

    Widget testGridBox(int index) {
      return Expanded(
        child: GestureDetector(
          onTap: () async {
            if (widget.controller!.currentFilterCatId.value ==
                "${widget.controller!.listofproductcategory[index]['category_id'].toString()}") {
              widget.controller!.currentFilterCatId.value = "";
            } else if (widget.controller!.currentFilterCatId.value == "" ||
                widget.controller!.currentFilterCatId.value !=
                    "${widget.controller!.listofproductcategory[index]['category_id'].toString()}") {
              widget.controller!.currentFilterCatId.value =
                  "${widget.controller!.listofproductcategory[index]['category_id'].toString()}";
            } else {
              ;
            }
            widget.controller!.productSubCategoryList.value = [];
            widget.controller!.getProductSubCategoryList(
                catId:
                    '${widget.controller!.listofproductcategory[index]['category_id']}');
          },
          child: Container(
            height: 10.0.h,
            width: 90.0.w,
            child: customProductCategoryTile(
                widget.controller!.listofproductcategory[index]['category_name']
                    .toString(),
                widget
                    .controller!.listofproductcategory[index]['category_image']
                    .toString(),
                index),
          ),
        ),
      );
    }

    Widget testGrid(int index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // col or: Colors.pink,
          height: 10.0.h,
          width: 90.0.w,
          child: Column(
            children: [
              testGridBox(index),
              Container(
                color: Colors.grey.shade300,
                height: 0.1.h,
                width: 90.0.w,
              ),
              // index + 1 >= widget.controller.listofproductcategory.length
              //     ? Container()
              //     : testGridBox(index + 1),
              // Container(
              //   color: Colors.grey.shade300,
              //   height: 0.2.h,
              //   width: 90.0.w,
              // ),
            ],
          ),
        ),
      );
    }

    Widget customGridView() {
      return SmartRefresher(
          controller: widget.controller!.shopmainrefreshController,
          key: Key('shopbuzpage'),
          onRefresh: () {
            widget.controller!.shopmainrefreshController.refreshCompleted();
          },
          onLoading: () {
            print("on Loading calle");
            widget.controller!.shopmainrefreshController.loadComplete();
            var page = int.parse(widget
                    .controller!
                    .productList[widget.controller!.productList.length - 1]
                    .page!) +
                1;
            widget.controller!.loadProducts(page: page);
            print("loading products");
          },
          header: CustomHeader(
            builder: (context, mode) {
              return Container(
                child: Center(child: loadingAnimation()),
              );
            },
          ),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;

              if (mode == LoadStatus.idle) {
                body = Text("");
              } else if (mode == LoadStatus.loading) {
                print("loading gif");
                body = Container(
                  child: Center(child: loadingAnimation()),
                );
              } else if (mode == LoadStatus.failed) {
                body = Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(color: Colors.black, width: 0.7),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(CustomIcons.reload),
                    ));
              } else if (mode == LoadStatus.canLoading) {
                body = Text("");
              } else {
                body = Text("");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          enablePullUp: true,
          enablePullDown: true,
          primary: true,
          child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 40.0.h,
                  childAspectRatio: 1,
                  mainAxisExtent: 40.0.h,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0),
              itemCount: widget.controller!.productList.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    widget.controller!.getProductDetail(
                        productId:
                            widget.controller!.productList[index].productId);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BebuzeeShopMainProductDetail(
                            controller: widget.controller)));
                  },
                  child: Container(
                    height: 60.0.h,
                    width: 30.0.w,
                    color: Colors.white,
                    child: Card(
                      child: Column(children: [
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              height: 25.0.h,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        '${widget.controller!.productList[index].productImages![0]}',
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
                                          '${widget.controller!.productList[index].productName}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    Expanded(
                                        child: IconButton(
                                            onPressed: () {
                                              widget
                                                      .controller!
                                                      .productList[index]
                                                      .productWishlist!
                                                      .value =
                                                  !widget
                                                      .controller!
                                                      .productList[index]
                                                      .productWishlist!
                                                      .value;
                                              widget.controller!.addToWishList(
                                                  widget
                                                      .controller!
                                                      .productList[index]
                                                      .productId);
                                              Get.snackbar('Success',
                                                  'Item Added to Wishlist',
                                                  backgroundColor: Colors.white,
                                                  duration:
                                                      Duration(seconds: 1));
                                            },
                                            icon: Obx(
                                              () => Icon(
                                                widget
                                                        .controller!
                                                        .productList[index]
                                                        .productWishlist!
                                                        .value
                                                    ? Icons.favorite
                                                    : Icons
                                                        .favorite_border_outlined,
                                                size: 3.0.h,
                                                color: widget
                                                        .controller!
                                                        .productList[index]
                                                        .productWishlist!
                                                        .value
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            )))
                                  ],
                                ),
                                isThreeLine: true,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${widget.controller!.productList[index].productBrand}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
                                    Text(
                                        '${widget.controller!.productList[index].productPrise} ${widget.controller!.productList[index].priseCurrency}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal)),
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

    Widget subProductWidget(int index) {
      return widget.controller!.productSubCategoryList[index]
                  .subCategoryHeader !=
              "0"
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  '${widget.controller!.productSubCategoryList[index].subcategoryName}',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            )
          : ListTile(
              onTap: () {
                // print("shop index =$index");
                // widget.controller.searchSubProductId.value = widget.controller
                //     .productSubCategoryList[index].subcategoryId
                //     .toString();
                // print(
                //     "selected cat=${controller.productSubCategoryList[index].subcategoryName} id=${controller.productSubCategoryList[index].subcategoryId}");
                // shopmanager.getProductList();
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) =>
                //       BebuzeeShopInnerView(controller: shopmanager),
                // ));
              },
              tileColor: Colors.white,
              // leading: CircleAvatar(
              //   // backgroundImage: CachedNetworkImageProvider(
              //   //     controller.productSubCategoryList[index].s)
              //   backgroundColor: Colors.black,
              // ),
              // shape:
              //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text(
                  '${widget.controller!.productSubCategoryList[index].subcategoryName} '),
              trailing: Obx(
                () => Checkbox(
                  onChanged: (bool? value) {
                    widget.controller!.productSubCategoryList[index].isSelected!
                            .value =
                        !widget.controller!.productSubCategoryList[index]
                            .isSelected!.value;
                    if (widget.controller!.productSubCategoryList[index]
                        .isSelected!.value) {
                      widget.controller!.addIds(
                          widget.controller!.productSubCategoryList[index]);
                    } else {
                      widget.controller!.removeIds(
                          widget.controller!.productSubCategoryList[index]);
                    }
                  },
                  value: widget.controller!.productSubCategoryList[index]
                      .isSelected!.value,
                  fillColor: MaterialStateProperty.all(Colors.grey),
                ),
              ),
            );
    }

    Widget testGridExpanded(int indexx) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 0.5.h,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Container(
                color: Colors.white,
                width: 90.0.w,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => widget.controller!.productSubCategoryList.value
                                  .length ==
                              0
                          ? loadingAnimation()
                          : ListView.separated(
                              separatorBuilder: (context, index) => Container(
                                    height: 0.1.h,
                                    width: 100.0.w,
                                    color: Colors.black12,
                                  ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget
                                  .controller!.productSubCategoryList.length,
                              itemBuilder: (context, realindex) =>
                                  subProductWidget(realindex)

                              // ListTile(
                              //   tileColor: Colors.white,
                              //   leading: CircleAvatar(
                              //       backgroundImage: CachedNetworkImageProvider(
                              //           'https://st2.depositphotos.com/1607243/6054/i/950/depositphotos_60545151-stock-photo-collection-of-tablets-and-smartphones.jpg')),
                              //   // shape:
                              //   //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              //   title: Text('Smarthphone and Tablets '),
                              // ),
                              ),
                    )),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar:
          AppBar(title: Text('Shopper'), backgroundColor: HexColor('#232323')),
      body: Container(
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return Obx(
                () => Container(
                    height: 100.0.h - 100,
                    child: widget.controller!.productList.length == 0
                        ? Center(
                            child: loadingAnimation(),
                          )
                        : SmartRefresher(
                            controller:
                                widget.controller!.shopmainrefreshController,
                            key: Key('shopbuzpage'),
                            onRefresh: () {
                              widget.controller!.refreshProducts();
                            },
                            onLoading: () {
                              print("on Loading calle");

                              var page = int.parse(widget
                                      .controller!
                                      .productList[widget
                                              .controller!.productList.length -
                                          1]
                                      .page!) +
                                  1;
                              widget.controller!.loadProducts(page: page);

                              print("loading products");
                            },
                            header: CustomHeader(
                              builder: (context, mode) {
                                return Container(
                                  child: Center(child: loadingAnimation()),
                                );
                              },
                            ),
                            footer: CustomFooter(
                              builder:
                                  (BuildContext context, LoadStatus? mode) {
                                Widget body;

                                if (mode == LoadStatus.idle) {
                                  body = Text("");
                                } else if (mode == LoadStatus.loading) {
                                  print("loading gif");
                                  body = Container(
                                    child: Center(child: loadingAnimation()),
                                  );
                                } else if (mode == LoadStatus.failed) {
                                  body = Container(
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: new Border.all(
                                            color: Colors.black, width: 0.7),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Icon(CustomIcons.reload),
                                      ));
                                } else if (mode == LoadStatus.canLoading) {
                                  body = Text("");
                                } else {
                                  body = Text("");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            enablePullUp: true,
                            enablePullDown: true,
                            primary: true,
                            child: GridView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 40.0.h,
                                        childAspectRatio: 1,
                                        mainAxisExtent: 40.0.h,
                                        crossAxisSpacing: 0.0,
                                        mainAxisSpacing: 0.0),
                                itemCount:
                                    widget.controller!.productList.length,
                                itemBuilder: (ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      widget.controller!.getProductDetail(
                                          productId: widget.controller!
                                              .productList[index].productId);
                                      print(
                                          "product id=${widget.controller!.productList[index].productId}");
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BebuzeeShopMainProductDetail(
                                                      controller:
                                                          widget.controller)));
                                    },
                                    child: Container(
                                      height: 60.0.h,
                                      width: 30.0.w,
                                      color: Colors.white,
                                      child: Card(
                                        child: Column(children: [
                                          Stack(
                                            alignment: Alignment.bottomLeft,
                                            children: [
                                              Container(
                                                height: 25.0.h,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          '${widget.controller!.productList[index].productImages![0]}',
                                                        ))),
                                              ),
                                              Positioned(
                                                bottom: 10,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                    child: Container(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              '4.3',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      1.5.h),
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
                                                            '${widget.controller!.productList[index].productName}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis)),
                                                      ),
                                                      Expanded(
                                                          child: IconButton(
                                                              onPressed: () {
                                                                widget
                                                                        .controller!
                                                                        .productList[
                                                                            index]
                                                                        .productWishlist!
                                                                        .value =
                                                                    !widget
                                                                        .controller!
                                                                        .productList[
                                                                            index]
                                                                        .productWishlist!
                                                                        .value;
                                                                widget.controller!.addToWishList(widget
                                                                    .controller!
                                                                    .productList[
                                                                        index]
                                                                    .productId);
                                                                Get.snackbar(
                                                                    'Success',
                                                                    'Item Added to Wishlist',
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    duration: Duration(
                                                                        seconds:
                                                                            1));
                                                              },
                                                              icon: Obx(
                                                                () => Icon(
                                                                  widget
                                                                          .controller!
                                                                          .productList[
                                                                              index]
                                                                          .productWishlist!
                                                                          .value
                                                                      ? Icons
                                                                          .favorite
                                                                      : Icons
                                                                          .favorite_border_outlined,
                                                                  size: 3.0.h,
                                                                  color: widget
                                                                          .controller!
                                                                          .productList[
                                                                              index]
                                                                          .productWishlist!
                                                                          .value
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                              )))
                                                    ],
                                                  ),
                                                  isThreeLine: true,
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${widget.controller!.productList[index].productBrand}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                      Text(
                                                          '${widget.controller!.productList[index].productPrise} ${widget.controller!.productList[index].priseCurrency}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  )),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  );
                                }))),
              );
            }, childCount: 1))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 5.0.h,
        width: 100.0.h,
        child: Row(
          children: [
            // Text('Gender'),
            Expanded(
                child: GestureDetector(
              onTap: () {
                showBarModalBottomSheet(
                    context: context,
                    builder: (ctx) => Container(
                            child: Obx(
                          () => Column(
                            children: [
                              ListTile(
                                tileColor: Colors.grey.shade200,
                                title: Text('SORT-BY'),
                                trailing: Icon(Icons.close),
                                onTap: () {
                                  // widget.

                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                tileColor: widget.controller!.sortBy.value ==
                                        'New Arrivals'
                                    ? Colors.grey.shade200
                                    : null,
                                title: Text('New Arrivals'),
                                onTap: () async {
                                  widget.controller!
                                      .toggleSortBy('New Arrivals');
                                  widget.controller!.refreshProducts();
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                tileColor: widget.controller!.sortBy.value ==
                                        'Trending Now'
                                    ? Colors.grey.shade200
                                    : null,
                                title: Text('Trending Now'),
                                onTap: () {
                                  widget.controller!
                                      .toggleSortBy('Trending Now');
                                  widget.controller!.refreshProducts();
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                tileColor: widget.controller!.sortBy.value ==
                                        'Alphabetically, Z-A'
                                    ? Colors.grey.shade200
                                    : null,
                                title: Text('Alphabetically, Z-A'),
                                onTap: () {
                                  widget.controller!
                                      .toggleSortBy('Alphabetically, Z-A');
                                  widget.controller!.refreshProducts();
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                tileColor: widget.controller!.sortBy.value ==
                                        'Alphabetically, A-Z'
                                    ? Colors.grey.shade200
                                    : null,
                                title: Text('Alphabetically, A-Z'),
                                onTap: () {
                                  widget.controller!
                                      .toggleSortBy('Alphabetically, A-Z');
                                  widget.controller!.refreshProducts();
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                tileColor: widget.controller!.sortBy.value ==
                                        'Price-low to high'
                                    ? Colors.grey.shade200
                                    : null,
                                title: Text('Price-low to high'),
                                onTap: () {
                                  widget.controller!
                                      .toggleSortBy('Price-low to high');
                                  widget.controller!.refreshProducts();
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                title: Text('Price-high to low'),
                                tileColor: widget.controller!.sortBy.value ==
                                        'Price-high to low'
                                    ? Colors.grey.shade200
                                    : null,
                                onTap: () {
                                  widget.controller!
                                      .toggleSortBy('Price-high to low');
                                  widget.controller!.refreshProducts();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        )));
              },
              child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [Icon(CustomIcons.sort), Text('SORT BY')]),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () {
                showBarModalBottomSheet(
                    context: context,
                    expand: false,
                    builder: (ctx) {
                      return Scaffold(
                        appBar: AppBar(
                          elevation: 0.0,
                          backgroundColor: Colors.grey.shade200,
                          title: Text('Select Filters',
                              style: TextStyle(color: Colors.black)),
                          actions: [
                            Obx(
                              () => widget.controller!.productSubCategoryList
                                          .where((p0) =>
                                              p0.isSelected!.value == true)
                                          .toList()
                                          .length !=
                                      0
                                  ? TextButton(
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        print(
                                            "length of subid=${widget.controller!.searchSubCatIdsList.length}");
                                        String selectedListOfSubIds = widget
                                            .controller!
                                            .createCsvIds(widget.controller!
                                                .searchSubCatIdsList);
                                        ;
                                        widget.controller!
                                            .getProductListByFilterBySubCategory(
                                                selectedListOfSubIds);

                                        print(
                                            "length of subid=${widget.controller!.searchSubCatIdsList.length} after");
                                        Navigator.of(context).pop();
                                      })
                                  : Container(),
                            ),
                            Obx(() => widget.controller!.productSubCategoryList
                                        .where((p0) =>
                                            p0.isSelected!.value == true)
                                        .toList()
                                        .length !=
                                    0
                                ? TextButton(
                                    child: Text(
                                      'Clear',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      widget.controller!.searchSubCatIdsList
                                          .forEach((element) {
                                        element.isSelected!.value = false;
                                      });

                                      widget.controller!.searchSubCatIdsList
                                          .value = [];
                                    },
                                  )
                                : Container())
                          ],
                          leading: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.black,
                              )),
                        ),
                        body: Container(
                          width: 100.0.h,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Obx(
                                      () => ListTile(
                                        onTap: () async {
                                          widget.controller!
                                              .toggleFilterByCat();
                                        },
                                        title: Text('Filter by categories',
                                            style: TextStyle(
                                                fontSize: 2.0.h,
                                                fontWeight: FontWeight.bold)),
                                        trailing: widget.controller!
                                                .tappedFilterByCat.value
                                            ? Icon(
                                                Icons.keyboard_arrow_up_rounded)
                                            : Icon(Icons
                                                .arrow_drop_down_circle_outlined),
                                      ),
                                    )),
                                Obx(() => widget
                                        .controller!.tappedFilterByCat.value
                                    ? Column(children: [
                                        testGrid(0),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[0]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(1),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[1]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(2),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[2]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(3),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[3]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(4),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[4]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(5),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[5]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(6),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[6]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(7),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[7]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(8),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[8]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(9),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[9]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(10),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[10]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(11),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[11]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(12),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[12]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                        testGrid(13),
                                        (widget.controller!.currentFilterCatId
                                                    .value ==
                                                "${widget.controller!.listofproductcategory[13]['category_id']}")
                                            ? testGridExpanded(int.parse(widget
                                                .controller!
                                                .currentFilterCatId
                                                .value))
                                            : Container(),
                                      ])
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      )),
                                // Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: ListTile(
                                //       onTap: () {},
                                //       title: Text('Filter by colors',
                                //           style: TextStyle(
                                //               fontSize: 2.0.h,
                                //               fontWeight: FontWeight.bold)),
                                //       trailing: Icon(Icons
                                //           .arrow_drop_down_circle_outlined),
                                //     )),
                                // Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: ListTile(
                                //       onTap: () {
                                //         Navigator.of(context).push(
                                //             MaterialPageRoute(
                                //                 builder: (ctx) =>
                                //                     SearchByStoreView()));
                                //       },
                                //       title: Text('Filter by Stores',
                                //           style: TextStyle(
                                //               fontSize: 2.0.h,
                                //               fontWeight: FontWeight.bold)),
                                //       trailing: Icon(Icons
                                //           .arrow_drop_down_circle_outlined),
                                //     )),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [Icon(CustomIcons.filter), Text('FILTER')]),
            ))
          ],
        ),
      ),
    );
  }
}
