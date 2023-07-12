import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmerchantcontroller.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeemerchantinnerview.dart';
import 'package:bizbultest/view/BebuzeeShop/shopbuzeditstoreview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import 'bebuzeeproductaddmain.dart';

class BebuzeeShopMerchantView extends StatefulWidget {
  const BebuzeeShopMerchantView({Key? key}) : super(key: key);

  @override
  State<BebuzeeShopMerchantView> createState() =>
      _BebuzeeShopMerchantViewState();
}

class _BebuzeeShopMerchantViewState extends State<BebuzeeShopMerchantView> {
  @override
  Widget build(BuildContext context) {
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
    var controller = Get.put(BebuzeeShopMerchantController());

    Widget customProductBox(
        String productType, String productTypeImage, index) {
      return Obx(
        () => Card(
          elevation: 1.2.h,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            decoration: BoxDecoration(
                color: controller.currentCategory.value == '$index'
                    ? Colors.black.withOpacity(0.7)
                    : Colors.white,
                borderRadius: BorderRadius.circular(15)),
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
                        style: TextStyle(
                            color: controller.currentCategory.value == '$index'
                                ? Colors.white
                                : Colors.black)),
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
          ),
        ),
      );
    }

    Widget testGridBox(int index) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            // if (controller.currentCategory.value == "$index") {
            //   controller.currentCategory.value = "";
            // } else if (controller.currentCategory.value == "" ||
            //     controller.currentCategory.value != "$index") {
            //   controller.currentCategory.value = "$index";
            // } else {
            //   ;
            // }
          },
          child: Container(
            height: 20.0.h,
            width: 35.0.w,
            child: customProductBox(products[index]['name'].toString(),
                products[index]['url'].toString(), index),
          ),
        ),
      );
    }

    Widget testGrid(int index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          // color: Colors.pink,
          height: 20.0.h,
          width: 90.0.w,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              testGridBox(index),
              SizedBox(
                width: 3.0.w,
              ),
              index + 1 >= products.length
                  ? Container()
                  : testGridBox(index + 1)
            ],
          ),
        ),
      );
    }

    Widget customGridView() {
      return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 40.0.h,
              childAspectRatio: 1,
              mainAxisExtent: 30.0.h,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0),
          itemCount: controller.merchantstorelist.length,
          itemBuilder: (ctx, index) {
            return Container(
              height: 60.0.h,
              width: 30.0.w,
              color: Colors.white,
              child: Card(
                child: Column(children: [
                  Stack(alignment: Alignment.topRight, children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        index == null
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          BebuzeeShopMerchantInnerView(
                                              storeid: controller
                                                  .merchantstorelist[index]
                                                  .storeId)));
                                },
                                child: Container(
                                  height: 25.0.h,
                                  child: Icon(Icons.add, size: 10.0.h),
                                ),
                              )
                            : Container(
                                height: 20.0.h,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          '${controller.merchantstorelist[index].storeIcon}',
                                        ))),
                              ),
                        // index == 0
                        //     ? SizedBox(
                        //         height: 0.0,
                        //         width: 0.0,
                        //       )
                        //     : Positioned(
                        //         bottom: 10,
                        //         child: ClipRRect(
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(12)),
                        //             child: Container(
                        //               color: Colors.grey.withOpacity(0.5),
                        //               child: Row(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Padding(
                        //                     padding:
                        //                         const EdgeInsets.only(left: 5),
                        //                     child: Text(
                        //                       '4.3',
                        //                       style: TextStyle(fontSize: 1.5.h),
                        //                     ),
                        //                   ),
                        //                   Icon(
                        //                     Icons.star,
                        //                     color: Colors.green,
                        //                     size: 2.0.h,
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //       )
                      ],
                    ),
                    SizedBox(
                      height: 0.0,
                      width: 0.0,
                    )
                  ]),
                  index == -1
                      ? Expanded(child: Text('Add New Store'))
                      : Expanded(
                          child: GestureDetector(
                          onTap: () {
                            controller.storeid =
                                controller.merchantstorelist[index].storeId;
                            controller.merchantproductList.value = [];
                            controller.fetchProductList();
                            print(
                                "store data id=${controller.merchantstorelist[index].storeId}");
                            print(
                                "store data id=${controller.merchantstorelist[index].storeId}");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BebuzeeProductAddMain(
                                      controller: controller,
                                    )));
                          },
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
                                          '${controller.merchantstorelist[index].storeName}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 1.5.h,
                                              overflow: TextOverflow.ellipsis)),
                                    ),
                                    IconButton(
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
                                                        controller.removestore(
                                                            controller
                                                                .merchantstorelist[
                                                                    index]
                                                                .storeId,
                                                            index);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      leading:
                                                          Icon(Icons.delete),
                                                      title:
                                                          Text('Delete Store'),
                                                    ),
                                                    ListTile(
                                                      onTap: () {
                                                        controller
                                                            .fetchMerchantStoreDetails(
                                                                controller
                                                                    .merchantstorelist[
                                                                        index]
                                                                    .storeId);
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BebuzeeShopMerchantEditView(
                                                                          storeid: controller
                                                                              .merchantstorelist[index]
                                                                              .storeId
                                                                              .toString(),
                                                                          controller:
                                                                              controller,
                                                                        )));
                                                      },
                                                      leading: Icon(Icons
                                                          .edit_attributes),
                                                      title: Text('Edit Store'),
                                                    )
                                                  ]),
                                                );
                                              });
                                        })
                                  ],
                                ),
                                isThreeLine: true,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '0 items',
                                    ),
                                  ],
                                )),
                          ),
                        ))
                ]),
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor('#232323'),
        title: Text('Merchant Dashboard',
            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
      ),
      body: Container(
        height: 100.0.h,
        width: 100.0.h,
        child: Obx(
          () => !controller.ismerchantstoreloading.value &&
                  controller.merchantstorelist.value.length != 0
              ? customGridView()
              : controller.ismerchantstoreloading.value
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : Center(
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
                                backgroundColor: MaterialStateProperty.all(
                                    HexColor('#232323'))),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      BebuzeeShopMerchantInnerView()));
                            },
                            icon: Icon(Icons.add_box_outlined,
                                color: Colors.white),
                            label: Text(
                              'Create Your Store',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ))
                      ],
                    )),
        ),
      ),
      floatingActionButton: Obx(() =>
          !controller.ismerchantstoreloading.value &&
                  controller.merchantstorelist.value.length != 0
              ? FloatingActionButton.extended(
                  icon: Icon(Icons.add),
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BebuzeeShopMerchantInnerView()));
                  },
                  label: Text('Add Store'),
                )
              : Container()),
    );
  }
}
