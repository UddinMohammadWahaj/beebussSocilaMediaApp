import 'package:bizbultest/models/Properbuz/boost_post_model.dart';
import 'package:bizbultest/models/Properbuz/url_metadata_model.dart';
import 'package:bizbultest/models/audience_model.dart';
import 'package:bizbultest/widgets/Properbuz/utils/properbuz_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';

import '../../Language/appLocalization.dart';
import '../current_user.dart';
import 'api/properbuz_feeds_api.dart';

class BootPostController extends GetxController {
  var selectedButton = "Learn More".obs;
  var focusNode = FocusNode();
  var isDataLoading = false.obs;
  var selectedAudienceID = "";
  var isPaying = false.obs;
  List<String> buttonsList = [
    "Shop Now",
    "Book Now",
    "Learn More",
    "Sign Up",
    "Send Message",
    "Visit Bebuzee Profile",
    "Subscribe",
    "Install now",
    "Find out more"
  ];
  TextEditingController linkController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  var url = "".obs;
  var divisions = 2.obs;
  var urlMetadata = UrlMetadataModel(title: "", domain: "").obs;
  var audienceList = <AudienceModel>[].obs;
  var boostData = BoostPostModel().obs;
  var dateTime = new DateTime.now().obs;

  @override
  void onInit() {
    debounce(url, (callback) => getURLMetadata(),
        time: Duration(milliseconds: 300));
    super.onInit();
  }

  void getBoostPostDetails(String postID) async {
    isDataLoading.value = true;
    var data = await ProperbuzFeedsAPI.getBoostPostData(postID);
    boostData.value = data;
    daysController.text = data.duration.toString();
    dateTime.value = data.date!;
    getAudienceList();
  }

  void getAudienceList() async {
    var data = await ProperbuzFeedsAPI.getAudienceData();
    audienceList.assignAll(data);
    isDataLoading.value = false;
  }

  void selectButton(String name) {
    selectedButton.value = name;
    Get.back();
  }

  void changeDate(String days) {
    if (days.isNotEmpty) {
      dateTime.value = DateTime.now();
      dateTime.value =
          DateTime.now().add(Duration(days: double.parse(days).toInt()));
      String maxVal =
          ((boostData.value.budget!.value.toInt() * 1400) / int.parse(days))
              .toStringAsFixed(0);
      String newMax = "";
      for (int i = 0; i < maxVal.length; i++) {
        if ((i) % 3 == 0 && i != 0) {
          newMax += ",";
        }
        newMax += maxVal[maxVal.length - i - 1];
      }
      String minVal =
          ((boostData.value.budget!.value.toInt() * 480) / int.parse(days))
              .toStringAsFixed(0);
      String newMin = "";
      for (int i = 0; i < minVal.length; i++) {
        if ((i) % 3 == 0 && i != 0) {
          newMin += ",";
        }
        newMin += minVal[minVal.length - i - 1];
      }
      boostData.value.minReach!.value = newMin.split('').reversed.join();
      boostData.value.maxReach!.value = newMax.split('').reversed.join();
    } else {
      dateTime.value = DateTime.now();
      String maxVal =
          ((boostData.value.budget!.value.toInt() * 4) / int.parse(days))
              .toStringAsFixed(0);
      String newMax = "";
      for (int i = 0; i < maxVal.length; i++) {
        if ((i) % 3 == 0 && i != 0) {
          newMax += ",";
        }
        newMax += maxVal[maxVal.length - i - 1];
      }
      String minVal = ((boostData.value.budget!.value.toInt() * 480) / 4)
          .toStringAsFixed(0);
      String newMin = "";
      for (int i = 0; i < minVal.length; i++) {
        if ((i) % 3 == 0 && i != 0) {
          newMin += ",";
        }
        newMin += minVal[minVal.length - i - 1];
      }
      boostData.value.minReach!.value = newMin.split('').reversed.join();
      boostData.value.maxReach!.value = newMax.split('').reversed.join();
    }
  }

  void onChangeSlider(double value) {
    if (value.toInt() < 10) {
      divisions.value = 1000;
    } else if (value.toInt() < 13) {
      divisions.value = 500;
    } else if (value.toInt() < 15 && value.toInt() > 13) {
      divisions.value = 1000;
    } else if (value.toInt() >= 15 && value.toInt() < 29) {
      divisions.value = 200;
    } else if (value.toInt() > 29 && value.toInt() < 79) {
      divisions.value = 100;
    } else if (value.toInt() > 79 && value.toInt() < 119) {
      divisions.value = 50;
    } else if (value.toInt() > 119 && value.toInt() < 199) {
      divisions.value = 20;
    } else if (value.toInt() > 199 && value.toInt() < 299) {
      divisions.value = 10;
    } else if (value.toInt() > 299 && value.toInt() < 499) {
      divisions.value = 5;
    } else if (value.toInt() > 499 && value.toInt() < 999) {
      divisions.value = 2;
    }

    String maxVal = ((value.toInt() * 1400) / int.parse(daysController.text))
        .toStringAsFixed(0);
    String newMax = "";
    for (int i = 0; i < maxVal.length; i++) {
      if ((i) % 3 == 0 && i != 0) {
        newMax += ",";
      }
      newMax += maxVal[maxVal.length - i - 1];
    }
    String minVal = ((value.toInt() * 480) / int.parse(daysController.text))
        .toStringAsFixed(0);
    String newMin = "";
    for (int i = 0; i < minVal.length; i++) {
      if ((i) % 3 == 0 && i != 0) {
        newMin += ",";
      }
      newMin += minVal[minVal.length - i - 1];
    }

    boostData.value.minReach!.value = newMin.split('').reversed.join();
    boostData.value.maxReach!.value = newMax.split('').reversed.join();
    boostData.value.budget!.value = value.toInt();
  }

  void getURLMetadata() async {
    if (url.value.isNotEmpty) {
      var metadata = await ProperbuzFeedsAPI.getURLMetadata(url.value);
      urlMetadata.value = metadata;
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      focusNode.unfocus();
    } else {
      urlMetadata.value.title = "";
      urlMetadata.value.domain = "";
    }
  }

  void selectUnSelectAudience(int index) {
    audienceList.forEach((element) {
      if (element.selected!.value) {
        element.selected!.value = false;
      }
    });
    audienceList[index].selected!.value = true;
    selectedAudienceID = audienceList[index].audienceId!;
  }

  String amountLeftInWallet() {
    if (boostData.value.budget!.value >= boostData.value.walletBalance!.value) {
      return boostData.value.walletBalance!.value.toString();
    } else {
      return ((boostData.value.budget!.value -
              boostData.value.walletBalance!.value))
          .abs()
          .toString();
    }
  }

  void boostPost(String postID, String payerID, String paymentID) async {
    isPaying.value = true;
    await ProperbuzFeedsAPI.boostPost(
        postID,
        selectedAudienceID,
        daysController.text,
        (boostData.value.budget!.value - boostData.value.walletBalance!.value)
            .abs()
            .toString(),
        selectedButton.value,
        url.value,
        urlMetadata.value.title!,
        urlMetadata.value.domain!,
        payerID,
        paymentID,
        amountLeftInWallet());
    isPaying.value = false;
    Get.showSnackbar(properbuzSnackBar("Payment successful"));
  }

  void goToPaymentPage(BuildContext context, String postID) {
    if (boostData.value.budget!.value > boostData.value.walletBalance!.value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => UsePaypal(
              sandboxMode: true,
              clientId:
                  "AfBD8eE57QvXiQ5ckptq3lJWTxlq_wWUD2ClnGZgrbTVulA4Xbag6r27e39Eu8K6vO-NaU5BuQih1w6r",
              secretKey:
                  "EK48uczoGqrx6Akoz1OdtEQkYJTXpabQG1bqsKZVgtnqEBRF6Q7uSAzLpHvdBApR2sRKO3OkCfHoI1it",
              returnURL: "https://samplesite.com/return",
              cancelURL: "https://samplesite.com/cancel",
              transactions: [
                {
                  "amount": {
                    "total": (boostData.value.budget!.value -
                            boostData.value.walletBalance!.value)
                        .abs()
                        .toString(),
                    "currency": "USD",
                    "details": {
                      "subtotal":
                          '${(boostData.value.budget!.value - boostData.value.walletBalance!.value).abs().toString()}',
                      "shipping": '0',
                      "shipping_discount": 0
                    }
                  },
                  "description":
                      "post_id : $postID, user_id : ${CurrentUser().currentUser.memberID}",
                  "item_list": {
                    "items": [
                      {
                        "name":
                            "${CurrentUser().currentUser.shortcode}_${CurrentUser().currentUser.memberID}_$postID",
                        "quantity": 1,
                        "price":
                            '${(boostData.value.budget!.value - boostData.value.walletBalance!.value).abs().toString()}',
                        "currency": "USD"
                      }
                    ],
                  }
                }
              ],
              note: "Contact us for any questions on your order.",
              onSuccess: (Map params) async {
                print("onSuccess: $params");
                print(params["payerID"]);
                boostPost(postID, params["payerID"], params["paymentId"]);
                //Get.showSnackbar(properbuzSnackBar("Payment successful"));
              },
              onError: (error) {
                print("onError: $error");
                Get.showSnackbar(properbuzSnackBar(error.toString()));
              },
              onCancel: (params) {
                print('cancelled: $params');
              }),
        ),
      );
    } else {
      boostPost(postID, "", "");
    }
  }

  void proceedToPay(BuildContext context, String postID) {
    print(amountLeftInWallet());
    //print((boostData.value.budget.value - boostData.value.walletBalance.value).abs());
    if (linkController.text.isEmpty) {
      Get.showSnackbar(properbuzSnackBar("Please enter your website URL"));
    } else if (selectedAudienceID.isEmpty) {
      Get.showSnackbar(properbuzSnackBar("Please select at least 1 audience"));
    } else if (daysController.text.isEmpty) {
      Get.showSnackbar(properbuzSnackBar("Please select number of days"));
    } else {
      goToPaymentPage(context, postID);
    }
  }
}
