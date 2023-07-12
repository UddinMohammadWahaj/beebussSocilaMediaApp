import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import '../../../api/ApiRepo.dart' as ApiRepo;
import 'dart:async';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:bizbultest/models/address_search_model.dart';
import 'package:bizbultest/models/audience_model.dart';
import 'dart:io' as i;
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/view/create_audience.dart';
import 'package:bizbultest/view/edit_audience.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart' as gett;
import '../../api/api.dart';
import 'audience_card.dart';
import 'banner_ad_payment_webview.dart';
import 'banner_upload_card.dart';
import 'edit_audience_advert.dart';
import 'ad_cards.dart';
import 'new_audience.dart';

class EditVideoAd extends StatefulWidget {
  // final List<String> bannerImages;
  var audienceId;
  final GlobalKey<ScaffoldState>? sKey;
  final String? dataID;

  EditVideoAd({Key? key, this.sKey, this.dataID, this.audienceId})
      : super(key: key);

  @override
  _EditVideoAdState createState() => _EditVideoAdState();
}

class _EditVideoAdState extends State<EditVideoAd> {
  late int value;
  List buttonList = [];
  var buttonString;
  var selectedButton;
  int _value = 6;
  var audienceId;
  int days = 4;
  bool showLocationList = false;
  TextEditingController _buttonLinkController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _couponController = TextEditingController();

  String minReach = "75";
  late String maxReach;
  String walletBalance = "0";
  bool dataLoaded = false;
  bool showProfileButton = false;

  var urlDomain;
  var urlTitle;
  var urlDescription;
  late String paymentUrl;

  late String totalBudget;
  late String adBudget;
  late String postID;
  late String dataID;
  late String video, logo;

  bool hasData = false;
  late int division;
  bool hasAudience = false;
  late String selectedAudienceId;

  late Addresses address;

  late Audiences audienceList;
  String image1 = "";
  String image2 = "";
  String image3 = "";
  String image4 = "";
  String image5 = "";
  Future<void> getAudienceData() async {
    //var url = Uri.parse( "https://www.bebuzee.com/app_devlope_all_boosted.php?action=get_all_audience_user&user_id=$memberID");
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/get_all_audience_user.php",
        {"user_id": CurrentUser().currentUser.memberID!});

    if (response!.success == 1) {
      Audiences audienceData = Audiences.fromJson(response!.data['data']);
      setState(() {
        audienceList = audienceData;
        hasAudience = true;
      });
      // return audienceData.audiences;
    }
  }

  Future<void> boostPost() async {
    // setState(() {
    //   isLoading = true;
    // });

    var url = "https://www.bebuzee.com/api/save_boosted_data_video_ad.php";
    final response = await ApiProvider().fireApiWithParams(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "ad_duration": _daysController.text.toString(),

      "ad_budget": _value.toString(), "data_id": widget.dataID,
      "audience_data": widget.audienceId,
      // "ad_button": selectedButton,
      // "ad_url": _buttonLinkController.text,
      // "title": urlTitle,
      // "ad_url_title": urlTitle,
      // "domain": urlDomain,
      // "coupon_code": _couponController.text,
      // "description": urlDescription,
      // "image": logo,
      // "video": video,
    });
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "ad_duration": days.toString(),
    //   "audience_data": selectedAudienceId.toString(),
    //   "ad_budget": _value.toString(),
    //   "ad_button": selectedButton,
    //   "ad_url": _buttonLinkController.text,
    //   "title": urlTitle,
    //   "ad_url_title": urlTitle,
    //   "domain": urlDomain,
    //   "coupon_code": _couponController.text,
    //   "description": urlDescription,
    //   "image": logo,
    //   "video": videoUrl,
    //   "action": "save_boosted_data_video_ad",
    // });
    print("response of boost data=${response.data}");
    if (response.statusCode == 200) {
      print(response.data);

      if (response.data['payment_method'] == 'wallet') {
        Navigator.of(context).pop();
        gett.Get.showSnackbar(gett.GetSnackBar(
          title: 'Success Payment',
          message: 'Successful payment', duration: Duration(seconds: 1),
          // titleText: Text('Success Payment!'),
          icon: Icon(Icons.money, color: Colors.green),
        ));
        return;
      }
      setState(() {
        paymentUrl = response.data['url_data_paypal'];
        totalBudget = response.data['total_budget'];
        adBudget = response.data['ad_budget'];
        dataID = response.data['data_id'];
        // isLoading = false;
      });

      print('response of payment $paymentUrl');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebsiteView(
                  url: paymentUrl,
                  from: "video",
                  heading: "Payment",
                  memberID: CurrentUser().currentUser.memberID!,
                  adBudget: adBudget,
                  totalBudget: totalBudget,
                  // tabController: widget.tabController,
                  dataID: dataID,
                  postID: postID)));
    }
  }

  Future<void> getDetails() async {
    var url =
        "https://www.bebuzee.com/api/boost_post_status_video.php?action=boost_post_status_banner&user_id=${CurrentUser().currentUser.memberID!}&data_id=${widget.dataID}";
    // var response = await http.get(url);
    print("get result video url=$url");
    var response = await ApiProvider().fireApi(url).then((value) => value);
    print('response of get result banner=${response.data}');
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          days = response.data['days'].runtimeType == 'String'
              ? int.parse(response.data['days'])
              : response.data['days'];

          totalBudget = response.data['budget'];
          video = response.data['video'];
          logo = response.data['logo'];
        });
      }
    }
  }

  Future<void> getURL(String urls) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=url_meta_content&user_id=${CurrentUser().currentUser.memberID!}&url=$urls");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/other/urlMetaData?user_id=${CurrentUser().currentUser.memberID!}&url=$urls');
    print("get url url=${newurl}");

    // var response = await http.get(url);
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var response = await client
        .postUri(
          newurl,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);
    print("get url response=${response.data}");
    if (response.statusCode == 200) {
      setState(() {
        urlDomain =
            response.data['domain'] == '' ? null : response.data['domain'];
        urlTitle = response.data['title'] == '' ? null : response.data['title'];
        urlDescription = response.data['description'];
      });
    }
  }

  Future<void> getWalletBalance() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/video_ad_api.php?user_id=${CurrentUser().currentUser.memberID!}&action=wallet_balance_data");
    var newurl =
        'https://www.bebuzee.com/api/wallet_balance_data.php?user_id=${CurrentUser().currentUser.memberID!}';
    print("wallet balance url=$newurl");
    // var client = Dio();
    // String token = await getToken();
    var response = await ApiRepo.postWithToken('api/wallet_balance_data.php', {
      "user_id": CurrentUser().currentUser.memberID!
    }).then((value) => value);
    // var response = await client
    //     .postUri(
    //       Uri.parse(newurl),
    //       options: Options(headers: {
    //         'Content-Type': 'application/json',
    //         'Accept': 'application/json',
    //         'Authorization': 'Bearer $token',
    //       }),
    //     )
    //     .then((value) => value);
    // var response = await http.get(url);

    if (response!.status == 1) {
      print('wallet balnce=${response.data}');
      setState(() {
        walletBalance = response.data['balance'];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  DateTime selectedDate = DateTime.now().add(Duration(days: 4));

  Future<void> _selectDate(BuildContext context) async {
    //selectedDate = DateTime.now().add(Duration(days: int.parse(_daysController.text)));
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    getDetails();
    _daysController.text = days.toString();
    getWalletBalance();
    getAudienceData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_backspace_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(
                        "Upgrade",
                      ),
                      style: blackBold.copyWith(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0.h),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.only(bottom: 15),
                //   child: Container(
                //     height: 50.0.h,
                //     child: PageView.builder(
                //         itemCount: widget.bannerImages.length,
                //         itemBuilder: (context, index) {
                //           return Image.network(
                //             widget.bannerImages[index],
                //             fit: BoxFit.contain,
                //           );
                //         }),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2.0.w,
                  ),
                  child: Text(
                    AppLocalizations.of(
                      "DURATION AND BUDGET",
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w, top: 1.0.h),
                  child: Text(
                    AppLocalizations.of(
                      "Duration",
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16),
                  ),
                ),
                IncreaseDurationCard(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(
                              "Days",
                            ),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 14),
                          ),
                          SizedBox(
                            width: 1.0.w,
                          ),
                          Container(
                            width: 12.0.w,
                            height: 2.5.h,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                onTap: () {},
                                onChanged: (val) {
                                  if (val.length > 0 &&
                                      int.tryParse(val) != null) {
                                    setState(() {
                                      days = int.parse(val);
                                      selectedDate = DateTime.now()
                                          .add(Duration(days: int.parse(val)));

                                      String maxVal =
                                          ((_value.toInt() * 1400) / days)
                                              .toStringAsFixed(0);
                                      String newMax = "";
                                      for (int i = 0; i < maxVal.length; i++) {
                                        if ((i) % 3 == 0 && i != 0) {
                                          newMax += ",";
                                        }
                                        newMax += maxVal[maxVal.length - i - 1];
                                      }
                                      String minVal =
                                          ((_value.toInt() * 50) / days)
                                              .toStringAsFixed(0);
                                      String newMin = "";
                                      for (int i = 0; i < minVal.length; i++) {
                                        if ((i) % 3 == 0 && i != 0) {
                                          newMin += ",";
                                        }
                                        newMin += minVal[minVal.length - i - 1];
                                      }
                                      setState(() {
                                        minReach =
                                            newMin.split('').reversed.join();
                                        maxReach =
                                            newMax.split('').reversed.join();
                                      });
                                    });
                                  }
                                },
                                maxLines: 1,
                                controller: _daysController,
                                keyboardType: TextInputType.number,
                                style: Theme.of(context).textTheme.bodyText1,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0.w),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryBlueColor, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  //hintText: "Add a link",
                                  // 48 -> icon width
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      EndDateCard(
                        selectedDate: selectedDate,
                        onTap: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w, bottom: 0),
                  child: Text(
                    AppLocalizations.of(
                      "AUDIENCE",
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                // hasAudience == true
                //     ? Column(
                //         children: [
                //           ListView.builder(
                //             physics: NeverScrollableScrollPhysics(),
                //             shrinkWrap: true,
                //             itemCount: audienceList.audiences.length,
                //             itemBuilder: (context, index) {
                //               return Row(
                //                 children: [
                //                   Container(
                //                     width: 85.0.w,
                //                     child: RadioListTile(
                //                       dense: true,
                //                       activeColor: primaryBlueColor,
                //                       value: index,
                //                       groupValue: value,
                //                       onChanged: (ind) {
                //                         setState(() {
                //                           value = ind;
                //                           selectedAudienceId = audienceList
                //                               .audiences[index].audienceId;
                //                           print(selectedAudienceId);
                //                         });
                //                       },
                //                       title: Text(audienceList
                //                           .audiences[index].audienceName),
                //                       subtitle: Container(
                //                         width: 85.0.w,
                //                         child: RichText(
                //                           text: TextSpan(
                //                             children: [
                //                               TextSpan(
                //                                 text: audienceList
                //                                     .audiences[index]
                //                                     .audienceAgeData,
                //                                 style: TextStyle(
                //                                     color: Colors.black),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   GestureDetector(
                //                     onTap: () {
                //                       showModalBottomSheet(
                //                           isScrollControlled: true,
                //                           backgroundColor: Colors.white,
                //                           shape: RoundedRectangleBorder(
                //                               borderRadius: BorderRadius.only(
                //                                   topLeft:
                //                                       const Radius.circular(
                //                                           20.0),
                //                                   topRight:
                //                                       const Radius.circular(
                //                                           20.0))),
                //                           //isScrollControlled:true,
                //                           context: context,
                //                           builder: (BuildContext bc) {
                //                             return EditAudienceAdvert(
                //                               refresh: () {
                //                                 Timer(Duration(seconds: 2), () {
                //                                   getAudienceData();
                //                                 });
                //                               },

                //                               audienceId: audienceList
                //                                   .audiences[index].audienceId,
                //                               memberName: CurrentUser()
                //                                   .currentUser
                //                                   .fullName,
                //                               memberImage: CurrentUser()
                //                                   .currentUser
                //                                   .image,
                //                               //  feed: widget.feed,
                //                               logo: CurrentUser()
                //                                   .currentUser
                //                                   .logo,
                //                               country: CurrentUser()
                //                                   .currentUser
                //                                   .country,
                //                               memberID: CurrentUser()
                //                                   .currentUser
                //                                   .memberID,
                //                             );
                //                           });
                //                     },
                //                     child: Container(
                //                       color: Colors.transparent,
                //                       child: Padding(
                //                         padding: EdgeInsets.only(left: 2.0.w),
                //                         child: Text(
                //                           AppLocalizations.of(
                //                             "Edit",
                //                           ),
                //                           style: TextStyle(
                //                               color: primaryBlueColor),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               );
                //             },
                //           ),
                //         ],
                //       )
                //     : Container(),
                // GestureDetector(
                //   onTap: () {
                //     showModalBottomSheet(
                //         isScrollControlled: true,
                //         backgroundColor: Colors.white,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.only(
                //                 topLeft: const Radius.circular(20.0),
                //                 topRight: const Radius.circular(20.0))),
                //         //isScrollControlled:true,
                //         context: context,
                //         builder: (BuildContext bc) {
                //           return CreateAudienceAdvert(
                //             refresh: () {
                //               Timer(Duration(seconds: 2), () {
                //                 getAudienceData();
                //               });
                //             },

                //             memberName: CurrentUser().currentUser.fullName,
                //             memberImage: CurrentUser().currentUser.image,
                //             //  feed: widget.feed,
                //             logo: CurrentUser().currentUser.logo,
                //             country: CurrentUser().currentUser.country,
                //             memberID: CurrentUser().currentUser.memberID!,
                //           );
                //         });
                //   },
                //   child: Container(
                //     color: Colors.transparent,
                //     child: Padding(
                //       padding: EdgeInsets.only(
                //           left: 2.0.w, top: 1.0.h, right: 1.0.w),
                //       child: Text(
                //         AppLocalizations.of(
                //           "Create new audience",
                //         ),
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: primaryBlueColor,
                //             fontSize: 12),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                  child: Text(
                    AppLocalizations.of(
                      "Total Budget",
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                  child: Text(
                    "\$ " + _value.toString() + ".00",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 25),
                  ),
                ),
                Container(
                  child: Slider(
                    inactiveColor: Colors.grey,
                    activeColor: primaryBlueColor,
                    min: 1,
                    divisions: division,
                    max: 1000,
                    value: _value.toDouble(),
                    onChanged: (value) {
                      if (value.toInt() < 10) {
                        setState(() {
                          division = 1000;
                        });
                      } else if (value.toInt() < 13) {
                        setState(() {
                          division = 500;
                        });
                      } else if (value.toInt() < 15 && value.toInt() > 13) {
                        setState(() {
                          division = 1000;
                        });
                      } else if (value.toInt() >= 15 && value.toInt() < 29) {
                        setState(() {
                          division = 200;
                        });
                      } else if (value.toInt() > 29 && value.toInt() < 79) {
                        setState(() {
                          division = 100;
                        });
                      } else if (value.toInt() > 79 && value.toInt() < 119) {
                        setState(() {
                          division = 50;
                        });
                      } else if (value.toInt() > 119 && value.toInt() < 199) {
                        setState(() {
                          division = 20;
                        });
                      } else if (value.toInt() > 199 && value.toInt() < 299) {
                        setState(() {
                          division = 10;
                        });
                      } else if (value.toInt() > 299 && value.toInt() < 499) {
                        setState(() {
                          division = 5;
                        });
                      } else if (value.toInt() > 499 && value.toInt() < 999) {
                        setState(() {
                          division = 2;
                        });
                      }

                      String maxVal =
                          ((value.toInt() * 1400) / days).toStringAsFixed(0);
                      String newMax = "";
                      for (int i = 0; i < maxVal.length; i++) {
                        if ((i) % 3 == 0 && i != 0) {
                          newMax += ",";
                        }
                        newMax += maxVal[maxVal.length - i - 1];
                      }
                      String minVal =
                          ((_value.toInt() * 50) / days).toStringAsFixed(0);
                      String newMin = "";
                      for (int i = 0; i < minVal.length; i++) {
                        if ((i) % 3 == 0 && i != 0) {
                          newMin += ",";
                        }
                        newMin += minVal[minVal.length - i - 1];
                      }
                      setState(() {
                        minReach = newMin.split('').reversed.join();
                        maxReach = newMax.split('').reversed.join();
                        _value = value.toInt();
                      });
                    },
                  ),
                ),
                // Container(
                //   child: Slider(
                //     inactiveColor: Colors.grey,
                //     activeColor: primaryBlueColor,
                //     min: 1,
                //     divisions: division,
                //     max: 1000,
                //     value: _value.toDouble(),
                //     onChanged: (value) {
                //       if (value.toInt() < 10) {
                //         setState(() {
                //           division = 1000;
                //         });
                //       } else if (value.toInt() < 13) {
                //         setState(() {
                //           division = 500;
                //         });
                //       } else if (value.toInt() < 15 && value.toInt() > 13) {
                //         setState(() {
                //           division = 1000;
                //         });
                //       } else if (value.toInt() >= 15 && value.toInt() < 29) {
                //         setState(() {
                //           division = 200;
                //         });
                //       } else if (value.toInt() > 29 && value.toInt() < 79) {
                //         setState(() {
                //           division = 100;
                //         });
                //       } else if (value.toInt() > 79 && value.toInt() < 119) {
                //         setState(() {
                //           division = 50;
                //         });
                //       } else if (value.toInt() > 119 && value.toInt() < 199) {
                //         setState(() {
                //           division = 20;
                //         });
                //       } else if (value.toInt() > 199 && value.toInt() < 299) {
                //         setState(() {
                //           division = 10;
                //         });
                //       } else if (value.toInt() > 299 && value.toInt() < 499) {
                //         setState(() {
                //           division = 5;
                //         });
                //       } else if (value.toInt() > 499 && value.toInt() < 999) {
                //         setState(() {
                //           division = 2;
                //         });
                //       }

                //       String maxVal =
                //           ((value.toInt() * 1400) / days).toStringAsFixed(0);
                //       String newMax = "";
                //       for (int i = 0; i < maxVal.length; i++) {
                //         if ((i) % 3 == 0 && i != 0) {
                //           newMax += ",";
                //         }
                //         newMax += maxVal[maxVal.length - i - 1];
                //       }
                //       String minVal =
                //           ((_value.toInt() * 50) / days).toStringAsFixed(0);
                //       String newMin = "";
                //       for (int i = 0; i < minVal.length; i++) {
                //         if ((i) % 3 == 0 && i != 0) {
                //           newMin += ",";
                //         }
                //         newMin += minVal[minVal.length - i - 1];
                //       }
                //       setState(() {
                //         minReach = newMin.split('').reversed.join();
                //         maxReach = newMax.split('').reversed.join();
                //         _value = value.toInt();
                //       });
                //     },
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w, top: 1.0.h),
                  child: Text(
                    AppLocalizations.of(
                      "Estimated people reached",
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 14),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                  child: Text(
                    minReach +
                        " " +
                        AppLocalizations.of(
                          "views per day",
                        ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w, vertical: 1.0.h),
                    child: Stack(
                      children: [
                        Container(
                          color: primaryBlueColor.withOpacity(0.2),
                          height: 5,
                        ),
                        Container(
                          color: primaryBlueColor,
                          height: 5,
                          width: 10.0.w,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 1.0.h,
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 2.0.w,
                  ),
                  child: Text(
                    AppLocalizations.of(
                      "Payment",
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                  child: Text(
                    AppLocalizations.of(
                      "Payment Method",
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.w, top: 1.0.h),
                  child: Text(
                    AppLocalizations.of(
                          "Available balance",
                        ) +
                        " (\$${walletBalance.toString()} USD)",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 15),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 4.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_daysController.text.isEmpty) {
                            ScaffoldMessenger.of(
                                    widget.sKey!.currentState!.context)
                                .showSnackBar(showSnackBar(AppLocalizations.of(
                                    'Please select a duration')));
                          } else {
                            boostPost();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryBlueColor)),
                        child: Text(
                          AppLocalizations.of(
                            "Upgrade",
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
