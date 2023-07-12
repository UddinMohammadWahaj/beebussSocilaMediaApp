import 'package:bizbultest/view/Properbuz/add_items/websiteviewtradesman.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../services/Tradesmen/tradesmendashbooarcontroller.dart';
import '../../../utilities/colors.dart';

class TradesmanPaymentView extends StatefulWidget {
  TrademenMaincontroller? controller;
  TradesmanPaymentView({Key? key, this.controller}) : super(key: key);

  @override
  State<TradesmanPaymentView> createState() => _TradesmanPaymentViewState();
}

class _TradesmanPaymentViewState extends State<TradesmanPaymentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tradesman Subscription'),
        backgroundColor: settingsColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: 100.0.w,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(' '),
              ),
              Card(
                child: Container(
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white,
                      border: Border.all(color: settingsColor)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Monthly',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.5.h),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(''),
                      // ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$ 5',
                            style:
                                TextStyle(color: Colors.black, fontSize: 5.0.h),
                          ),
                          Text('/month'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 100.0.w,
                            child: Text(
                              'What\'s included on Basic',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 2.4.h),
                            )),
                      ),
                      RadioListTile(
                        title: Text(
                          "Single user",
                        ),
                        value: "Basic Reports",
                        selected: true,
                        groupValue: 'Basic Reports',
                        activeColor: settingsColor,
                        onChanged: (value) async {},
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
                        activeColor: settingsColor,
                        onChanged: (value) {},
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              widget.controller!.subscribe('20', () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => TradesmenWebsiteView(
                                          heading:
                                              'Tradesmen Subscription payment',
                                          url: widget
                                              .controller!.paymentUrl.value,
                                          onExit: () {
                                            widget.controller!
                                                .getSubscriptionStatus();
                                          },
                                        )));
                              });
                            },
                            child: widget.controller!.ispayloading.value
                                ? FittedBox(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text('Subscribe'),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(settingsColor)),
                          ),
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
