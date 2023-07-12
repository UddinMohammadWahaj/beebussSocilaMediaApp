import 'package:bizbultest/models/BebuzeeShop/merchantstoredetailsmodel.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeemerchantinnerviewstore.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeemerchantinnerviewtwo.dart';
import 'package:bizbultest/view/BebuzeeShop/shopbuzsecondstoreedit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../models/BebuzeeShop/shopcountrymodel.dart';
import '../../services/BebuzeeShop/bebuzeeshopmerchantcontroller.dart';
import '../../services/current_user.dart';

class BebuzeeShopMerchantEditView extends StatefulWidget {
  var storeid;
  BebuzeeShopMerchantController? controller;
  BebuzeeShopMerchantEditView({Key? key, this.storeid, this.controller})
      : super(key: key);

  @override
  State<BebuzeeShopMerchantEditView> createState() =>
      _BebuzeeShopMerchantEditViewState();
}

class _BebuzeeShopMerchantEditViewState
    extends State<BebuzeeShopMerchantEditView> {
  @override
  void dispose() {
    widget.controller!.refreshMerchantStoreData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var controller =
    //     Get.put(BebuzeeShopMerchantController(storeid: widget.storeid));
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

    Widget _countryTile(
      String title,
      String flag,
      TextStyle stylee,
    ) {
      return ListTile(
        // selected: true,
        title: Text(
          title,
          style: stylee,
          // TextStyle(
          // color: title == countryString ? Colors.green : Colors.black)
          // _dropdowTextStyle(16, FontWeight.w500),
        ),
        trailing: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: Colors.black,
                width: 3,
              ),
            ),
            child: CircleAvatar(
                radius: 20,
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 16),
                ))),
      )

          // index == lastIndex ? Container() : _divider()
          ;
    }

    Widget _divider() {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            thickness: 0.1,
            color: Colors.grey.shade100,
          ));
    }

    TextStyle _commonStyle(double size, FontWeight weight) {
      return GoogleFonts.heebo(
          fontSize: size, fontWeight: weight, color: Colors.white);
    }

    Widget dropDown9(BuildContext context) {
      return Container(
          alignment: Alignment.center,
          width: 88.w,
          // height: 20.h,
          decoration: new BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // shape: BoxShape.rectangle,
          ),
          child: Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                  decoration: new BoxDecoration(
                    // color: _cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    // shape: BoxShape.rectangle,
                  ),
                  alignment: Alignment.center,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButton<ShopSettingsModelCountry>(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    menuMaxHeight: 75.h,
                    dropdownColor: Colors.white,
                    itemHeight: 75,
                    alignment: AlignmentDirectional.center,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                    underline: Container(),
                    isExpanded: true,
                    onTap: () {
                      // setState(() {
                      //   blur = true;
                      // });

                      widget.controller!.getCountry();
                      showBarModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return Container(
                              height: 50.0.h,
                              width: 100.0.w,
                              color: Colors.white,
                            );
                          });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down_sharp,
                      size: 25,
                      color: Colors.white,
                    ),
                    iconSize: 20,
                    items: (widget.controller!.countryList.value)
                        .map<DropdownMenuItem<ShopSettingsModelCountry>>(
                            (ShopSettingsModelCountry value) {
                      return DropdownMenuItem<ShopSettingsModelCountry>(
                          value: value,
                          // child: Container(

                          child: WillPopScope(
                            onWillPop: () async {
                              // setState(() {
                              //   blur = false;
                              // });
                              return true;
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _countryTile(
                                      value.countryName!,
                                      value.flagIcon!,
                                      _commonStyle(16, FontWeight.w500)),
                                  _divider(),
                                ]),
                          ));
                    }).toList(),
                    onChanged: (val) {
                      // setState(() async {
                      //   countryString = val.name ?? countryString;
                      //   flag = val.flag ?? flag;
                      //   blur = false;
                      //   _scaffoldKey.currentState.showSnackBar(blackSnackBar(
                      //       AppLocalizations.of('Switched to ${val.name}')));
                      //   setState(() {
                      //     CurrentUser().currentUser.country = val.name;
                      //   });
                      //   ProfileApiCalls.changeCountry(val.name);
                      // });
                    },
                    hint: Text(
                      AppLocalizations.of("Country"),
                      // countryString,
                      style: _commonStyle(16, FontWeight.w500),
                      // style:
                      //   TextStyle(
                      //       fontSize: 16,
                      //       color:  Colors.black : null),
                    ),
                  ),
                ),
                CurrentUser().currentUser.country != null &&
                        CurrentUser().currentUser.country != ""
                    ? _divider()
                    : Container(),
                CurrentUser().currentUser.country != null
                    ? _countryTile(CurrentUser().currentUser.country ?? "",
                        null ?? "", _commonStyle(16, FontWeight.w500))
                    : Container(),
              ])));
    }

    Widget customProductBox(
        String productType, String productTypeImage, index) {
      return Obx(
        () => Card(
          elevation: 1.2.h,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            decoration: BoxDecoration(
                color: widget.controller!.currentCategory.value == '$index'
                    ? HexColor('#232323')
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
                            color: widget.controller!.currentCategory.value ==
                                    '$index'
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
            if (widget.controller!.currentCategory.value == "$index") {
              widget.controller!.currentCategory.value = "";
            } else if (widget.controller!.currentCategory.value == "" ||
                widget.controller!.currentCategory.value != "$index") {
              widget.controller!.currentCategory.value = "$index";
            } else {
              ;
            }
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

    Widget subProductWidget(int index) {
      return ListTile(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => BebuzeeShopInnerView(),
          // ));

          widget.controller!.currentCountry.value =
              '${widget.controller!.countryList[index].countryName} ';
          widget.controller!.currentFlagIcon.value =
              widget.controller!.countryList[index].flagIcon!;
          widget.controller!.currentCountryId.value =
              widget.controller!.countryList[index].countryValue!;
          print("store country id=${widget.controller!.currentCountryId}");
          Navigator.of(context).pop();
        },
        tileColor: Colors.white,
        leading: CircleAvatar(
            child: Text(widget.controller!.countryList[index].flagIcon!)),
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('${widget.controller!.countryList[index].countryName} '),
      );
    }

    Widget testGridExpanded() {
      return ListView.separated(
          separatorBuilder: (context, index) => Container(
                height: 0.1.h,
                width: 100.0.w,
                color: Colors.black12,
              ),
          shrinkWrap: true,
          itemCount: widget.controller!.countryList.length,
          itemBuilder: (context, index) => subProductWidget(index));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: ListTile(
            title: Text('Edit Store Details',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Edit Your store by entering your description'),
            leading: CircularPercentIndicator(
              radius: 12.0.w,
              lineWidth: 5.0,
              percent: 0.5,
              center: new Text("1/2"),
              progressColor: HexColor('#232323'),
            ),
          ),
        ),
        elevation: 0.0,
        title: Text('Edit your store',
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
          // Obx(() => widget.controller.currentCategory.value != ''
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
          // ListTile(
          //   title: Text('Add Shop Details',
          //       style: TextStyle(fontWeight: FontWeight.bold)),
          //   subtitle: Text('Setup Your shop by entering your description'),
          //   leading: CircularPercentIndicator(
          //     radius: 12.0.w,
          //     lineWidth: 5.0,
          //     percent: 0.5,
          //     center: new Text("1/2"),
          //     progressColor: HexColor('#232323'),
          //   ),
          // ),
          SizedBox(
            height: 5.0.h,
          ),
          Padding(
            padding: EdgeInsets.all(5.0.w),
            child: Text('Select Shop Category',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 2.0.h)),
          ),
          testGrid(0),
          SizedBox(
            height: 1.0.h,
          ),
          testGrid(2),
          SizedBox(
            height: 1.0.h,
          ),
          testGrid(4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Add Shop Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
            child: TextField(
              controller: widget.controller!.currentStoreName,
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
                  hintText: 'Enter Shop Name',
                  focusColor: Colors.black),
            ),
          ),
          // dropDown9(context)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Select Store Country',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Obx(() => Text('${widget.controller!.currentFlagIcon}')),
              ),

              // ClipRRect(
              //   borderRadius: BorderRadius.circular(12),
              //   child:

              //   //  Container(
              //   //   height: 20.0.h,
              //   //   width: 10.0.w,
              //   //   decoration: BoxDecoration(
              //   //       image: DecorationImage(
              //   //           fit: BoxFit.cover,
              //   //           image: CachedNetworkImageProvider(
              //   //             'https://cdn.luxe.digital/media/2019/09/12085003/casual-dress-code-men-style-summer-luxe-digital.jpg',
              //   //           ))),
              //   // ),
              // ),
              title:
                  Obx(() => Text('${widget.controller!.currentCountry.value}')),
              trailing: IconButton(
                  onPressed: () {
                    widget.controller!.getCountry();
                    showBarModalBottomSheet(
                        context: context,
                        builder: (ctx) => Obx(
                              () => Container(
                                height: 50.0.h,
                                width: 100.0.w,
                                child:
                                    widget.controller!.countryList.length == 0
                                        ? loadingAnimation()
                                        : testGridExpanded(),
                              ),
                            ));
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  )),
            ),
          ),
        ],
      )),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          widget.controller!.storeid = widget.storeid;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BebuzeeMerchantInnerViewSecondStoreEdit(
                    controller: widget.controller!,
                  )));
        },
        child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: Container(
              height: 5.0.h,
              color: HexColor('#232323'),
              width: 100.0.w,
              child: Center(
                child: Text('NEXT',
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
