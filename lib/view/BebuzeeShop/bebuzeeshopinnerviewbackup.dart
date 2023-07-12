import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../../services/BebuzeeShop/bebuzeeshopproductdetailpage.dart';
import '../../utilities/custom_icons.dart';

class BebuzeeShopInnerViewBackup extends StatefulWidget {
  const BebuzeeShopInnerViewBackup({Key? key}) : super(key: key);

  @override
  State<BebuzeeShopInnerViewBackup> createState() =>
      _BebuzeeShopInnerViewBackupState();
}

class _BebuzeeShopInnerViewBackupState
    extends State<BebuzeeShopInnerViewBackup> {
  @override
  Widget build(BuildContext context) {
    Widget customGridView() {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 40.0.h,
              childAspectRatio: 1,
              mainAxisExtent: 40.0.h,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0),
          itemCount: 12,
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BebuzeeShopProductDetail()));
              },
              child: Container(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal)),
                                Text('125\$',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal)),
                                Text('Delivery by 25 Sep',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ],
                            )),
                      ),
                    )
                  ]),
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar:
          AppBar(title: Text('Shopper'), backgroundColor: HexColor('#232323')),
      body: SingleChildScrollView(
          child: Container(
        width: 100.0.w,
        height: 100.0.h,
        child: customGridView(),
      )),
      bottomNavigationBar: Container(
        height: 5.0.h,
        width: 100.0.h,
        child: Row(
          children: [
            // Text('Gender'),
            Expanded(
                child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [Icon(CustomIcons.sort), Text('SORT BY')])),
            Expanded(
                child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [Icon(CustomIcons.filter), Text('FILTER')]))
          ],
        ),
      ),
    );
  }
}
