import 'package:bizbultest/services/BebuzeeShop/bebuzeeshopmanagercontroller.dart';
import 'package:bizbultest/view/BebuzeeShop/subscribemerchantview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../api/bebuzeeshopapis/bebuzeeshopapi.dart';
import '../../services/current_user.dart';

class BebuzeeShopMerchantPremium extends StatefulWidget {
  BebuzeeShopManagerController? shopmanagercontroller;

  BebuzeeShopMerchantPremium({Key? key, this.shopmanagercontroller})
      : super(key: key);

  @override
  State<BebuzeeShopMerchantPremium> createState() =>
      _BebuzeeShopMerchantPremiumState();
}

class _BebuzeeShopMerchantPremiumState
    extends State<BebuzeeShopMerchantPremium> {
  @override
  void initState() {
    widget.shopmanagercontroller!.fetchsubscriptionType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Merchant Premium Package',
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: 100.0.w,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Enjoy these features on all of the below plans'),
              ),
              Card(
                  child: Container(
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Subscription Status'),
                          ),
                          Obx(() => Text(
                              '${widget.shopmanagercontroller!.subscriptionType.value == '' ? 'INACTIVE' : widget.shopmanagercontroller!.subscriptionType.value.toUpperCase()}'))
                        ],
                      ))),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                      border: Border.all(color: Colors.black)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Diamond',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.5.h),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('Every thing you need to create your store'),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$ 10',
                            style:
                                TextStyle(color: Colors.black, fontSize: 5.0.h),
                          ),
                          Text('/monthly')
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 100.0.w,
                            child: Text(
                              'What\'s included on Diamond',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 2.4.h),
                            )),
                      ),
                      RadioListTile(
                        title: Text(
                          "Basic Reports",
                        ),
                        value: "Basic Reports",
                        selected: true,
                        groupValue: 'Basic Reports',
                        activeColor: Colors.black,
                        onChanged: (value) {},
                      ),
                      RadioListTile(
                        title: Text("Multiple Store Account"),
                        value: "1",
                        selected: true,
                        groupValue: '1',
                        activeColor: Colors.black,
                        onChanged: (value) {},
                      ),
                      RadioListTile(
                        title: Text("Upto multple stores add"),
                        value: "1",
                        selected: true,
                        groupValue: '1',
                        activeColor: Colors.black,
                        onChanged: (value) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            String paymenturl = await BebuzeeShopApi()
                                .subscribeMerchant('10', 'diamond')
                                .then((value) => value);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SubscribeMerchantWebsiteView(
                                      memberID:
                                          CurrentUser().currentUser.memberID!,
                                      url: paymenturl),
                            ));
                          },
                          child: Text('Subscribe'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Card(
                child: Container(
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                      border: Border.all(color: Colors.black)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Gold',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.5.h),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('Every thing you need to create your store'),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$ 5',
                            style:
                                TextStyle(color: Colors.black, fontSize: 5.0.h),
                          ),
                          Text('/monthly')
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 100.0.w,
                            child: Text(
                              'What\'s included on Gold',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 2.4.h),
                            )),
                      ),
                      RadioListTile(
                        title: Text(
                          "Basic Reports",
                        ),
                        value: "Basic Reports",
                        selected: true,
                        groupValue: 'Basic Reports',
                        activeColor: Colors.black,
                        onChanged: (value) {},
                      ),
                      RadioListTile(
                        title: Text("1 Store Account"),
                        value: "1",
                        selected: true,
                        groupValue: '1',
                        activeColor: Colors.black,
                        onChanged: (value) {},
                      ),
                      RadioListTile(
                        title: Text("Upto 5 product add"),
                        value: "1",
                        selected: true,
                        groupValue: '1',
                        activeColor: Colors.black,
                        onChanged: (value) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            String paymenturl = await BebuzeeShopApi()
                                .subscribeMerchant('5', 'gold')
                                .then((value) => value);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SubscribeMerchantWebsiteView(
                                      memberID:
                                          CurrentUser().currentUser.memberID!,
                                      url: paymenturl),
                            ));
                          },
                          child: Text('Subscribe'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Card(
              //   child: Container(
              //     decoration: BoxDecoration(
              //         // borderRadius: BorderRadius.all(Radius.circular(12)),
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black)),
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(
              //             'Diamond',
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 2.5.h),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child:
              //               Text('Every thing you need to create your store'),
              //         ),
              //         Text(
              //           '\$ 0',
              //           style: TextStyle(color: Colors.black, fontSize: 5.0.h),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Container(
              //               width: 100.0.w,
              //               child: Text(
              //                 'What\'s included on Basic',
              //                 textAlign: TextAlign.start,
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 2.4.h),
              //               )),
              //         ),
              //         RadioListTile(
              //           title: Text(
              //             "Basic Reports",
              //           ),
              //           value: "Basic Reports",
              //           selected: true,
              //           groupValue: 'Basic Reports',
              //           activeColor: Colors.black,
              //           onChanged: (value) {},
              //         ),
              //         RadioListTile(
              //           title: Text("1 Store Account"),
              //           value: "1",
              //           selected: true,
              //           groupValue: '1',
              //           activeColor: Colors.black,
              //           onChanged: (value) {},
              //         ),
              //         RadioListTile(
              //           title: Text("Upto 5 product add"),
              //           value: "1",
              //           selected: true,
              //           groupValue: '1',
              //           activeColor: Colors.black,
              //           onChanged: (value) {},
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: ElevatedButton(
              //             onPressed: () {},
              //             child: Text('Buy'),
              //             style: ButtonStyle(
              //                 backgroundColor:
              //                     MaterialStateProperty.all(Colors.black)),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // Card(
              //   child: Container(
              //     decoration: BoxDecoration(
              //         // borderRadius: BorderRadius.all(Radius.circular(12)),
              //         color: Colors.white,
              //         border: Border.all(color: Colors.black)),
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(
              //             'Platinum',
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 2.5.h),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child:
              //               Text('Every thing you need to create your store'),
              //         ),
              //         Text(
              //           '\$ 100',
              //           style: TextStyle(color: Colors.black, fontSize: 5.0.h),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Container(
              //               width: 100.0.w,
              //               child: Text(
              //                 'What\'s included on Basic',
              //                 textAlign: TextAlign.start,
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 2.4.h),
              //               )),
              //         ),
              //         RadioListTile(
              //             value: true,
              //             groupValue: false,
              //             onChanged: (value) {}),
              //         RadioListTile(
              //           title: Text(
              //             "Basic Reports",
              //           ),
              //           value: "Basic Reports",
              //           selected: true,
              //           groupValue: 'Basic Reports',
              //           activeColor: Colors.black,
              //           onChanged: (value) {},
              //         ),
              //         RadioListTile(
              //           title: Text("1 Store Account"),
              //           value: "1",
              //           selected: true,
              //           groupValue: '1',
              //           activeColor: Colors.black,
              //           onChanged: (value) {},
              //         ),
              //         RadioListTile(
              //           title: Text("Upto 5 product add"),
              //           value: "1",
              //           selected: true,
              //           groupValue: '1',
              //           activeColor: Colors.black,
              //           onChanged: (value) {},
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: ElevatedButton(
              //             onPressed: () {},
              //             child: Text('Buy'),
              //             style: ButtonStyle(
              //                 backgroundColor:
              //                     MaterialStateProperty.all(Colors.black)),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
