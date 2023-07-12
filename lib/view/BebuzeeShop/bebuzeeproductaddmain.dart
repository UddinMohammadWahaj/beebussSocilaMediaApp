import 'package:bizbultest/services/BebuzeeShop/bebuzeemerchantproducteditcontroller.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeeproductedit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../services/BebuzeeShop/bebuzeeshopmerchantcontroller.dart';
import '../../services/BebuzeeShop/bebuzeeshopproductdetailpage.dart';
import 'bebuzeemerchantinnerviewtwo.dart';

class BebuzeeProductAddMain extends StatefulWidget {
  BebuzeeShopMerchantController? controller;
  BebuzeeProductAddMain({Key? key, this.controller}) : super(key: key);

  @override
  State<BebuzeeProductAddMain> createState() => _BebuzeeProductAddMainState();
}

class _BebuzeeProductAddMainState extends State<BebuzeeProductAddMain> {
  @override
  Widget build(BuildContext context) {
    Widget customGridView() {
      return Obx(
        () => GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 40.0.h,
                childAspectRatio: 1,
                mainAxisExtent: 40.0.h,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0),
            itemCount: widget.controller!.merchantproductList.length,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  print(
                      "product id=${widget.controller!.merchantproductList[index].productId}");
                  widget.controller!.getProductDetail(
                      productId: widget
                          .controller!.merchantproductList[index].productId);
                  widget.controller!.getColorList();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BebuzeeShopProductDetail(
                          controller: widget.controller)));
                },
                child: Container(
                  height: 60.0.h,
                  width: 30.0.w,
                  color: Colors.white,
                  child: Card(
                    child: Column(children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            height: 25.0.h,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      '${widget.controller!.merchantproductList[index].productImages![0]}',
                                    ))),
                          ),
                          // Positioned(
                          //   child: ClipRRect(
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(12)),
                          //       child: Container(
                          //         color: Colors.grey,
                          //         child: IconButton(
                          //             icon: Icon(Icons.more_vert_outlined),
                          //             onPressed: () {
                          //               showBarModalBottomSheet(
                          //                   context: context,
                          //                   builder: (ctx) {
                          //                     return Container(
                          //                       width: 100.0.w,
                          //                       height: 20.0.h,
                          //                       child: Column(children: [
                          //                         SizedBox(
                          //                           height: 3.0.h,
                          //                         ),
                          //                         ListTile(
                          //                           onTap: () {
                          //                             // controller.removestore(
                          //                             //     controller
                          //                             //         .merchantstorelist[
                          //                             //             index]
                          //                             //         .storeId,
                          //                             //     index);
                          //                             Navigator.of(context)
                          //                                 .pop();
                          //                           },
                          //                           leading: Icon(Icons.delete),
                          //                           title:
                          //                               Text('Delete Product'),
                          //                         ),
                          //                         ListTile(
                          //                           onTap: () {},
                          //                           leading: Icon(
                          //                               Icons.edit_attributes),
                          //                           title: Text('Edit Product'),
                          //                         )
                          //                       ]),
                          //                     );
                          //                   });
                          //             }),
                          //         // Row(
                          //         //   crossAxisAlignment:
                          //         //       CrossAxisAlignment.start,
                          //         //   children: [
                          //         //     Padding(
                          //         //       padding: const EdgeInsets.only(left: 5),
                          //         //       child: Text(
                          //         //         '4.3',
                          //         //         style: TextStyle(fontSize: 1.5.h),
                          //         //       ),
                          //         //     ),
                          //         //   ],
                          //         // ),
                          //       )),
                          // )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: ListTile(
                              trailing: FittedBox(
                                child: IconButton(
                                    icon: Icon(Icons.more_vert_outlined),
                                    onPressed: () {
                                      showBarModalBottomSheet(
                                          context: context,
                                          builder: (ctx) {
                                            return Container(
                                              width: 100.0.w,
                                              height: 20.0.h,
                                              child: Column(children: [
                                                SizedBox(
                                                  height: 3.0.h,
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    // controller.removestore(
                                                    //     controller
                                                    //         .merchantstorelist[
                                                    //             index]
                                                    //         .storeId,
                                                    //     index);
                                                    Navigator.of(context).pop();
                                                  },
                                                  leading: Icon(Icons.delete),
                                                  title: Text('Delete Product'),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    var editcontroller = Get.put(
                                                        BebuzeeMerchantProductEditController(
                                                            currentProductId: widget
                                                                .controller!
                                                                .merchantproductList[
                                                                    index]
                                                                .productId));
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                BebuzeeMerchantInnerViewSecondEdit(
                                                                  controller:
                                                                      editcontroller,
                                                                )));
                                                  },
                                                  leading: Icon(
                                                      Icons.edit_attributes),
                                                  title: Text('Edit Product'),
                                                )
                                              ]),
                                            );
                                          });
                                    }),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        '${widget.controller!.merchantproductList[index].productBrand} ${widget.controller!.merchantproductList[index].productName}',
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
                                      '${widget.controller!.merchantproductList[index].productName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                  Text(
                                      '${widget.controller!.merchantproductList[index].sellingPrise}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                  // Text('Delivery by 25 Sep',
                                  //     style: TextStyle(
                                  //         fontWeight: FontWeight.normal)),
                                ],
                              )),
                        ),
                      )
                    ]),
                  ),
                ),
              );
            }),
      );
    }

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text('Your Products', style: TextStyle(color: Colors.black)),
        ),
        body: widget.controller!.merchantproductList.length != 0 &&
                !widget.controller!.isproductlistloading.value
            ? customGridView()
            : widget.controller!.isproductlistloading.value
                ? Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : Center(
                    child: Column(children: [
                    Container(
                      width: 30.0.h,
                      height: 30.0.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  'https://png.pngtree.com/png-vector/20190628/ourlarge/pngtree-empty-box-icon-for-your-project-png-image_1521417.jpg'))),
                    ),
                    Text(
                      'No Products Found!',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'You can group in your Products in here and make collections based on your product category',
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
                              builder: (context) =>
                                  BebuzeeMerchantInnerViewSecond(
                                      controller: widget.controller)));
                        },
                        icon: Icon(Icons.add_box_outlined, color: Colors.white),
                        label: Text(
                          'Add your product',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        )),
                  ])),
        floatingActionButton: widget.controller!.merchantproductList.length == 0
            ? Container()
            : FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BebuzeeMerchantInnerViewSecond(
                          controller: widget.controller)));
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.black),
      ),
    );
  }
}
