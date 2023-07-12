import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../services/BebuzeeShop/bebuzeeshopcollectioncontroller.dart';

class CollectionDetailView extends StatefulWidget {
  String? title;
  BebuzeeShopCollectionController? shopCollectionController;
  CollectionDetailView(
      {Key? key, this.title = '', this.shopCollectionController})
      : super(key: key);

  @override
  State<CollectionDetailView> createState() => _CollectionDetailViewState();
}

class _CollectionDetailViewState extends State<CollectionDetailView> {
  @override
  Widget build(BuildContext context) {
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
                widget.shopCollectionController!.listofcollections.length,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {},
                child: Card(
                  child: Column(children: [
                    Container(height: 20.0.h, child: buildImage(index)),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${widget.shopCollectionController!.currentcollectionlist[index].productName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 1.9.h,
                                          overflow: TextOverflow.ellipsis)),
                                ),
                                // IconButton(
                                //     icon: Icon(Icons.more_vert_outlined),
                                //     onPressed: () {
                                //       showBarModalBottomSheet(
                                //           context: context,
                                //           builder: (ctx) => Container(
                                //                 height: 20.0.h,
                                //                 child: Column(
                                //                   children: [
                                //                     // ListTile(
                                //                     //   onTap: () {
                                //                     //     print("error caught");
                                //                     //     Navigator.of(context)
                                //                     //         .pop();
                                //                     //     widget
                                //                     //         .shopCollectionController
                                //                     //         .deleteCollection(
                                //                     //             index - 1);
                                //                     //     Get.snackbar('Success',
                                //                     //         'Your collection was removed successfully',
                                //                     //         backgroundColor:
                                //                     //             Colors.white,
                                //                     //         duration: Duration(
                                //                     //             milliseconds:
                                //                     //                 500));
                                //                     //   },
                                //                     //   trailing:
                                //                     //       Icon(Icons.delete),
                                //                     //   title: Text(
                                //                     //       'Delete Collection'),
                                //                     // ),
                                //                     ListTile(
                                //                       trailing:
                                //                           Icon(Icons.share),
                                //                       title: Text(
                                //                           'Share Your Collection'),
                                //                     )
                                //                   ],
                                //                 ),
                                //               ));
                                //     })
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.shopCollectionController!.currentcollectionlist.value =
                    [];
              },
              icon: Icon(Icons.arrow_back)),
          title: Text('${widget.title}'),
        ),
        body: Obx(() =>
            widget.shopCollectionController!.currentcollectionlist.length == 0
                ? Center(
                    child: loadingAnimation(),
                  )
                : customGridView()));
  }
}
