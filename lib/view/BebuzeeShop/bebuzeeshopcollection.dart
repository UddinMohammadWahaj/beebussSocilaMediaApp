import 'dart:ui';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/shopbuzwishlistcontroller.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeeshopwishlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../services/BebuzeeShop/bebuzeeshopcollectioncontroller.dart';

class BebuzeeShopCollections extends StatefulWidget {
  BebuzeeShopCollectionController? shopCollectionController;
  ShopbuzWishlistController? wishlistController;
  BebuzeeShopCollections(
      {Key? key, this.shopCollectionController, this.wishlistController})
      : super(key: key);

  @override
  State<BebuzeeShopCollections> createState() => _BebuzeeShopCollectionsState();
}

class _BebuzeeShopCollectionsState extends State<BebuzeeShopCollections> {
  @override
  Widget build(BuildContext context) {
    getDatabase() async {
      var data = '';
      // var response=await ApiProvider().feedbackCheck()
    }

    buildImage(index) {
      return widget.shopCollectionController!.listofcollections[index]
                  .productImages!.length <=
              1
          ? Wrap(
              direction: Axis.vertical,
              children: [
                CachedNetworkImage(
                    imageUrl:
                        '${widget.shopCollectionController!.listofcollections[index].productImages![0]}'),
              ],
            )
          : widget.shopCollectionController!.listofcollections[index]
                      .productImages!.length <=
                  2
              ? Center(
                  child: FittedBox(
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        CachedNetworkImage(
                            imageUrl:
                                '${widget.shopCollectionController!.listofcollections[index].productImages![0]}'),
                        CachedNetworkImage(
                            imageUrl:
                                '${widget.shopCollectionController!.listofcollections[index].productImages![1]}'),
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    Wrap(
                      direction: Axis.vertical,
                      children: [
                        Container(
                          height: 10.0.h,
                          width: 10.0.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      '${widget.shopCollectionController!.listofcollections[index].productImages![0]}'))),
                        ),
                        Container(
                          height: 10.0.h,
                          width: 10.0.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      '${widget.shopCollectionController!.listofcollections[index].productImages![1]}'))),
                        ),
                        // CachedNetworkImage(
                        //     imageUrl:
                        //         '${widget.shopCollectionController.listofcollections[index].productImages[0]}'),
                        // CachedNetworkImage(
                        //     imageUrl:
                        //         '${widget.shopCollectionController.listofcollections[index].productImages[1]}'),
                      ],
                    ),
                    CachedNetworkImage(
                        imageUrl:
                            '${widget.shopCollectionController!.listofcollections[index].productImages![2]}'),
                  ],
                );
    }

    Widget customGridView() {
      return Obx(
        () => GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 40.0.h,
                childAspectRatio: 1,
                mainAxisExtent: 30.0.h,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0),
            itemCount:
                widget.shopCollectionController!.listofcollections.length + 1,
            itemBuilder: (ctx, index) {
              if (index == 0)
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BebuzeeShopWishlistView(
                              action: shopaction.select,
                              wishlistcontroller: widget.wishlistController!,
                              shopcollectioncontroller:
                                  widget.shopCollectionController!,
                            )));
                  },
                  child: Container(
                      height: 60.0.h,
                      width: 30.0.w,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 10.0.h),
                            Text('Add new collection')
                          ],
                        ),
                      )),
                );
              return GestureDetector(
                onTap: () {},
                child: Card(
                  child: Column(children: [
                    Container(height: 20.0.h, child: buildImage(index - 1)),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${widget.shopCollectionController!.listofcollections[index - 1].collectionName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 1.9.h,
                                          overflow: TextOverflow.ellipsis)),
                                ),
                                IconButton(
                                    icon: Icon(Icons.more_vert_outlined),
                                    onPressed: () {
                                      showBarModalBottomSheet(
                                          context: context,
                                          builder: (ctx) => Container(
                                                height: 20.0.h,
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () {
                                                        print("error caught");
                                                        Navigator.of(context)
                                                            .pop();
                                                        widget
                                                            .shopCollectionController!
                                                            .deleteCollection(
                                                                index - 1);
                                                        Get.snackbar('Success',
                                                            'Your collection was removed successfully',
                                                            backgroundColor:
                                                                Colors.white,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500));
                                                      },
                                                      trailing:
                                                          Icon(Icons.delete),
                                                      title: Text(
                                                          'Delete Collection'),
                                                    ),
                                                    ListTile(
                                                      trailing:
                                                          Icon(Icons.share),
                                                      title: Text(
                                                          'Share Your Collection'),
                                                    )
                                                  ],
                                                ),
                                              ));
                                    })
                              ],
                            ),
                            isThreeLine: true,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   '${widget.shopCollectionController.listofcollections[index - 1].totalWish} items',
                                // ),
                              ],
                            )),
                      ),
                    ),
                  ]),
                ),
              );
            }),
      );
    }

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            title: Text(
              'Collections',
              style: TextStyle(color: Colors.black),
            )),
        body: widget.shopCollectionController!.listofcollections.length != 0
            ? customGridView()
            : Container(
                height: 100.0.h,
                width: 100.0.h,
                child: Center(
                    child: Column(
                  children: [
                    Container(
                      width: 30.0.h,
                      height: 30.0.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  'https://png.pngtree.com/png-vector/20190628/ourlarge/pngtree-empty-box-icon-for-your-project-png-image_1521417.jpg'))),
                    ),
                    Text(
                      'No collections Found!',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You can group in items in here and make collections based on themes',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ),
                    ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(HexColor('#232323'))),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BebuzeeShopWishlistView(
                                    action: shopaction.select,
                                    wishlistcontroller:
                                        widget.wishlistController!,
                                    shopcollectioncontroller:
                                        widget.shopCollectionController!,
                                  )));
                        },
                        icon: Icon(Icons.add_box_outlined, color: Colors.white),
                        label: Text(
                          'Create Collection',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ))
                  ],
                )),
              ),
      ),
    );
  }
}

// class BebuzeeShopCollections extends GetView {
//   BebuzeeShopCollectionController shopCollectionController;
//   ShopbuzWishlistController wishlistController;
//   BebuzeeShopCollections(
//       {Key key, widget.shopCollectionController, widget.wishlistController})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//   }
// }
