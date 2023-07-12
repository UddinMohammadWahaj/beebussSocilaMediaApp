import 'dart:io';

import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/drop_down_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../services/BebuzeeShop/bebuzeemerchantproducteditcontroller.dart';
import '../../services/BebuzeeShop/bebuzeeshopmerchantcontroller.dart';
import '../Buzzfeed/buzzfeedplayer.dart';
import 'bebuzeeshopproductaddedsuccess.dart';

class BebuzeeMerchantInnerViewSecondEdit extends StatefulWidget {
  BebuzeeMerchantProductEditController? controller;
  BebuzeeMerchantInnerViewSecondEdit({Key? key, this.controller})
      : super(key: key);

  @override
  State<BebuzeeMerchantInnerViewSecondEdit> createState() =>
      _BebuzeeMerchantInnerViewSecondEditState();
}

class _BebuzeeMerchantInnerViewSecondEditState
    extends State<BebuzeeMerchantInnerViewSecondEdit> {
  @override
  void dispose() {
    Get.delete<BebuzeeMerchantProductEditController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var subProducts = [
      {
        "images": [
          'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
          'https://rukminim1.flixcart.com/image/332/398/xif0q/dress/7/e/w/l-maxi-dress-black-maa-fab-original-imafyvtqfrdzytvm-bb.jpeg?q=50',
          'https://cdn.rt.emap.com/wp-content/uploads/sites/2/2018/01/23135253/scampanddude2-1-1024x959.jpg'
        ],
        "name": ["Mens Wear", "Womens Wear", 'Kids Wear'],
      },
      {
        "images": [
          'https://strat e gicsalesmarketingosmg.files.wordpress.com/2012/08/shutterstock_103086458.jpg',
          'https://www.techadvisor.com/wp-content/uploads/2022/06/how-to-connect-a-laptop-to-tv.jpg?quality=50&strip=all',
        ],
        "name": ["Smartphones and Tablets", "Tv and Laptops"],
      },
      // {
      //   "images": [
      //     'https://strategicsalesmarketingosmg.files.wordpress.com/2012/08/shutterstock_103086458.jpg',
      //     'https://www.techadvisor.com/wp-content/uploads/2022/06/how-to-connect-a-laptop-to-tv.jpg?quality=50&strip=all',
      //   ],
      //   "name": ["Smartphones and Tablets", "Tv and Laptops"],
      // },
      {
        "images": [
          'https://www.hudastore.pk/wp-content/uploads/2020/02/Huda-Beauty-Round-Golden-Shiny-Lid-EyeLiner-Mascara-Set-2.jpg',
          'https://i.ytimg.com/vi/gFQ6f9OYtqE/maxresdefault.jpg',
          "https://i0.wp.com/post.healthline.com/wp-content/uploads/2020/12/woman-holding-up-a-face-cream-1296x728-header.jpg?w=1155&h=1528"
        ],
        "name": [
          "Eyeliner and Mascara",
          "Lipstick and Nailpolish",
          "Skin Care"
        ],
      },
      {
        "images": [
          'https://cdn11.bigcommerce.com/s-pkla4xn3/images/stencil/1280x1280/products/20790/183139/Men-shoes-2018-fashion-new-arrivals-warm-winter-shoes-men-High-quality-frosted-suede-shoes-men__63928.1545975478.jpg?c=2?imbypass=on',
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/toni-and-philine-wearing-both-soho-studios-dresses-on-july-news-photo-1645742482.jpg?crop=0.607xw:1.00xh;0.125xw,0&resize=640:*',
          "https://media-cldnry.s-nbcnews.com/image/upload/t_fit-760w,f_auto,q_auto:best/newscms/2018_41/1376097/kids-shoes-stock-today-main-181011.jpg",
          'https://threadcurve.com/wp-content/uploads/2020/06/footwear-june272020.jpg'
        ],
        "name": ["Mens Wear", "Womens Wear", "Kids wear", 'Unisex wear'],
      },
      {
        "images": [
          'https://img1.exportersindia.com/product_images/bc-full/dir_109/3247300/sports-accessories-1482641.jpg',
          'https://m.media-amazon.com/images/I/71AyxR0yeeL._SL1500_.jpg',
        ],
        "name": [
          "Sports Accessories",
          "Gym Equipments",
        ]
      }
    ];
    Widget subProductWidget(int index, int count) {
      return ListTile(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => BebuzeeShopInnerView(),
          // ));
        },
        tileColor: Colors.white,
        leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                subProducts[index]['images']![count])),
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('${subProducts[index]['name']![count]} '),
      );
    }

    Widget testGridExpanded(int indexx) {
      return ListView.separated(
          separatorBuilder: (context, index) => Container(
                height: 0.1.h,
                width: 100.0.w,
                color: Colors.black12,
              ),
          shrinkWrap: true,
          itemCount: subProducts[indexx]['name']!.length,
          itemBuilder: (context, count) => subProductWidget(indexx, count));
    }

    return WillPopScope(
      onWillPop: () async {
        // Get.delete<BebuzeeMerchantProductEditController>();
        // Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: ListTile(
              title: Text('Edit Product Details',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Enter your product details here'),
              leading: CircularPercentIndicator(
                radius: 12.0.w,
                lineWidth: 5.0,
                percent: 1.0,
                center: new Text("1/1"),
                progressColor: HexColor('#232323'),
              ),
            ),
          ),
          elevation: 0.0,
          title: Text('Edit New Product',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () {
                Get.delete<BebuzeeMerchantProductEditController>();
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [
            // Obx(() => controller.currentCategory.value != ''
            //     ? Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           'NEXT',
            //           style: TextStyle(
            //             fontSize: 2.5.h,
            //             color: HexColor('#232323'),
            //           ),
            //         ),
            //       )
            //     : Text(''))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0.h,
              ),
              ListTile(
                title: Text('Add Product Images',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                      'Add upto 5 images, first image will be your product cover that will be visible everywhere'),
                ),
              ),
              SizedBox(
                height: 2.0.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Container(
                    height: 30.0.h,
                    width: 90.0.w,
                    child: PageView.builder(
                        itemCount: widget.controller!.photos.length + 1,
                        itemBuilder: (context, index) => Obx(() => widget
                                        .controller!.photos.length ==
                                    0 ||
                                index == widget.controller!.photos.value.length
                            ? GestureDetector(
                                onTap: () {
                                  widget.controller!.photos.clear();
                                  widget.controller!.photos.refresh();
                                  // widget.controller!.pickPhotosFiles();
                                  widget.controller!.photos.refresh();
                                },
                                child: Card(
                                  child: Container(
                                    height: 30.0.h,
                                    width: 90.0.w,
                                    child: Icon(Icons.add_a_photo_outlined),
                                    color: Colors.grey[200],
                                  ),
                                ),
                              )
                            : Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: CachedNetworkImageProvider(
                                                '${widget.controller!.photos[index]}')
                                            //  FileImage(File(
                                            //     '${widget.controller!.photos[index]}'))

                                            )),
                                    height: 30.0.h,
                                    width: 90.0.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            // widget.controller!.photos
                                            //     .removeAt(index);
                                            widget.controller!
                                                .pickPhotosFiles(index);
                                            // widget.controller!.deleteandUpdate(
                                            //     productId: widget.controller!
                                            //         .productDetail[0].productId,
                                            //     productimage: widget.controller!
                                            //         .phot.productImages[index]);
                                            // widget.controller!.photos.refresh();
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            widget.controller!.photos
                                                .removeAt(index);
                                            widget.controller!.deleteImage(
                                                productId: widget.controller!
                                                    .productDetail[0].productId,
                                                productimage: widget
                                                    .controller!
                                                    .productDetail[0]
                                                    .productImages![index]);
                                            widget.controller!.photos.refresh();
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
                                  )
                                ],
                              ))),
                  ),
                ),
              ),
              ListTile(
                title: Text('Add Product Video Url',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // subtitle: Padding(
                //   padding: const EdgeInsets.only(top: 5.0),
                //   child: Text('Add  Videos of your product'),
                // ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                child: TextField(
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.url,
                  controller: widget.controller!.productVideoUrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hoverColor: Colors.black,
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hintText: 'Enter Product Video Url',
                      focusColor: Colors.black),
                ),
              ),
              SizedBox(
                height: 2.0.h,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Obx(
              //     () => Container(
              //       height: 30.0.h,
              //       width: 90.0.w,
              //       child: PageView.builder(
              //           itemCount: widget.controller!.videos.length + 1,
              //           itemBuilder: (context, index) => Obx(() => widget
              //                           .controller.videos.length ==
              //                       0 ||
              //                   index == widget.controller!.videos.value.length
              //               ? GestureDetector(
              //                   onTap: () {
              //                     widget.controller!.videos.clear();
              //                     widget.controller!.videos.refresh();
              //                     widget.controller!.pickVideoFiles();
              //                     widget.controller!.videos.refresh();
              //                   },
              //                   child: Card(
              //                     child: Container(
              //                       height: 30.0.h,
              //                       width: 90.0.w,
              //                       child: Icon(Icons.video_collection_outlined),
              //                       color: Colors.grey[200],
              //                     ),
              //                   ),
              //                 )
              //               : Stack(
              //                   alignment: Alignment.topRight,
              //                   children: [
              //                     Container(
              //                       child: SamplePlayer(
              //                         url: widget.controller!.videos.first,
              //                       ),
              //                       height: 30.0.h,
              //                       width: 90.0.w,
              //                     ),
              //                     IconButton(
              //                         onPressed: () {
              //                           widget.controller!.videos.removeAt(index);
              //                           widget.controller!.videos.refresh();
              //                         },
              //                         icon: Icon(
              //                           Icons.delete,
              //                           color: Colors.red,
              //                         ))
              //                   ],
              //                 ))),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Enter Product Details',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text('Select Product Currency',
              //       style: TextStyle(
              //           fontWeight: FontWeight.w500, color: Colors.grey)),
              // ),
              // Card(
              //   child: ListTile(
              //     contentPadding: EdgeInsets.all(8),
              //     leading: CircleAvatar(
              //       backgroundColor: Colors.black12,
              //       child: Obx(() => Text(
              //             '${widget.controller!.currentCurrencyCode.value}',
              //             style: TextStyle(
              //               color: Colors.black,
              //             ),
              //           )),
              //     ),
              //     // ClipRRect(
              //     //   borderRadius: BorderRadius.circular(12),
              //     //   child: Container(
              //     //     height: 20.0.h,
              //     //     width: 10.0.w,
              //     //     decoration: BoxDecoration(
              //     //         image: DecorationImage(
              //     //             fit: BoxFit.cover,
              //     //             image: CachedNetworkImageProvider(
              //     //               'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
              //     //             ))),
              //     //   ),
              //     // ),
              //     title: Obx(() => Text(
              //         '${widget.controller!.currentCurrency.value == '' ? "Select a curreny" : widget.controller!.currentCurrency.value}')),
              //     trailing: IconButton(
              //         onPressed: () async {
              //           widget.controller!.getCurrencyList();
              //           showBarModalBottomSheet(
              //               context: context,
              //               builder: (ctx) => Container(
              //                   width: 100.0.w,
              //                   child: Obx(
              //                     () => widget.controller!.currencyList.length == 0
              //                         ? Center(
              //                             child: loadingAnimation(),
              //                           )
              //                         : ListView.separated(
              //                             itemBuilder: (context, index) =>
              //                                 ListTile(
              //                                   onTap: () {
              //                                     widget
              //                                             .controller
              //                                             .currentCurrencyCode
              //                                             .value =
              //                                         widget
              //                                             .controller
              //                                             .currencyList[index]
              //                                             .code;
              //                                     widget.controller!
              //                                             .currentCurrency.value =
              //                                         widget
              //                                             .controller
              //                                             .currencyList[index]
              //                                             .currencyName;
              //                                     Navigator.of(context).pop();
              //                                   },
              //                                   leading: CircleAvatar(
              //                                       child: Text(widget
              //                                           .controller
              //                                           .currencyList[index]
              //                                           .symbol)),
              //                                   title: Text(
              //                                       '${widget.controller!.currencyList[index].currencyName}'),
              //                                 ),
              //                             separatorBuilder: (ctx, index) =>
              //                                 Container(
              //                                   color: Colors.grey.shade400,
              //                                   height: 0.1.h,
              //                                   width: 100.0.w,
              //                                 ),
              //                             itemCount: widget
              //                                 .controller.currencyList.length),
              //                   )));
              //         },
              //         icon: Icon(
              //           Icons.arrow_drop_down,
              //           color: Colors.grey,
              //         )),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add Product Price',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: widget.controller!.productPrice,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hoverColor: Colors.black,
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hintText: 'Enter Product Price',
                      focusColor: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add Product Selling Price',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: widget.controller!.productSellingPrice,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hoverColor: Colors.black,
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hintText: 'Enter Product Selling Price',
                      focusColor: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Select Product Color',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              // Card(
              //   child: ListTile(
              //     contentPadding: EdgeInsets.all(8),
              //     title: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text('Select Color'),
              //     ),
              //     trailing: IconButton(
              //         onPressed: () {
              //           print(
              //               "current product id=${widget.controller!.currentProductCategoryId}");
              //           // widget.controller!.getProductSubCategoryList(
              //           //     catId: widget.controller!.currentProductCategoryId);
              //           showBarModalBottomSheet(
              //               context: context,
              //               builder: (ctx) => Container(
              //                   width: 100.0.w,
              //                   child: Obx(
              //                     () => widget.controller!.colorlist.length == 0
              //                         ? Center(
              //                             child: loadingAnimation(),
              //                           )
              //                         : ListView.separated(
              //                             itemBuilder: (context, index) =>
              //                                 ListTile(
              //                                   leading: CircleAvatar(
              //                                       backgroundColor: HexColor(
              //                                           '#${widget.controller!.colorlist[index].hasCode.toLowerCase()}')),
              //                                   onTap: () {
              //                                     // widget.controller!.selectColor(
              //                                     //     widget.controller!
              //                                     //         .colorlist[index]);
              //                                     Navigator.of(context).pop();
              //                                   },
              //                                   // leading: CircleAvatar(
              //                                   //   backgroundImage:
              //                                   //       CachedNetworkImageProvider(
              //                                   //     'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
              //                                   //   ),
              //                                   // ),
              //                                   title: Text(
              //                                       '${widget.controller!.colorlist[index].colorName}'),
              //                                 ),
              //                             separatorBuilder: (ctx, index) =>
              //                                 Container(
              //                                   color: Colors.grey.shade400,
              //                                   height: 0.1.h,
              //                                   width: 100.0.w,
              //                                 ),
              //                             itemCount:
              //                                 widget.controller!.colorlist.length),
              //                   )));
              //         },
              //         icon: Icon(
              //           Icons.arrow_drop_down,
              //           color: Colors.grey,
              //         )),
              //   ),
              // ),
              Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Select Color'),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        print(
                            "current product id=${widget.controller!.currentProductCategoryId}");
                        // widget.controller!.getProductSubCategoryList(
                        //     catId: widget.controller!.currentProductCategoryId);
                        showBarModalBottomSheet(
                            context: context,
                            builder: (ctx) => Container(
                                width: 100.0.w,
                                child: Obx(
                                  () => widget.controller!.colorlist.length == 0
                                      ? Center(
                                          child: loadingAnimation(),
                                        )
                                      : ListView.separated(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                                leading: CircleAvatar(
                                                    backgroundColor: HexColor(
                                                        '#${widget.controller!.colorlist[index].hasCode!.toLowerCase()}')),
                                                onTap: () {
                                                  widget.controller!
                                                      .selectColor(widget
                                                          .controller!
                                                          .colorlist[index]);
                                                  Navigator.of(context).pop();
                                                },
                                                // leading: CircleAvatar(
                                                //   backgroundImage:
                                                //       CachedNetworkImageProvider(
                                                //     'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
                                                //   ),
                                                // ),
                                                title: Text(
                                                    '${widget.controller!.colorlist[index].colorName}'),
                                              ),
                                          separatorBuilder: (ctx, index) =>
                                              Container(
                                                color: Colors.grey.shade400,
                                                height: 0.1.h,
                                                width: 100.0.w,
                                              ),
                                          itemCount: widget
                                              .controller!.colorlist.length),
                                )));
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      )),
                ),
              ),
              Obx(() => widget.controller!.selectedColors.length == 0
                  ? Container()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      addAutomaticKeepAlives: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          childAspectRatio: 2,
                          mainAxisSpacing: 3),
                      itemCount: widget.controller!.selectedColors.length,
                      itemBuilder: (ctx, index) => Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 3.0.w,
                            backgroundColor: HexColor(
                                '#${widget.controller!.selectedColors[index].hasCode!.toLowerCase()}'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Text(
                                    '${widget.controller!.selectedColors[index].colorName}'),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.black,
                                  onPressed: () {
                                    widget.controller!.unselectColor(index);
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      ]),
                    )),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: Get.context!,
                      builder: (ctx) => AlertDialog(
                            title: Text('Select Product Color'),
                            content: MaterialColorPicker(
                                allowShades: true,
                                onColorChange: (Color color) {
                                  // Handle color changes
                                },
                                selectedColor: Colors.red),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.close(1);
                                  },
                                  child: Text(
                                    'Done',
                                    style:
                                        TextStyle(color: HexColor('#232323')),
                                  )),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Cancel',
                                    style:
                                        TextStyle(color: HexColor('#232323')),
                                  ))
                            ],
                          )
                      //  Center(
                      //       child: Container(
                      //         height: 30.0.h,
                      //         color: Colors.white,
                      //         width: 70.0.w,
                      //         child: MaterialColorPicker(
                      //             allowShades: false,
                      //             onColorChange: (Color color) {
                      //               // Handle color changes
                      //             },
                      //             selectedColor: Colors.red),
                      //       ),
                      );
                },
                icon: Icon(Icons.color_lens_sharp),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Select Product Category',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 20.0.h,
                      width: 10.0.w,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
                              ))),
                    ),
                  ),
                  title: Obx(() => Text(
                      '${widget.controller!.currentProductCategory.value}')),
                  trailing: IconButton(
                      onPressed: () {
                        widget.controller!.getProductCategoryList();
                        showBarModalBottomSheet(
                            context: context,
                            builder: (ctx) => Container(
                                width: 100.0.w,
                                child: Obx(
                                  () => widget.controller!.productCategorylist
                                              .length ==
                                          0
                                      ? Center(
                                          child: loadingAnimation(),
                                        )
                                      : ListView.separated(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                                onTap: () {
                                                  widget
                                                          .controller!
                                                          .currentProductCategory
                                                          .value =
                                                      widget
                                                          .controller!
                                                          .productCategorylist[
                                                              index]
                                                          .categoryName
                                                          .toString();
                                                  widget
                                                          .controller!
                                                          .currentProductCategoryId
                                                          .value =
                                                      widget
                                                          .controller!
                                                          .productCategorylist[
                                                              index]
                                                          .categoryId
                                                          .toString();
                                                  widget.controller!
                                                      .productSubCategoryList
                                                      .clear();
                                                  widget.controller!
                                                      .productSubCategoryList
                                                      .refresh();
                                                  Navigator.of(context).pop();
                                                },
                                                leading: CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
                                                  ),
                                                ),
                                                title: Text(
                                                    '${widget.controller!.productCategorylist[index].categoryName}'),
                                              ),
                                          separatorBuilder: (ctx, index) =>
                                              Container(
                                                color: Colors.grey.shade400,
                                                height: 0.1.h,
                                                width: 100.0.w,
                                              ),
                                          itemCount: widget.controller!
                                              .productCategorylist.length),
                                )));
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Select Product Sub Category',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 20.0.h,
                      width: 10.0.w,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
                              ))),
                    ),
                  ),
                  title: Obx(() => Text(
                      '${widget.controller!.currentProductSubCategory.value}')),
                  trailing: IconButton(
                      onPressed: () {
                        print(
                            "current product id=${widget.controller!.currentProductCategoryId}");
                        widget.controller!.getProductSubCategoryList(
                            catId: widget.controller!.currentProductCategoryId);
                        showBarModalBottomSheet(
                            context: context,
                            builder: (ctx) => Container(
                                width: 100.0.w,
                                child: Obx(
                                  () => widget.controller!
                                              .productSubCategoryList.length ==
                                          0
                                      ? Center(
                                          child: loadingAnimation(),
                                        )
                                      : ListView.separated(
                                          itemBuilder: (context, index) => widget
                                                      .controller!
                                                      .productSubCategoryList[
                                                          index]
                                                      .subCategoryHeader !=
                                                  "0"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      '${widget.controller!.productSubCategoryList[index].subcategoryName}',
                                                      style: TextStyle(
                                                          color: Colors.pink,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )
                                              : ListTile(
                                                  onTap: () {
                                                    widget
                                                            .controller!
                                                            .currentProductSubCategoryId
                                                            .value =
                                                        widget
                                                            .controller!
                                                            .productSubCategoryList[
                                                                index]
                                                            .subcategoryId
                                                            .toString();
                                                    widget
                                                            .controller!
                                                            .currentProductSubCategory
                                                            .value =
                                                        widget
                                                            .controller!
                                                            .productSubCategoryList[
                                                                index]
                                                            .subcategoryName!;

                                                    Navigator.of(context).pop();
                                                  },
                                                  leading: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                      'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
                                                    ),
                                                  ),
                                                  title: Text(
                                                      '${widget.controller!.productSubCategoryList[index].subcategoryName}'),
                                                ),
                                          separatorBuilder: (ctx, index) =>
                                              Container(
                                                color: Colors.grey.shade400,
                                                height: 0.1.h,
                                                width: 100.0.w,
                                              ),
                                          itemCount: widget.controller!
                                              .productSubCategoryList.length),
                                )));
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add Product Name',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                child: TextField(
                  controller: widget.controller!.productname,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hoverColor: Colors.black,
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hintText: 'Enter Product Name',
                      focusColor: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add Product Url',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                child: TextField(
                  controller: widget.controller!.currentProductUrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hoverColor: Colors.black,
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hintText: 'Enter Product Url',
                      focusColor: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add Product Brand',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                child: TextField(
                  controller: widget.controller!.productBrand,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      disabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hoverColor: Colors.black,
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      hintText: 'Enter Product Brand',
                      focusColor: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Enter Product Description',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (val) {},
                  onTap: () {},
                  maxLines: 10,
                  controller: widget.controller!.productDescription,
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      "Description",
                    ),
                    border: OutlineInputBorder(),

                    // 48 -> icon width
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => BebuzeeShopProductAddSuccess(
            //           controller: widget.controller!,
            //           from: 'PRODUCTADD',
            //         )));
            Get.snackbar('Success', 'Product Update Success');
            widget.controller!.updateProduct();
            Navigator.of(context).pop();
          },
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Container(
                height: 5.0.h,
                color: HexColor('#232323'),
                width: 100.0.w,
                child: Center(
                  child: Text('UPDATE PRODUCT',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 2.0)),
                ),
              )),
        ),
      ),
    );
  }
}
