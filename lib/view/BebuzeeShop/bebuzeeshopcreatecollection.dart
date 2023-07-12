import 'package:bizbultest/models/BebuzeeShop/shopbuzwishlistlistmodel.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopcollectioncontroller.dart';
import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import 'package:bizbultest/view/BebuzeeShop/bebuzeeshopcollection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../../api/bebuzeeshopapis/bebuzeeshopapi.dart';

class BebuzeeShopCreateCollection extends StatefulWidget {
  BebuzeeShopManagerController? shopmanager;
  BebuzeeShopCollectionController? shopCollectionController;
  var selectedProducts = <ShopbuzWishlistListDatum>[];
  BebuzeeShopCreateCollection(
      {Key? key,
      this.shopmanager,
      this.shopCollectionController,
      this.selectedProducts = const <ShopbuzWishlistListDatum>[]})
      : super(key: key);

  @override
  State<BebuzeeShopCreateCollection> createState() =>
      _BebuzeeShopCreateCollectionState();
}

class _BebuzeeShopCreateCollectionState
    extends State<BebuzeeShopCreateCollection> {
  Widget customGridView() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 40.0.h,
            childAspectRatio: 1,
            mainAxisExtent: 40.0.h,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0),
        itemCount: 2,
        itemBuilder: (ctx, index) {
          return Container(
            height: 60.0.h,
            width: 30.0.w,
            color: Colors.white,
            child: Card(
              child: Column(children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: 25.0.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxQBq_1rURhRP413jCNK16-qi6gxhwIQV5nQ&usqp=CAU',
                              ))),
                    ),
                    Positioned(
                      bottom: 10,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            color: Colors.grey.withOpacity(0.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    '4.3',
                                    style: TextStyle(fontSize: 1.5.h),
                                  ),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.green,
                                  size: 2.0.h,
                                ),
                              ],
                            ),
                          )),
                    )
                  ],
                ),
                Expanded(
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
                              child: Text('Adidas Tshirt Men',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            Expanded(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.favorite_border_outlined,
                                      size: 3.0.h,
                                    )))
                          ],
                        ),
                        isThreeLine: true,
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sport Tshirt',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            Text('125\$',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            Text('Delivery by 25 Sep',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                          ],
                        )),
                  ),
                )
              ]),
            ),
          );
        });
  }

  buildList(count) {
    if (count == 1) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15.0.h,
            width: 20.0.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        '${widget.selectedProducts[0].productImages![0]}'))),
          ),
        )
      ];
    } else if (count == 2) {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15.0.h,
            width: 20.0.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        '${widget.selectedProducts[0].productImages![0]}'))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15.0.h,
            width: 20.0.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        '${widget.selectedProducts[1].productImages![0]}'))),
          ),
        )
      ];
    } else {
      return [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15.0.h,
            width: 20.0.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        '${widget.selectedProducts[0].productImages![0]}'))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15.0.h,
            width: 20.0.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        '${widget.selectedProducts[1].productImages![0]}'))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15.0.h,
            width: 20.0.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        '${widget.selectedProducts[2].productImages![0]}'))),
          ),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    void addToCollection(listofproductids, collectionName) async {
      await BebuzeeShopApi().addToCollection(listofproductids, collectionName);
    }

    var collectionNameController = new TextEditingController();
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text('Create New Collection',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 2.2.h)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ))
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 20.0.h,
            width: 100.0.w,
            color: Colors.grey.withOpacity(0.2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildList(widget.selectedProducts.length),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Collection Name *',
                style: TextStyle(fontWeight: FontWeight.w400)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
            child: TextField(
              controller: collectionNameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Collection Name',
                  focusColor: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Suggested names:',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Home Wear',
                            style: TextStyle(
                                color: Colors.black) // non-emoji characters
                            ),
                        TextSpan(
                          text: '🏠', // emoji characters
                          style: TextStyle(
                            fontFamily: 'EmojiOne',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                collectionNameController.text = 'Office Wear 💼';
              },
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Office Wear',
                        style: TextStyle(
                            color: Colors.black) // non-emoji characters
                        ),
                    TextSpan(
                      text: '💼', // emoji characters
                      style: TextStyle(
                        fontFamily: 'EmojiOne',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print("tapped");
                collectionNameController.text = 'Summer Wear ☀️';
              },
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Summer Wear',
                        style: TextStyle(
                            color: Colors.black) // non-emoji characters
                        ),
                    TextSpan(
                      text: '☀️', // emoji characters
                      style: TextStyle(
                        fontFamily: 'EmojiOne',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                collectionNameController.text = 'Upcoming Sale 🏷️';
              },
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Upcoming Sale',
                        style: TextStyle(
                            color: Colors.black) // non-emoji characters
                        ),
                    TextSpan(
                      text: '🏷️', // emoji characters
                      style: TextStyle(
                        fontFamily: 'EmojiOne',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            // widget.shopmanager.hascollection.value = true;
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => BebuzeeShopCollections(
            //       shopmanagercontroller: widget.shopmanager),
            // ));

            var listofproductids =
                widget.selectedProducts.map((e) => '${e.wishlistId}').toList();
            var ids = '';
            listofproductids.forEach((element) {
              ids += element + ',';
            });
            ids = ids.substring(0, ids.length - 1);
            print("collection add=${ids}");
            addToCollection(ids, collectionNameController.text);
            // print(
            //     "items finally added to collection ${widget.shopCollectionController.listofcollections}");

            Get.snackbar('Success', 'Collection created successfully',
                backgroundColor: Colors.white, icon: Icon(Icons.check));
            Future.delayed(Duration(seconds: 2), () {
              try {
                widget.shopCollectionController!.getUserCollection();
              } catch (e) {
                print("fetch collection error $e");
              }
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          },
          child: Container(
            height: 10.0.h,
            width: 100.0.w,
            child: Center(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 5.0.h,
                width: 90.0.w,
                child: Center(
                  child: Text('Create collection',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                ),
                color: Colors.black,
              ),
            )),
          ),
        ));
  }
}
