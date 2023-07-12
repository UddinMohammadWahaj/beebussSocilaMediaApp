import 'dart:async';

import 'package:bizbultest/api/bebuzeeshopapis/bebuzeeshopapi.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/BebuzeeShop/shopinnerview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Language/appLocalization.dart';
import '../../services/BebuzeeShop/bebuzeeshopsearchcontroller.dart';

class BebuzeeShopSearch extends StatefulWidget {
  BebuzeeShopManagerController? shopManagerController;
  BebuzeeShopSearch({Key? key, this.shopManagerController}) : super(key: key);

  @override
  State<BebuzeeShopSearch> createState() => _BebuzeeShopSearchState();
}

class _BebuzeeShopSearchState extends State<BebuzeeShopSearch> {
  TextEditingController searchText = TextEditingController();
  var controller = Get.put(BebuzeeShopSearchController());
  @override
  void dispose() {
    // TODO: implement dispose
    controller.searchProductList.value = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            height: 35,
            decoration: new BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              shape: BoxShape.rectangle,
            ),
            child: TextFormField(
              cursorColor: Colors.grey,
              autofocus: true,
              onChanged: (val) async {
                // setState(() {
                //   searchText = val;
                // });
                controller.searchText.value = val;
                // controller.searchProduct(searchText.text);
              },
              controller: searchText,
              maxLines: 1,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: AppLocalizations.of('Search'),
                  contentPadding: EdgeInsets.only(left: 20, bottom: 12),
                  hintStyle: TextStyle(
                      fontSize: 16, color: Colors.grey.withOpacity(0.8))
                  // 48 -> icon width
                  ),
            ),
          ),
        ),
        body: Obx(
          () => controller.searchProductList.length == 0
              ? Center(
                  child: Text('Product not found!!'),
                )
              : ListView.builder(
                  itemCount: controller.searchProductList.length,
                  itemBuilder: (context, index) => ListTile(
                      // leading: CircleAvatar(backgroundColor: Colors.black),
                      title: Text(
                          '${controller.searchProductList[index].productName}'),
                      subtitle: Text(
                          '${controller.searchProductList[index].productBrand}'),
                      onTap: () {
                        print("shop index =$index");

                        widget.shopManagerController!.searchProductCatId.value =
                            '${controller.searchProductList[index].categoryId}';
                        widget.shopManagerController!.searchProductId.value =
                            '';
                        widget.shopManagerController!.searchSubProductId.value =
                            '';
                        // widget.shopManagerController.searchProductKeyword
                        //     .value = controller.searchText.value;
                        // widget.shopManagerController.getProductByKeywordLst(
                        //     controller.searchText.value);
                        // widget.shopManagerController.getProductByCategoryLst(
                        //     controller.searchProductList[index].categoryId);
                        widget.shopManagerController!.getProductList();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BebuzeeShopInnerView(
                              controller: widget.shopManagerController!),
                        ));
                      }),
                ),
        ));
  }
}
