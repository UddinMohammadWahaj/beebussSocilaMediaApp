import 'package:bizbultest/services/BebuzeeShop/shopbuzsearchbystorecontroller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../../Language/appLocalization.dart';

class StoreSearchDetailInnerView extends StatefulWidget {
  ShopBuzSearchByStoreController? controller;
  String? productCat;
  StoreSearchDetailInnerView({Key? key, this.controller, this.productCat})
      : super(key: key);

  @override
  State<StoreSearchDetailInnerView> createState() =>
      _StoreSearchDetailInnerViewState();
}

class _StoreSearchDetailInnerViewState
    extends State<StoreSearchDetailInnerView> {
  @override
  void dispose() {
    widget.controller!.productList.value = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget customGridView() {
      return Obx(() => widget.controller!.productList.value.length == 0
          ? GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 40.0.h,
                  childAspectRatio: 1,
                  mainAxisExtent: 40.0.h,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0),
              itemCount: 6,
              itemBuilder: (ctx, index) => Container(
                    height: 60.0.h,
                    width: 30.0.w,
                    color: Colors.white,
                    child: Card(
                      child: Column(
                        children: [
                          SkeletonAnimation(
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                  height: 25.0.h,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                                color: Colors.white,
                                child: ListTile(
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
                                )),
                          )
                        ],
                      ),
                    ),
                  ))
          : GridView.builder(
              shrinkWrap: true,
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
                    // widget.controller.getProductDetail(
                    //     productId:
                    //         widget.controller.productList[index].productId);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => BebuzeeShopMainProductDetail(
                    //         controller: widget.controller)));
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
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.favorite_border_outlined,
                                              size: 3.0.h,
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

    Widget _searchBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) =>
            //       BebuzeeShopSearch(shopManagerController: shopmanager),
            // ));
          },
          child: Card(
            elevation: 0.5.h,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                // .withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.search, color: Colors.black),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of('Search'),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:
            Text('${widget.productCat}', style: TextStyle(color: Colors.black)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        bottom: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey.shade100,
          title: _searchBar(),
          actions: [Icon(Icons.search)],
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
              width: 100.0.w,
              child: Column(
                children: [
                  customGridView(),
                ],
              ))),
    );
  }
}
