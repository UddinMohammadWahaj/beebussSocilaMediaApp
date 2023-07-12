import 'dart:convert';
import 'dart:async';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/address_search_model.dart';
import 'package:bizbultest/models/audience_model.dart';
import 'package:bizbultest/models/personal_blog_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/promote_post_web_view.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/view/create_audience.dart';
import 'package:bizbultest/view/edit_audience.dart';
import 'package:bizbultest/widgets/audience_popup.dart';
import 'package:bizbultest/widgets/feed_single_video_player.dart';
import 'package:bizbultest/widgets/feeds_video_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as gett;

import 'package:sizer/sizer.dart';

import '../api/ApiRepo.dart' as ApiRepo;

class PromoteBlog extends StatefulWidget {
  final NewsFeedModel? feed;
  final String? memberID;
  final String? country;
  final String? logo;
  final String? memberName;
  final String? memberImage;
  final String? locationString;
  final int? minAge;
  final int? maxAge;
  final String? audienceName;
  final String? selectedGender;
  PersonalBlogModel? personalBlogs;

  PromoteBlog(
      {Key? key,
      this.personalBlogs,
      this.memberID,
      this.country,
      this.logo,
      this.feed,
      this.memberName,
      this.memberImage,
      this.locationString,
      this.minAge,
      this.maxAge,
      this.audienceName,
      this.selectedGender})
      : super(key: key);

  @override
  _PromoteBlogState createState() => _PromoteBlogState();
}

class _PromoteBlogState extends State<PromoteBlog> {
  late int value;
  List buttonList = [];
  var buttonString;
  var selectedButton;

  late int _value;
  late int days;
  bool showLocationList = false;
  TextEditingController _buttonLinkController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _couponController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late String minReach;
  late String maxReach;
  late int walletBalance;
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
  var isLoading = false;

  bool hasData = false;
  late int division;
  bool hasAudience = false;
  late String selectedAudienceId;

  late Addresses address;

  late Audiences audienceList;

  Future<void> getBoostData() async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/campaign/sponserPost?action=boost_post_home&user_id=${widget.memberID}&post_type=blog&country=${widget.country}&post_id=${widget.personalBlogs!.postId}');
    var client = Dio();
    print("getBoostedDataCalled url=${newurl}");

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

    // var response = await http.get(url);

    // print(jsonDecode(response.body)['post_button']);
    print("response of boosted-${response}");
    if (response.statusCode == 200) {
      setState(() {
        dataLoaded = true;
        walletBalance = response.data['data']['wallet_balance'];
        minReach = response.data['data']['min_reach'].toString();
        maxReach = response.data['data']['max_reach'].toString();
        days = response.data['data']['duration'];
        _daysController.text = response.data['data']['duration'].toString();
        _value = response.data['data']['budget'];
        buttonString = response.data['data']['post_button'];
        buttonList = buttonString.split("~").toList();
        selectedButton = buttonList[2];
        selectedDate = DateTime.now()
            .add(Duration(days: response.data['data']['duration']));
      });
    }

    // if (response.statusCode == 200) {
    //   setState(() {
    //     dataLoaded = true;
    //     walletBalance = jsonDecode(response.body)['wallet_balance'];
    //     minReach = jsonDecode(response.body)['min_reach'].toString();
    //     maxReach = jsonDecode(response.body)['max_reach'].toString();
    //     days = jsonDecode(response.body)['duration'];
    //     _daysController.text = jsonDecode(response.body)['duration'].toString();
    //     _value = jsonDecode(response.body)['budget'];
    //     buttonString = jsonDecode(response.body)['post_button'];
    //     buttonList = buttonString.split("~").toList();
    //     selectedButton = buttonList[2];
    //     selectedDate = DateTime.now()
    //         .add(Duration(days: jsonDecode(response.body)['duration']));
    //   });

    // }
  }

  Future<List> getLocationData(String search) async {

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/other/locationSuggestion?action=location_sugession&keywords=$search');
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
    // var response = await http.get(url);

    print('location data response=${response.data}');
    if (response.statusCode == 200) {
      Addresses addressDataData = Addresses.fromJson(response.data['data']);
      print(addressDataData.addresses[0].name);
      setState(() {
        address = addressDataData;
        hasData = true;
      });

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          hasData = false;
        });
      }
    }

    return address.addresses;
  }

  Future<void> getAudienceData() async {
    var response = await ApiProvider().fireApi(
        'https://www.bebuzee.com/api/campaign/audienceData?user_id=${CurrentUser().currentUser.memberID}');

    if (response.statusCode == 200) {
      print("audience data =${response.data}");
      setState(() {
        Audiences audienceData = Audiences.fromJson(response.data['data']);

        setState(() {
          print("audience success");
          audienceList = audienceData;
          hasAudience = true;
        });
      });
    }
  }

  Future<void> boostPost() async {
    var newurl =
        'https://www.bebuzee.com/api/save_boosted_data.php?user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.personalBlogs!.blogId}&ad_budget=${_value.toString()}';
    var client = Dio();
    print("clicked on boost");
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("boost member id=${CurrentUser().currentUser.memberID}");

    var exdtra = {
      "user_id": CurrentUser().currentUser.memberID,
      "post_id": widget.personalBlogs!.postId,
      "ad_duration": days.toString(),
      "audience_id": selectedAudienceId.toString(),
      "ad_budget": _value.toString(),
      "ad_button": selectedButton,
      "ad_url": _buttonLinkController.text,
      "title": urlTitle,
      "domain": urlDomain,
      "coupon_code": _couponController.text,
      "description": urlDescription,
      "post_type": widget.personalBlogs!.postType,
    };
    print("extra data=$exdtra");
    final response = await client.post(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
      queryParameters: exdtra,
    );

    if (response.statusCode == 200) {
      print('boost ${response.data}');
      if (response.data['data']['payment_method'] == 'wallet') {
        Navigator.of(context).pop();
        gett.Get.showSnackbar(gett.GetSnackBar(
          title: 'Success Payment',
          message: 'Successful payment',
          duration: Duration(seconds: 1),
          // titleText: Text('Success Payment!'),
          icon: Icon(Icons.money, color: Colors.green),
        ));

        return;
      }

      setState(() {
        paymentUrl = response.data['data']['url_data_paypal'];
        print("payment url=${response.data['data']['url_data_paypal']}");
        totalBudget = response.data['data']['total_budget'];
        adBudget = response.data['data']['ad_budget'];
        postID = response.data['data']['post_id'];
        dataID = response.data['data']['data_id'];
        isLoading = false;
      });
      Timer(Duration(seconds: 4), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PromotePostWebsiteView(
                    url: paymentUrl,
                    heading: "Payment",
                    memberID: widget.memberID,
                    adBudget: adBudget,
                    totalBudget: totalBudget,
                    dataID: dataID,
                    postID: postID)));
      });

      var url =
          "https://www.bebuzee.com/boost_post_success_mob.html?token=EC-4L345030KK7747324&PayerID=AH9MF2MEA62ZL";
      var start = "token=";
      var end = "&";

      final startIndex = url.indexOf(start);
      final endIndex = url.indexOf(end, startIndex + start.length);

      print(url.substring(startIndex + start.length, endIndex)); //

      var newString = url.substring(url.length - 13);
      print(newString);
    }
  }

  Future<void> getURL(String urls) async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/other/urlMetaData?user_id=${CurrentUser().currentUser.memberID}&url=$urls');
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

  late DateTime selectedDate;

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
    //print(widget.locationString + " is location");

    getBoostData();
    getAudienceData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
          )),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: dataLoaded == true
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0.h),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 1.0.h, bottom: 2.0.h, left: 2.0.h),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.keyboard_backspace,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              width: 3.0.w,
                            ),
                            Text(
                              AppLocalizations.of(
                                "Boost Post",
                              ),
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          NetworkImage(widget.memberImage!),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.memberName!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryBlueColor,
                                            fontFamily: "Helvetica Neue"),
                                      ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(
                                              "Sponsored",
                                            ),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: primaryBlueColor,
                                                fontFamily: "Helvetica Neue",
                                                fontSize: 13),
                                          ),
                                          Text(
                                            " ∙ ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: primaryBlueColor,
                                                fontFamily: "Helvetica Neue",
                                                fontSize: 13),
                                          ),
                                          Icon(
                                            Icons.public,
                                            size: 14,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxHeight: 50.0.h),
                                    child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      onPageChanged: (val) {
                                        setState(() {
                                          widget.feed!.pageIndex = val;
                                        });
                                      },
                                      itemCount: widget.personalBlogs!.image!
                                          .split("~~")
                                          .length,
                                      itemBuilder: (context, indexImage) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child:

                                              // widget.feed.postImgData
                                              //         .split('~~')[indexImage]
                                              //         .endsWith(".mp4")
                                              //     ? FeedsSingleVideoPlayer(
                                              //         image: widget.feed.postImgData
                                              //             .split('~~')[indexImage]
                                              //             ?.replaceAll(
                                              //                 ".mp4", ".jpg"),
                                              //         url: widget.feed.postImgData
                                              //             .split('~~')[indexImage],
                                              //       )
                                              //     :
                                              Image.network(
                                            widget.personalBlogs!.image!
                                                .split("~~")[indexImage],
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, top: 10, right: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  urlDomain != null && urlTitle != null
                                      ? Row(
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    showProfileButton == true
                                                        ? "bebuzee.com"
                                                        : urlDomain,
                                                    style: blackBoldShaded,
                                                  ),
                                                  Container(
                                                    width: 60.0.w,
                                                    child: Text(
                                                      showProfileButton == true
                                                          ? CurrentUser()
                                                              .currentUser
                                                              .fullName
                                                          : urlTitle,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : showProfileButton == true
                                          ? Row(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "bebuzee.com",
                                                        style: blackBoldShaded,
                                                      ),
                                                      Container(
                                                        width: 60.0.w,
                                                        child: Text(
                                                          CurrentUser()
                                                              .currentUser
                                                              .fullName!,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: 40.0.w - 20,
                                        decoration: new BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.rectangle,
                                          border: new Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            selectedButton,
                                            style: blackBold.copyWith(
                                                color: primaryBlueColor,
                                                fontSize: 10.0.sp),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0.w, vertical: 1.5.h),
                        child: Text(
                          AppLocalizations.of(
                            "POST BUTTON (Optional)",
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.0.w, top: 1.5.h),
                        child: Text(
                          AppLocalizations.of(
                            "Add a button to your post",
                          ),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.0.w),
                        child: Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: DropdownButton(
                              isExpanded: true,
                              //hint: Text("Select Category "),
                              items: buttonList.map((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedButton = val;

                                  if (selectedButton ==
                                      "Visit Bebuzee Profile") {
                                    setState(() {
                                      showProfileButton = true;
                                      _buttonLinkController.text =
                                          "https://www.bebuzee.com/${CurrentUser().currentUser.shortcode}";
                                    });
                                  } else {
                                    setState(() {
                                      showProfileButton = false;
                                      _buttonLinkController.text = "";
                                    });
                                  }
                                });

                                print(selectedButton);
                              },
                              value: selectedButton,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.0.w, top: 1.5.h),
                        child: Text(
                          AppLocalizations.of(
                            "Choose a link for this button",
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 2.0.w, top: 1.5.h, right: 2.0.w),
                        child: Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextFormField(
                              onTap: () {
                                setState(() {});
                              },
                              onChanged: (val) {
                                if (val != "") {
                                  getURL(val);
                                } else if (val == "") {
                                  setState(() {
                                    urlDomain = null;
                                    urlTitle = null;
                                  });
                                }
                              },
                              maxLines: 2,
                              controller: _buttonLinkController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryBlueColor, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: AppLocalizations.of(
                                  "Add a link",
                                ),

                                // 48 -> icon width
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.0.w, top: 1.5.h),
                        child: Text(
                          AppLocalizations.of(
                            "Choose the website address you'd like to send people to.",
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.0.w, bottom: 0),
                        child: Text(
                          AppLocalizations.of(
                            "AUDIENCE",
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      hasAudience == true
                          ? Column(
                              children: [
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: audienceList.audiences.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Container(
                                          width: 85.0.w,
                                          child: RadioListTile(
                                            dense: true,
                                            activeColor: primaryBlueColor,
                                            value: index,
                                            groupValue: value,
                                            onChanged: (int? ind) {
                                              setState(() {
                                                value = ind!;
                                                selectedAudienceId =
                                                    audienceList
                                                        .audiences[index]
                                                        .audienceId!;
                                                print(selectedAudienceId);
                                              });
                                            },
                                            title: Text(audienceList
                                                .audiences[index]
                                                .audienceName!),
                                            subtitle: Container(
                                              width: 85.0.w,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: audienceList
                                                          .audiences[index]
                                                          .audienceAgeData,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditAudience(
                                                          audienceId:
                                                              audienceList
                                                                  .audiences[
                                                                      index]
                                                                  .audienceId,
                                                          memberName: widget
                                                              .memberName!,
                                                          memberImage: widget
                                                              .memberImage!,
                                                          feed: widget.feed!,
                                                          logo: widget.logo!,
                                                          country:
                                                              widget.country!,
                                                          memberID:
                                                              widget.memberID!,
                                                        )));
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2.0.w),
                                              child: Text(
                                                AppLocalizations.of(
                                                  "Edit",
                                                ),
                                                style: TextStyle(
                                                    color: primaryBlueColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                    /*Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.w),
                                      child: Container(
                                        width: 98.0.w,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(width: 85.0.w, child: Text(audienceList.audiences[index].audienceName)),
                                                    SizedBox(
                                                      height: 1.0.w,
                                                    ),
                                                    Container(
                                                      width: 85.0.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Locations - Living In ',
                                                              style: TextStyle(
                                                                color: Colors.black.withOpacity(0.5),
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: audienceList.audiences[index].audienceLocation.replaceAll(';', ", "),
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 1.0.w,
                                                    ),
                                                    Container(
                                                      width: 85.0.w,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: audienceList.audiences[index].audienceAgeData,
                                                              style: TextStyle(color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => EditAudience(
                                                                  audienceId: audienceList.audiences[index].audienceId,
                                                                  memberName: widget.memberName,
                                                                  memberImage: widget.memberImage,
                                                                  feed: widget.feed,
                                                                  logo: widget.logo,
                                                                  country: widget.country,
                                                                  memberID: widget.memberID,
                                                                )));
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 2.0.w),
                                                      child: Text(
                                                        "Edit",
                                                        style: TextStyle(color: primaryBlueColor),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Divider(
                                              thickness: 0.5,
                                            )
                                          ],
                                        ),
                                      ),
                                    );*/
                                  },
                                ),
                              ],
                            )
                          : Container(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateAudience(
                                      memberName: widget.memberName!,
                                      memberImage: widget.memberImage!,
                                      // feed: widget.feed,
                                      logo: widget.logo!,
                                      country: widget.country!,
                                      memberID: widget.memberID!,
                                      refresh: () {
                                        Timer(Duration(seconds: 2), () {
                                          getAudienceData();
                                        });
                                      })));
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 2.0.w, top: 1.0.h, right: 1.0.w),
                            child: Text(
                              AppLocalizations.of(
                                "Create new audience",
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryBlueColor,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
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
                            "DURATION AND BUDGET",
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.0.w, vertical: 2.0.h),
                        child: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: new Border(
                              top: BorderSide(color: Colors.grey, width: 1),
                              bottom: BorderSide(color: Colors.grey, width: 1),
                              left: BorderSide(
                                  color: Colors.yellow.shade700, width: 3),
                              right: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  CustomIcons.warning,
                                  color: Colors.yellow.shade700,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 2.0.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        "Increase the duration",
                                      ),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.0.h),
                                      child: Container(
                                        width: 70.0.w,
                                        child: Text(
                                          AppLocalizations.of(
                                            "Ads that run for at least 4 days tend to get better results.",
                                          ),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0.w, vertical: 1.0.h),
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
                                      onTap: () {
                                        setState(() {});
                                      },
                                      onChanged: (val) {
                                        if (val.length > 0 &&
                                            int.tryParse(val) != null) {
                                          setState(() {
                                            days = int.parse(val);
                                            selectedDate = DateTime.now().add(
                                                Duration(days: int.parse(val)));

                                            String maxVal =
                                                ((_value.toInt() * 1400) / days)
                                                    .toStringAsFixed(0);
                                            String newMax = "";
                                            for (int i = 0;
                                                i < maxVal.length;
                                                i++) {
                                              if ((i) % 3 == 0 && i != 0) {
                                                newMax += ",";
                                              }
                                              newMax +=
                                                  maxVal[maxVal.length - i - 1];
                                            }
                                            String minVal =
                                                ((_value.toInt() * 480) / days)
                                                    .toStringAsFixed(0);
                                            String newMin = "";
                                            for (int i = 0;
                                                i < minVal.length;
                                                i++) {
                                              if ((i) % 3 == 0 && i != 0) {
                                                newMin += ",";
                                              }
                                              newMin +=
                                                  minVal[minVal.length - i - 1];
                                            }
                                            setState(() {
                                              minReach = newMin
                                                  .split('')
                                                  .reversed
                                                  .join();
                                              maxReach = newMax
                                                  .split('')
                                                  .reversed
                                                  .join();
                                            });
                                          });
                                        }
                                      },
                                      maxLines: 1,
                                      controller: _daysController,
                                      keyboardType: TextInputType.number,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 2.0.w),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryBlueColor,
                                              width: 1.0),
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
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    "End Date",
                                  ),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  width: 1.0.w,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      print("${selectedDate.toLocal()}"
                                          .split(' ')[0]);

                                      _selectDate(context);
                                    },
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border: new Border.all(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.0.w,
                                              vertical: 0.5.w),
                                          child: Row(
                                            children: [
                                              Text(
                                                selectedDate
                                                        .toLocal()
                                                        .toString()
                                                        .split(' ')[0]
                                                        .split("-")[2] +
                                                    "-" +
                                                    selectedDate
                                                        .toLocal()
                                                        .toString()
                                                        .split(' ')[0]
                                                        .split("-")[1] +
                                                    "-" +
                                                    selectedDate
                                                        .toLocal()
                                                        .toString()
                                                        .split(' ')[0]
                                                        .split("-")[0],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 1.0.w,
                                              ),
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                              )
                                            ],
                                          ),
                                        ))),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                            } else if (value.toInt() < 15 &&
                                value.toInt() > 13) {
                              setState(() {
                                division = 1000;
                              });
                            } else if (value.toInt() >= 15 &&
                                value.toInt() < 29) {
                              setState(() {
                                division = 200;
                              });
                            } else if (value.toInt() > 29 &&
                                value.toInt() < 79) {
                              setState(() {
                                division = 100;
                              });
                            } else if (value.toInt() > 79 &&
                                value.toInt() < 119) {
                              setState(() {
                                division = 50;
                              });
                            } else if (value.toInt() > 119 &&
                                value.toInt() < 199) {
                              setState(() {
                                division = 20;
                              });
                            } else if (value.toInt() > 199 &&
                                value.toInt() < 299) {
                              setState(() {
                                division = 10;
                              });
                            } else if (value.toInt() > 299 &&
                                value.toInt() < 499) {
                              setState(() {
                                division = 5;
                              });
                            } else if (value.toInt() > 499 &&
                                value.toInt() < 999) {
                              setState(() {
                                division = 2;
                              });
                            }

                            String maxVal = ((value.toInt() * 1400) / days)
                                .toStringAsFixed(0);
                            String newMax = "";
                            for (int i = 0; i < maxVal.length; i++) {
                              if ((i) % 3 == 0 && i != 0) {
                                newMax += ",";
                              }
                              newMax += maxVal[maxVal.length - i - 1];
                            }
                            String minVal = ((value.toInt() * 480) / days)
                                .toStringAsFixed(0);
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
                              "-" +
                              maxReach +
                              " " +
                              AppLocalizations.of(
                                "people per day",
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
                            "Apply Coupon",
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 2.0.w, top: 1.0.h, right: 2.0.w),
                        child: Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextFormField(
                              onTap: () {
                                setState(() {});
                              },
                              maxLines: 1,
                              controller: _couponController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryBlueColor, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                hintText: AppLocalizations.of(
                                  "Enter your coupon code",
                                ),

                                // 48 -> icon width
                              ),
                            ),
                          ),
                        ),
                      ),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
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
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0.h, horizontal: 2.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          side:
                                              BorderSide(color: Colors.grey))),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(0.0),
                              //     side: BorderSide(color: Colors.grey)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              // color: Colors.white,
                              child: Text(
                                AppLocalizations.of(
                                  "Cancel",
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: 3.0.w,
                            ),
                            !isLoading
                                ? ElevatedButton(
                                    onPressed: () {
                                      if (selectedButton == null ||
                                          selectedButton == "") {
                                        ScaffoldMessenger.of(_scaffoldKey
                                                .currentState!.context)
                                            .showSnackBar(showSnackBar(
                                                AppLocalizations.of(
                                                    'Please add a button')));
                                      } else if (_buttonLinkController
                                          .text.isEmpty) {
                                        ScaffoldMessenger.of(_scaffoldKey
                                                .currentState!.context)
                                            .showSnackBar(showSnackBar(
                                                AppLocalizations.of(
                                                    'Please add a link for the button')));
                                      } else if (audienceList
                                          .audiences.isEmpty) {
                                        ScaffoldMessenger.of(_scaffoldKey
                                                .currentState!.context)
                                            .showSnackBar(showSnackBar(
                                                AppLocalizations.of(
                                                    'Please create an audience')));
                                      } else if (selectedAudienceId == "" ||
                                          selectedAudienceId == null) {
                                        ScaffoldMessenger.of(_scaffoldKey
                                                .currentState!.context)
                                            .showSnackBar(showSnackBar(
                                                AppLocalizations.of(
                                                    'Please select atleast audience from your audiences')));
                                      } else if (_daysController.text.isEmpty) {
                                        ScaffoldMessenger.of(_scaffoldKey
                                                .currentState!.context)
                                            .showSnackBar(showSnackBar(
                                                AppLocalizations.of(
                                                    'Please select a duration')));
                                      } else {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        boostPost();

                                        print("ad budget is " +
                                            _value.toString());

                                        // Timer(Duration(seconds: 4), () {
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               PromoteBlogWebsiteView(
                                        //                   url: paymentUrl,
                                        //                   heading: "Payment",
                                        //                   memberID: widget.memberID,
                                        //                   adBudget: adBudget,
                                        //                   totalBudget: totalBudget,
                                        //                   dataID: dataID,
                                        //                   postID: postID)
                                        //                   ));
                                        // });

                                        // var url =
                                        //     "https://www.bebuzee.com/boost_post_success_mob.html?token=EC-4L345030KK7747324&PayerID=AH9MF2MEA62ZL";
                                        // var start = "token=";
                                        // var end = "&";

                                        // final startIndex = url.indexOf(start);
                                        // final endIndex = url.indexOf(
                                        //     end, startIndex + start.length);

                                        // print(url.substring(
                                        //     startIndex + start.length, endIndex)); //

                                        // var newString =
                                        //     url.substring(url.length - 13);
                                        // print(newString);
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                primaryBlueColor)),
                                    child: Text(
                                      AppLocalizations.of(
                                        "Boost",
                                      ),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : loadingAnimation(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              child: Center(child: loadingAnimation()),
            ),
    );
  }
}

class LocationsList extends StatefulWidget {
  final String? location;
  final String? formattedLocation;
  final VoidCallback? onPress;

  LocationsList({Key? key, this.location, this.formattedLocation, this.onPress})
      : super(key: key);

  @override
  _LocationsListState createState() => _LocationsListState();
}

class _LocationsListState extends State<LocationsList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress ?? () {},
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(1.0.w),
          child: Row(
            children: [
              Icon(
                CustomIcons.pointer,
                size: 20,
              ),
              SizedBox(
                width: 1.0.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 80.0.w, child: Text(widget.location!)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 80.0.w,
                          child: Text(widget.formattedLocation!)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
