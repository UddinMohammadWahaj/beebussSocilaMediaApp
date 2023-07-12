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
import '../../services/BebuzeeShop/bebuzeeshopmerchantcontroller.dart';
import 'bebuzeeshopproductaddedsuccess.dart';

class BebuzeeMerchantInnerViewSecondStore extends StatefulWidget {
  BebuzeeShopMerchantController? controller;

  BebuzeeMerchantInnerViewSecondStore({Key? key, this.controller})
      : super(key: key);

  @override
  State<BebuzeeMerchantInnerViewSecondStore> createState() =>
      _BebuzeeMerchantInnerViewSecondStoreState();
}

class _BebuzeeMerchantInnerViewSecondStoreState
    extends State<BebuzeeMerchantInnerViewSecondStore> {
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
          'https://strategicsalesmarketingosmg.files.wordpress.com/2012/08/shutterstock_103086458.jpg',
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: ListTile(
            title: Text('Add More Details',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Enter your product details here'),
            leading: CircularPercentIndicator(
              radius: 12.0.w,
              lineWidth: 5.0,
              percent: 1.0,
              center: new Text("2/2"),
              progressColor: HexColor('#232323'),
            ),
          ),
        ),
        elevation: 0.0,
        title: Text('Add Store Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400)),
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
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
              title: Text('Add Store Icon',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                    'Add your store logo  that will be visible everywhere'),
              ),
            ),
            SizedBox(
              height: 2.0.h,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30.0.h,
                width: 90.0.w,
                child: PageView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) => Obx(() =>
                      widget.controller!.pickedPhotosFile.value == false ||
                              widget.controller!.photos.length == 0
                          ? GestureDetector(
                              onTap: () {
                                widget.controller!.pickPhotosFiles();
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
                          : Stack(alignment: Alignment.topRight, children: [
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: FileImage(
                                            widget.controller!.photos.first!))),
                                height: 30.0.h,
                                width: 90.0.w,
                              ),
                              IconButton(
                                onPressed: () {
                                  widget.controller!.pickedPhotosFile.value =
                                      false;
                                  widget.controller!.photos.clear();
                                  widget.controller!.photos.refresh();
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              )
                            ])),
                ),
              ),
            ),
            Obx(() => widget.controller!.pressedAddStore.value &&
                    widget.controller!.photos.length == 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Store icon is required',
                        style: TextStyle(color: Colors.red)),
                  )
                : Container()),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('Enter Store Url',
            //       style: TextStyle(fontWeight: FontWeight.bold)),
            // ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Enter Store Details',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('Select Product Color',
            //       style: TextStyle(
            //           fontWeight: FontWeight.w500, color: Colors.grey)),
            // ),
            // IconButton(
            //   onPressed: () {
            //     showDialog(
            //         context: Get.context,
            //         builder: (ctx) => AlertDialog(
            //               title: Text('Select Product Color'),
            //               content: MaterialColorPicker(
            //                   allowShades: true,
            //                   onColorChange: (Color color) {
            //                     // Handle color changes
            //                   },
            //                   selectedColor: Colors.red),
            //               actions: [
            //                 TextButton(
            //                     onPressed: () {
            //                       Get.close(1);
            //                     },
            //                     child: Text(
            //                       'Done',
            //                       style: TextStyle(color: HexColor('#232323')),
            //                     )),
            //                 TextButton(
            //                     onPressed: () {},
            //                     child: Text(
            //                       'Cancel',
            //                       style: TextStyle(color: HexColor('#232323')),
            //                     ))
            //               ],
            //             )
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
            //         );
            //   },
            //   icon: Icon(Icons.color_lens_sharp),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('Select Product Category',
            //       style: TextStyle(
            //           fontWeight: FontWeight.w500, color: Colors.grey)),
            // ),
            // Card(
            //   child: ListTile(
            //     contentPadding: EdgeInsets.all(8),
            //     leading: ClipRRect(
            //       borderRadius: BorderRadius.circular(12),
            //       child: Container(
            //         height: 20.0.h,
            //         width: 10.0.w,
            //         decoration: BoxDecoration(
            //             image: DecorationImage(
            //                 fit: BoxFit.cover,
            //                 image: CachedNetworkImageProvider(
            //                   'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
            //                 ))),
            //       ),
            //     ),
            //     title: Text('Mens Wear'),
            //     trailing: IconButton(
            //         onPressed: () {
            //           showBarModalBottomSheet(
            //               context: context,
            //               builder: (ctx) => Container(
            //                     width: 100.0.w,
            //                     child: testGridExpanded(0),
            //                   ));
            //         },
            //         icon: Icon(
            //           Icons.arrow_drop_down,
            //           color: Colors.grey,
            //         )),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Add Store Url',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
              child: TextField(
                controller: widget.controller!.currentStoreUrl,
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
                    hintText: 'Enter Shop Url',
                    focusColor: Colors.black),
              ),
            ),
            Obx(() => widget.controller!.pressedAddStore.value &&
                    widget.controller!.currentStoreUrl.text.length != 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Store Url is required',
                        style: TextStyle(color: Colors.red)),
                  )
                : Container()),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Add Store Address',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (val) {},
                onTap: () {},
                maxLines: 10,
                controller: widget.controller!.currentStoreAddress,
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(
                    "Enter Store Address",
                  ),
                  border: OutlineInputBorder(),

                  // 48 -> icon width
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Add Store Description',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (val) {},
                onTap: () {},
                maxLines: 10,
                controller: widget.controller!.currentStoreDescription,
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
          widget.controller!.pressedAddStore.value = true;
          if (widget.controller!.currentStoreUrl.text != '' &&
              widget.controller!.photos.length != 0) {
            widget.controller!.publishStore();

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BebuzeeShopProductAddSuccess(
                      controller: widget.controller!,
                    )));
          } else {
            print(
                "curreent store url=${widget.controller!.currentStoreUrl.text}");
          }
        },
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: Container(
              height: 5.0.h,
              color: HexColor('#232323'),
              width: 100.0.w,
              child: Center(
                child: Text('ADD STORE +',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2.0)),
              ),
            )),
      ),
    );
  }
}
