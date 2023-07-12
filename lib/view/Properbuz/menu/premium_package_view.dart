import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_menu_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/menu/featuredpropeertypay.dart';
import 'package:bizbultest/view/paypal_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../api/api.dart';

class PremiumPackageView extends StatefulWidget {
  String? propertyId;
  String? duration;
  PremiumPackageView({Key? key, this.propertyId, this.duration})
      : super(key: key);

  @override
  State<PremiumPackageView> createState() => _PremiumPackageViewState();
}

class _PremiumPackageViewState extends State<PremiumPackageView> {
  //  PropertySearchedController controller = Get.put(PropertySearchedController());

  ProperbuzMenuController controller = Get.put(ProperbuzMenuController());

  @override
  void initState() {
    super.initState();
    controller.getData();
  }

  Widget _userUpgradeCard() {
    print("current user");
    //  String memberId = CurrentUser().currentUser.memberID;
    //  String memberId = CurrentUser().currentUser.memberID;
    //           UserDetailModel objUserDetailModel =
    //               await ApiProvider().getUserDetail(memberId);

    return Container(
      color: Colors.grey.shade200,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          backgroundImage:
              CachedNetworkImageProvider(CurrentUser().currentUser.image!),
        ),
        title: Text("Hi ${CurrentUser().currentUser.fullName}"),
        subtitle: Text(
          AppLocalizations.of(
            "Upgrade your account to unlock the power of Properbuz",
          ),
        ),
      ),
    );
  }

  Widget _headerCard(bool isAgent) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Text(
          isAgent
              ? AppLocalizations.of(
                  "Premium Estate Agent Features",
                )
              : AppLocalizations.of(
                  "Premium Estate User Features",
                ),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: settingsColor,
          ),
        ));
  }

  Widget _customFeatureTile(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
            padding: EdgeInsets.all(8),
            decoration: new BoxDecoration(
              color: appBarColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 26,
              color: Colors.white,
            )),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: appBarColor, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              fontWeight: FontWeight.normal, color: appBarColor, fontSize: 14),
        ),
      ),
    );
  }

  Future<String> subscribeUser(
      String amount, String type, String propertyId, String duration) async {
    print("payment api called");
    var payData = {
      "user_id": CurrentUser().currentUser.memberID,
      "property_id": propertyId,
      "amount": amount,
      "duration": duration,
      "property_category": type
    };
    print("paydata=${payData}");
    var url = 'https://www.bebuzee.com/api/property/upgradeProperty';
    print('payment url=${url}');
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, params: payData)
        .then((value) => value);
    print("payment url=${response.data['url']}");
    return response.data['url'];
  }

  Widget _upgradeButton(String amount) {
    return InkWell(
      onTap: () async {
        var url = await subscribeUser(
            '100', 'featured', widget.propertyId!, widget.duration!);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => FeaturedPropertyPayWebView(
                  paymenetUrl: url,
                  type: 'featured',
                )));
        // make PayPal payment

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => PaypalPayment(
        //       onFinish: (number) async {
        //         // payment done
        //         print('order id: ' + number);
        //         controller.updateSubscription(number.toString());
        //       },
        //       amount: amount,
        //     ),
        //   ),
        // );
        // final request = BraintreeCreditCardRequest(
        //   cardNumber: '4111111111111111',
        //   expirationMonth: '12',
        //   expirationYear: '2021',
        //   cvv: '367'
        // );
        // BraintreePaymentMethodNonce result = await Braintree.tokenizeCreditCard(
        //    '<Insert your tokenization key or client token here>',
        //    request,
        // );
        // print(result.nonce);

        //final request2 = BraintreePayPalRequest(amount: '13.37');
        // BraintreePaymentMethodNonce result2 = await Braintree.requestPaypalNonce(
        //    'AFcWxV21C7fd0v3bYYYRCpSSRl31AaEdihVTFBgNWuE54Z0JdkwcarqO',
        //    request2,
        // );
        // if (result2 != null) {
        //   print('Nonce: ${result2.nonce}');
        // } else {
        //   print('PayPal flow was canceled.');
        // }
        //  Navigator.of(context).push(
        //                   MaterialPageRoute(
        //                     builder: (BuildContext context) => PaypalPayment(
        //                       onFinish: (number) async {

        //                         // payment done
        //                         print('order id: '+number);

        //                       },
        //                     ),
        //                   ),
        //                 );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: new BoxDecoration(
          color: settingsColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        height: 55,
        width: 100.0.w - 10,
        child: Center(
            child: Text(
          AppLocalizations.of(
                "Upgrade for",
              ) +
              " \$" +
              amount,
          style: TextStyle(fontSize: 15, color: Colors.white),
        )),
      ),
    );
  }

  _normalPersonWidget() {
    return Column(
      children: [
        _customFeatureTile(
            AppLocalizations.of(
              "30 InMail credits per month",
            ),
            AppLocalizations.of(
              "You can send 30 messages per month to other peroperbuz member who are not in you connection",
            ),
            Icons.mail),
        _customFeatureTile(
            AppLocalizations.of(
              "Who's Viewed Your Profile",
            ),
            AppLocalizations.of(
              "See who viewed your profile in the last 120 days (4 months)",
            ),
            Icons.remove_red_eye),
        _customFeatureTile(
            AppLocalizations.of(
              "Advanced Search",
            ),
            AppLocalizations.of(
              "Additional files to search for people(previous companies, industry and current job title",
            ),
            Icons.format_list_bulleted_sharp),
        _customFeatureTile(
            AppLocalizations.of(
              "Unlimted Post and Profile Search",
            ),
            AppLocalizations.of(
              "You can view infinte number of posts outside your network",
            ),
            Icons.post_add),
        _customFeatureTile(
            AppLocalizations.of(
              "Brodcast Message",
            ),
            AppLocalizations.of(
              "You can send broadcast message to all your connections at once",
            ),
            Icons.message),
      ],
    );
  }

  _agentWidget() {
    return Column(
      children: [
        _customFeatureTile(
            AppLocalizations.of(
              "Unlimited InMail credits per month",
            ),
            AppLocalizations.of(
              "You can send unlimted message per month to other properbuz member who are not in your connection(InMail)",
            ),
            Icons.analytics_outlined),
        _customFeatureTile(
            AppLocalizations.of(
              "Who's Viewed Your Profile",
            ),
            AppLocalizations.of(
              "See who viewed your profile in the last 120 days (4 months)",
            ),
            Icons.remove_red_eye),
        _customFeatureTile(
            AppLocalizations.of(
              "Advanced Search",
            ),
            AppLocalizations.of(
              "Additional files to search for people(previous companies, industry and current job title",
            ),
            Icons.format_list_bulleted_sharp),
        _customFeatureTile(
            AppLocalizations.of(
              "Unlimted Post and Profile Search",
            ),
            AppLocalizations.of(
              "You can view infinte number of posts outside your network",
            ),
            Icons.post_add),
        _customFeatureTile(
            AppLocalizations.of(
              "Brodcast Message",
            ),
            AppLocalizations.of(
              "You can send broadcast message to all your connections at once",
            ),
            Icons.message),
        _customFeatureTile(
            AppLocalizations.of(
              "Property Analytics",
            ),
            AppLocalizations.of(
              "you will have access to the property analytics of your listed properties",
            ),
            Icons.analytics),
        _customFeatureTile(
            AppLocalizations.of(
              "Property Views",
            ),
            AppLocalizations.of(
              "You can see the view counts of your properties and people who have viewed",
            ),
            Icons.person_add),
        _customFeatureTile(
            AppLocalizations.of(
              "Priority Listing",
            ),
            AppLocalizations.of(
              "Property XML uploaded by premium agents will have a priority to get listed quicker than those uploaded by free agents",
            ),
            Icons.list),
        _customFeatureTile(
            AppLocalizations.of(
              "Priority Display",
            ),
            AppLocalizations.of(
              "Premium agents will be displayed first in the recommendation list of agents to follow",
            ),
            Icons.account_circle_rounded),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzMenuController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(
            "Premium Package",
          ),
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              height: 100.0.h -
                  (56 + MediaQueryData.fromWindow(window).padding.top + 75),
              child: SingleChildScrollView(
                  child: Obx(() => controller.isLoaded.value ?? false
                      ? controller.isAlreadyMember.value ?? false
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    "Already a Member",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ],
                            ))
                          : Column(
                              children: [
                                _userUpgradeCard(),
                                _headerCard(controller.isAgent.value),
                                controller.isAgent.value
                                    ? _agentWidget()
                                    : _normalPersonWidget()
                              ],
                            )
                      : Container())),
            ),

            // Obx(()=> Text(controller.isAlreadyMember.value.toString())),
            Obx(() => controller.isLoaded.value
                ? controller.isAlreadyMember.value
                    ? Container()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _upgradeButton(
                                controller.isAgent.value ? "99.99" : "5/month"),
                          ],
                        ),
                      )
                : Container()),
            Container(
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              height: 100.0.h -
                  (56 + MediaQueryData.fromWindow(window).padding.top + 75),
              child: SingleChildScrollView(
                  child: Obx(() => controller.isLoaded.value ?? false
                      ? controller.isAlreadyMember.value ?? false
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    "Already a Member",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ],
                            ))
                          : Column(
                              children: [
                                // _userUpgradeCard(),
                                _headerCard(controller.isAgent.value),
                                controller.isAgent.value
                                    ? _agentWidget()
                                    : _normalPersonWidget()
                              ],
                            )
                      : Container())),
            ),

            // Obx(()=> Text(controller.isAlreadyMember.value.toString())),
            Obx(() => controller.isLoaded.value
                ? controller.isAlreadyMember.value
                    ? Container()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _upgradeButton(controller.isAgent.value
                                ? "99.99"
                                : "9 /month"),
                          ],
                        ),
                      )
                : Container()),
            Container(
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              height: 100.0.h -
                  (56 + MediaQueryData.fromWindow(window).padding.top + 75),
              child: SingleChildScrollView(
                  child: Obx(() => controller.isLoaded.value ?? false
                      ? controller.isAlreadyMember.value ?? false
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    "Already a Member",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ],
                            ))
                          : Column(
                              children: [
                                // _userUpgradeCard(),
                                _headerCard(controller.isAgent.value),
                                controller.isAgent.value
                                    ? _agentWidget()
                                    : _normalPersonWidget()
                              ],
                            )
                      : Container())),
            ),

            // Obx(()=> Text(controller.isAlreadyMember.value.toString())),
            Obx(() => controller.isLoaded.value
                ? controller.isAlreadyMember.value
                    ? Container()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _upgradeButton(controller.isAgent.value
                                ? "99.99"
                                : "15 /month"),
                          ],
                        ),
                      )
                : Container())
          ],
        ),
      ),
    );
  }
}
