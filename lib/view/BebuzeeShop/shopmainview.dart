import 'package:avatar_glow/avatar_glow.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopcollectioncontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmaincontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/shopbuzwishlistcontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/BebuzeeShop/BebuzeeShopMerchantView.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeeshopcollection.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeeshopsearch.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeeshopwishlistview.dart';
import 'package:bizbultest/view/BebuzeeShop/bulkuploadview.dart';
import 'package:bizbultest/view/BebuzeeShop/shopinnerview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Language/appLocalization.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;

import '../../services/BebuzeeShop/shopbuzsearchbystorecontroller.dart';
import '../../services/Properbuz/search_property_sort_widget.dart';
import '../../widgets/Properbuz/property/filter_bottom_sheet.dart';
import 'bebuzeeshopmerchantpremiumpage.dart';

class ShopMainView extends StatefulWidget {
  Function? setNavbar;
  ShopMainView({Key? key, this.setNavbar}) : super(key: key);

  @override
  State<ShopMainView> createState() => _ShopMainViewState();
}

class _ShopMainViewState extends State<ShopMainView> {
  bool isSelected = false;
  double confidence = 1.0;
  bool isListen = false;
  late speechToText.SpeechToText speech;
  String textString = "Press The Button";
  // subproducts=[{
  //  "Clothing":["Smart Phone","Tablets"]
  // }]
  var shopmanager = Get.put(BebuzeeShopManagerController());
  var controller = Get.put(BebuzeeShopMainController());
  var shopCollectionController = Get.put(BebuzeeShopCollectionController());
  var shopbuzWishlistController = Get.put(ShopbuzWishlistController());

  void listen() async {
    print("text string -${textString} list");

    try {
      if (!isListen) {
        bool avail = await speech.initialize();
        print("text string -${textString} avail $avail");

        if (avail) {
          // setState(() {
          //   isListen = true;
          //   print("text string -${textString}");
          // });
          controller.isListen.value = true;
          print("text string -${controller.textString}");
          speech.listen(
              listenMode: speechToText.ListenMode.search,
              onResult: (value) {
                // setState(() {
                //   textString = value.recognizedWords;
                //   print("text string -${textString}");
                //   if (value.hasConfidenceRating && value.confidence > 0) {
                //     confidence = value.confidence;
                //   }
                // });

                controller.textString.value = value.recognizedWords;
                print("text string -${controller.textString} aha ");

                if (value.hasConfidenceRating && value.confidence > 0) {
                  confidence = value.confidence;
                }
              });
        }
      } else {
        print("text string -${textString} fail");

        // setState(() {
        //   isListen = false;
        // });

        controller.isListen.value = false;
        controller.textString.value = 'Speak something..';
        speech.stop();
      }
    } catch (e) {
      print("text string -${textString} error =$e");
    }
  }

  var testproducts = [
    {
      "category_id": 4,
      "category_name": "Appliances",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/appliances.jpg"
    },
    {
      "category_id": 8,
      "category_name": "Baby",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/baby.jpg"
    },
    {
      "category_id": 11,
      "category_name": "Beauty",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/beauty.webp"
    },
    {
      "category_id": 3,
      "category_name": "Clothing",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/clothing.jpg"
    },
    {
      "category_id": 2,
      "category_name": "Electronics",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/electronics.jpg"
    },
    {
      "category_id": 5,
      "category_name": "Games",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/games.jpg"
    },
    {
      "category_id": 9,
      "category_name": "Garden",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/garden.jpg"
    },
    {
      "category_id": 1,
      "category_name": "Grocery",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/grocery.jpg"
    },
    {
      "category_id": 16,
      "category_name": "Industrial",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/industrial.jpg"
    },
    {
      "category_id": 17,
      "category_name": "Party Supplies",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/party_supplies.webp"
    },
    {
      "category_id": 15,
      "category_name": "Pets",
      "category_image":
          "https://images.news18.com/ibnlive/uploads/2022/04/pets-16496404503x2.jpg?im=Resize,width=360,aspect=fit,type=normal?im=Resize,width=320,aspect=fit,type=normal"
    },
    {
      "category_id": 13,
      "category_name": "Pharmacy",
      "category_image":
          "https://indoreinstitute.com/wp-content/uploads/2021/09/pharmaceutical-industry.jpg"
    },
    {
      "category_id": 14,
      "category_name": "Sports",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/sports.jpg"
    },
    {
      "category_id": 7,
      "category_name": "Supplies",
      "category_image":
          "https://properbuzcoin.com/upload/shopbuz/category/supplies.jpg"
    }
  ];
  var products = [
    {
      "name": "Clothing",
      "url":
          "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/amazon-fashion-1567536428.jpg?crop=1xw:1xh;center,top&resize=480:*",
      "category_id": 3,
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
  var testSubProduct = [];

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
      "name": ["Eyeliner and Mascara", "Lipstick and Nailpolish", "Skin Care"],
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
  String image = '';
  @override
  void initState() {
    super.initState();
    speech = speechToText.SpeechToText();
    image = CurrentUser().currentUser.image!;
  }

  // @override
  // void dispose() {
  //   widget.setNavbar(false);
  //   Get.delete<BebuzeeShopMainController>();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Widget _searchBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  BebuzeeShopSearch(shopManagerController: shopmanager),
            ));
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
                    Icon(Icons.search),
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

    Widget customProductBox(
        String productType, String productTypeImage, index) {
      return Card(
        elevation: 1.2.h,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
              color:
                  //  controller.currentCategory.value == '$index'
                  //     ? Colors.black.withOpacity(0.7)
                  //     :

                  Colors.white,
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
                      style: TextStyle(color: Colors.black)),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
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
      );
    }

    Widget testGridBox(int index) {
      return Expanded(
        child: GestureDetector(
          onTap: () async {
            print("clicked image=${testproducts[index]['category_image']}");
            if (controller.currentCategory.value ==
                "${testproducts[index]['category_id'].toString()}") {
              controller.currentCategory.value = "";
            } else if (controller.currentCategory.value == "" ||
                controller.currentCategory.value !=
                    "${testproducts[index]['category_id'].toString()}") {
              controller.currentCategory.value =
                  "${testproducts[index]['category_id'].toString()}";
            } else {
              ;
            }
            controller.productSubCategoryList.value = [];
            controller.getProductSubCategoryList(
                catId: '${testproducts[index]['category_id']}');
          },
          child: Container(
            height: 20.0.h,
            width: 35.0.w,
            child: customProductBox(
                testproducts[index]['category_name'].toString(),
                testproducts[index]['category_image'].toString(),
                index),
          ),
        ),
      );
    }

    Widget customProductList() {
      return ListView.builder(
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  'https://images.unsplash.com/photo-1573739022854-abceaeb585dc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGhvbmUlMjBhY2Nlc3Nvcmllc3xlbnwwfHwwfHw%3D&w=1000&q=80')),
          title: Text('abc'),
        ),
      );
    }

    Widget subProductWidget(int index, int count) {
      return ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BebuzeeShopInnerView(),
          ));
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
              Get.bottomSheet(
                SearchSortPropertyBottomSheet(),
                isScrollControlled: true,
                ignoreSafeArea: false,
                backgroundColor: Colors.white,
              );
            }),
          ],
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
                      () => controller.productSubCategoryList.value.length == 0
                          ? loadingAnimation()
                          : ListView.separated(
                              separatorBuilder: (context, index) => Container(
                                    height: 0.1.h,
                                    width: 100.0.w,
                                    color: Colors.black12,
                                  ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  controller.productSubCategoryList.length,
                              itemBuilder: (context, realindex) =>
                                  subProductWidget(realindex, controller.productSubCategoryList.length)

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
              index + 1 >= testproducts.length
                  ? Container()
                  : testGridBox(index + 1)
            ],
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        widget.setNavbar!(false);
        Get.delete<BebuzeeShopManagerController>();
        Get.delete<BebuzeeShopMainController>();
        Get.delete<ShopbuzWishlistController>();
        Get.delete<BebuzeeShopCollectionController>();
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          backgroundColor: HexColor('#232323'),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 27, 26, 26),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(image))),
                child: Container(),
              ),
              ListTile(
                // leading:
                //     Icon(Icons.favorite_border_outlined, color: Colors.white),
                title: Text('Welcome User,',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 3.0.h,
                        fontWeight: FontWeight.w300)),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.favorite_border_outlined, color: Colors.white),
                title: Text('Your Wishlist',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  shopbuzWishlistController.getWishlistData();
                  // Update the state of the app.
                  // ...
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BebuzeeShopWishlistView(
                        wishlistcontroller: shopbuzWishlistController,
                        shopcollectioncontroller: shopCollectionController,
                        shopmanagercontroller: shopmanager),
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.add_box_outlined, color: Colors.white),
                title: Text('Your Collections',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  shopCollectionController.getUserCollection();
                  // Update the state of the app.
                  // ...
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BebuzeeShopCollections(
                        wishlistController: shopbuzWishlistController,
                        shopCollectionController: shopCollectionController),
                  ));
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.people, color: Colors.white),
              //   title: Text('Switch Account',
              //       style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     // Update the state of the app.
              //     // ...
              //   },
              // ),
              CurrentUser().currentUser.memberType == 2
                  ? ListTile(
                      leading: Icon(Icons.person_pin, color: Colors.white),
                      title: Text('Merchant Account',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                        if (shopmanager.subscriptionType.value != '')
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => BebuzeeShopMerchantView()));
                        else
                          Get.snackbar(
                              'Error', 'Subscribe to create merchant account',
                              backgroundColor: Colors.white);
                      },
                    )
                  : Container(),
              CurrentUser().currentUser.memberType == 2
                  ? ListTile(
                      leading: Icon(Icons.upload, color: Colors.white),
                      title: Text('Bulk Upload',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => BulkploadView()));
                      },
                    )
                  : Container(),
              CurrentUser().currentUser.memberType == 2
                  ? ListTile(
                      leading: Icon(Icons.star, color: Colors.white),
                      title: Text('Merchant Premium Package',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BebuzeeShopMerchantPremium(
                                  shopmanagercontroller: shopmanager,
                                )));
                      },
                    )
                  : Container(),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title:
                    Text('Back to Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Get.delete<BebuzeeShopManagerController>();
                  Get.delete<BebuzeeShopMainController>();
                  Get.delete<ShopbuzWishlistController>();
                  Get.delete<BebuzeeShopCollectionController>();
                  widget.setNavbar!(false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  widget.setNavbar!(false);

                  // Get.delete<BebuzeeShopMainController>();
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        //  HexColor('#232323'),
        // HexColor('#abe3e2'),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Container(
              child: Stack(
            children: [
              CachedNetworkImage(
                fit: BoxFit.fitHeight,
                width: double.infinity,
                imageUrl: CurrentUser().currentUser.shoppingbuzLogo!,
                height: 5.0.h,
                alignment: Alignment.topLeft,
              ),
              Positioned(
                  top: 1.0.h,
                  left: 12.0.w,
                  child: Text(
                    'Shoppingbuz',
                    style: TextStyle(color: Colors.black, fontSize: 2.0.h),
                  ))
            ],
          )),
          actions: [],
          //  Container(
          //     color: Colors.transparent,
          //     alignment: Alignment.centerLeft,
          //     height: 50,
          //     child:
          //         // CurrentUser().currentUser.properbuzLogo != null &&
          //         //         CurrentUser().currentUser.properbuzLogo != ''
          //         //     ?

          //         CachedNetworkImage(
          //             fit: BoxFit.contain,
          //             width: double.infinity,
          //             imageUrl: CurrentUser().currentUser.shoppingbuzLogo)
          //     // :
          //     //  Image.asset(
          //     //     "assets/images/new_logo.png",
          //     //     fit: BoxFit.cover,
          //     //     width: double.infinity,
          //     //   ),
          //     )

          // Text('Shopping Buzz'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: 100.0.w,
              child: Row(
                children: [
                  Expanded(child: _searchBar()),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                      onPressed: () async {
                        controller.textString.value = 'Start Speaking...';
                        var status = await Permission.microphone.status;
                        if (status.isDenied) {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.microphone,
                          ].request();
                        }
                        print("mic permission status=${status}");
                        listen();
                        await showBarModalBottomSheet(
                            context: context,
                            bounce: true,
                            builder: (BuildContext ctx) {
                              return Container(
                                  height: 40.0.h,
                                  width: 100.0.w,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Obx(() => Container(
                                            alignment: Alignment.topLeft,
                                            width: 100.0.w,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  '${controller.textString.value}',
                                                  style: TextStyle(
                                                      fontSize: 3.0.h)),
                                            ),
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          shopmanager
                                                  .searchProductKeyword.value =
                                              controller.textString.value;
                                          controller.textString.value =
                                              'Start Speaking..';
                                          shopmanager.getProductList();
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                BebuzeeShopInnerView(
                                                    controller: shopmanager),
                                          ));
                                        },
                                        child: AvatarGlow(
                                          glowColor: Colors.blue,
                                          endRadius: 90.0,
                                          duration:
                                              Duration(milliseconds: 2000),
                                          repeat: true,
                                          showTwoGlows: true,
                                          repeatPauseDuration:
                                              Duration(milliseconds: 100),
                                          animate: true,
                                          child: Material(
                                            elevation: 8.0,
                                            shape: CircleBorder(),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                Icons.mic,
                                              ),
                                              radius: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            });
                      },
                      icon: Icon(Icons.mic_none_outlined,
                          size: 8.0.w, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 3.0.h,
            ),
            testGrid(0),
            Obx(
              () => (controller.currentCategory.value ==
                          "${testproducts[0]['category_id']}" ||
                      controller.currentCategory.value ==
                          "${testproducts[1]['category_id']}")
                  ? testGridExpanded(
                      int.parse(controller.currentCategory.value))
                  : Container(),
            ),

            testGrid(2),
            Obx(
              () => (controller.currentCategory.value ==
                          "${testproducts[2]['category_id']}" ||
                      controller.currentCategory.value ==
                          "${testproducts[3]['category_id']}")
                  ? testGridExpanded(
                      int.parse(controller.currentCategory.value))
                  : Container(),
            ),
            testGrid(4),
            Obx(
              () => (controller.currentCategory.value ==
                          "${testproducts[4]['category_id']}" ||
                      controller.currentCategory.value ==
                          "${testproducts[5]['category_id']}")
                  ? testGridExpanded(
                      int.parse(controller.currentCategory.value))
                  : Container(),
            ),
            testGrid(6),
            Obx(
              () => (controller.currentCategory.value ==
                          "${testproducts[6]['category_id']}" ||
                      controller.currentCategory.value ==
                          "${testproducts[7]['category_id']}")
                  ? testGridExpanded(
                      int.parse(controller.currentCategory.value))
                  : Container(),
            ),
            testGrid(8),
            Obx(
              () => (controller.currentCategory.value ==
                          "${testproducts[8]['category_id']}" ||
                      controller.currentCategory.value ==
                          "${testproducts[9]['category_id']}")
                  ? testGridExpanded(
                      int.parse(controller.currentCategory.value))
                  : Container(),
            ),
            testGrid(10),
            Obx(
              () => (controller.currentCategory.value ==
                          "${testproducts[10]['category_id']}" ||
                      controller.currentCategory.value ==
                          "${testproducts[11]['category_id']}")
                  ? testGridExpanded(
                      int.parse(controller.currentCategory.value))
                  : Container(),
            ),
            testGrid(12),
            Obx(
              () => (controller.currentCategory.value ==
                          "${testproducts[12]['category_id']}" ||
                      controller.currentCategory.value ==
                          "${testproducts[13]['category_id']}")
                  ? testGridExpanded(
                      int.parse(controller.currentCategory.value))
                  : Container(),
            ),
            //For testing custom grid
            // Container(height: 100.0.h, width: 90.0.w, child: testGrid()

            //     // customGrid(),
            //     )
            //For testing custom grid end
          ]),
        ),
      ),
    );
  }
}
