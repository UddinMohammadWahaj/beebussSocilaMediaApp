import 'package:bizbultest/models/BebuzeeShop/shopcountrymodel.dart';
import 'package:bizbultest/push/phone_call_page.dart';
import 'package:bizbultest/view/BebuzeeShop/shopbuzstoresearchdetail.dart';
import 'package:bizbultest/view/Chat/ChangePhone/change_number_from.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../../services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import '../../services/BebuzeeShop/shopbuzsearchbystorecontroller.dart';

class SearchByStoreView extends StatefulWidget {
  BebuzeeShopManagerController? controller;
  String? from;
  SearchByStoreView({Key? key, this.from}) : super(key: key);

  @override
  State<SearchByStoreView> createState() => _SearchByStoreViewState();
}

class _SearchByStoreViewState extends State<SearchByStoreView> {
  ShopBuzSearchByStoreController shopBuzSearchByStoreController =
      Get.put(ShopBuzSearchByStoreController());
  @override
  void dispose() {
    Get.delete<ShopBuzSearchByStoreController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget customStoreCard(index) {
      return Obx(
        () => GestureDetector(
          onTap: () {
            shopBuzSearchByStoreController.fetchMerchantStoreDetails(
                shopBuzSearchByStoreController
                    .merchantstorelist[index].storeId);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => ShopBuzStoreSearchDetail(
                      controller: shopBuzSearchByStoreController,
                    )));
          },
          child: Card(
            child: Column(
              children: [
                shopBuzSearchByStoreController.merchantstorelist.value.length !=
                        0
                    ? Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 20.0.h,
                            width: 90.0.w,
                            // color: Colors.grey,

                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                        '${shopBuzSearchByStoreController.merchantstorelist[index].storeIcon}'))),
                          ),
                        ),
                      )
                    : SkeletonAnimation(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 20.0.h,
                              width: 90.0.w,
                              color: Colors.grey,

                              // decoration: BoxDecoration(
                              //     image:
                              //         DecorationImage(image: CachedNetworkImageProvider(''))),
                            ),
                          ),
                        ),
                      ),
                shopBuzSearchByStoreController.merchantstorelist.length != 0
                    ? ListTile(
                        title: Text(
                            '${shopBuzSearchByStoreController.merchantstorelist[index].storeName}'),
                        subtitle: Text(
                            '${shopBuzSearchByStoreController.merchantstorelist[index].storeDetails}',
                            overflow: TextOverflow.ellipsis),
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
                      )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title:
            Text('Shoppingbuz stores', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: Container(
        color: Colors.white,
        width: 100.0.w,
        child: Obx(
          () => ListView.builder(
              itemCount:
                  shopBuzSearchByStoreController.merchantstorelist.length == 0
                      ? 5
                      : shopBuzSearchByStoreController.merchantstorelist.length,
              itemBuilder: (ctx, index) => customStoreCard(index)),
        ),
      ),
    );
  }
}
