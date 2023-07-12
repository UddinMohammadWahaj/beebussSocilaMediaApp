import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/address_search_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';

import 'package:bizbultest/view/create_audience.dart';
import 'package:bizbultest/widgets/audience_popup.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../api/api.dart';

class EditBoost extends StatefulWidget {
  final NewsFeedModel? feed;
  final String? memberID;
  final String? country;
  final String? logo;
  final String? memberName;
  final String? memberImage;
  final String? boostID;

  EditBoost(
      {Key? key,
      this.memberID,
      this.country,
      this.logo,
      this.feed,
      this.memberName,
      this.memberImage,
      this.boostID})
      : super(key: key);

  @override
  _EditBoostState createState() => _EditBoostState();
}

class _EditBoostState extends State<EditBoost> {
  List buttonList = [];
  var buttonString;
  var selectedButton;
  var selectedMinAge;
  var selectedMaxAge;
  late int _value;
  late int days;
  bool showLocationList = false;
  TextEditingController _buttonLinkController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _couponController = TextEditingController();

  late String minReach;
  late String maxReach;
  late int walletBalance;
  bool dataLoaded = false;
  String all = "All";
  String men = "Men";
  String women = "Women";
  late String selectedGender;

  bool allButton = true;
  bool menButton = false;
  bool womenButton = false;

  bool hasData = false;
  late int division;

  var minAgeList = new List<int>.generate(65, (i) => i + 1);
  var maxAgeList = new List<int>.generate(65, (i) => i + 1);

  late Addresses address;

  Future<void> getBoostData() async {
    var url =
        "https://www.bebuzee.com/api/boost_post_home_edit.php?action=boost_post_home_edit&user_id=${widget.memberID}&post_type=${widget.feed!.postType}&country=${widget.country}&post_id=${widget.feed!.postId}&boost_id=${widget.boostID}";
    // var response = await http.get(url);
    print("url of sponsor=${url}");
    var response = await ApiProvider().fireApi(url).then((value) => value);
    //print(response.body);
    print(response.data['data']['post_button']);

    if (response.statusCode == 200) {
      setState(() {
        dataLoaded = true;
        walletBalance = response.data['data']['wallet_balance'];
        minReach = response.data['data']['min_reach'].toString();
        maxReach = response.data['data']['max_reach'].toString();
        days = response.data['data']['duration'];
        _daysController.text = response.data['data']['duration'].toString();
        _value = int.parse(response.data['data']['budget']);
        buttonString = response.data['data']['post_button'];
        buttonList = buttonString.split("~").toList();
        selectedButton = buttonList[2];
        selectedDate = DateTime.now()
            .add(Duration(days: response.data['data']['duration']));
      });
    }
  }

  Future<List> getLocationData(String search) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_all_boosted.php?action=location_sugession&keywords=$search");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      Addresses addressDataData = Addresses.fromJson(jsonDecode(response.body));
      print(addressDataData.addresses[0].name);
      setState(() {
        address = addressDataData;
        hasData = true;
      });

      if (response.body == null || response.statusCode != 200) {
        setState(() {
          hasData = false;
        });
      }
    }

    return address.addresses;
  }

  late DateTime selectedDate;

  Future<void> _selectDate(BuildContext context) async {
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
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });*/
    print(minAgeList);
    getBoostData();

    setState(() {
      selectedGender = all;
      selectedMinAge = 18;
      selectedMaxAge = 65;
    });

    print(selectedDate);

    print(widget.feed!.postId);
    print(widget.memberID);
    print(widget.feed!.postType);
    print(widget.country);

    // print(buttonString);
    print(widget.feed!.postId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            top: 3.0.h, bottom: 2.0.h, left: 2.0.h),
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
                                "Edit Boost",
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
                          widget.feed!.postType == "Image" ||
                                  widget.feed!.postType == "blog"
                              ? Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxHeight: 70.0.h),
                                          child: PageView.builder(
                                            scrollDirection: Axis.horizontal,
                                            onPageChanged: (val) {
                                              setState(() {
                                                widget.feed!.pageIndex = val;
                                              });
                                            },
                                            itemCount: widget.feed!.postImgData!
                                                .split("~~")
                                                .length,
                                            itemBuilder: (context, indexImage) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Image.network(
                                                  widget.feed!.postImgData!
                                                      .split("~~")[indexImage],
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      widget.feed!.postMultiImage == 1
                                          ? Positioned.fill(
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: widget
                                                        .feed!.postImgData!
                                                        .split("~~")
                                                        .map((e) {
                                                      var ind = widget
                                                          .feed!.postImgData!
                                                          .split("~~")
                                                          .indexOf(e);
                                                      return Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        child: CircleAvatar(
                                                          radius: 4,
                                                          backgroundColor: widget
                                                                      .feed!
                                                                      .pageIndex ==
                                                                  ind
                                                              ? Colors.white
                                                              : Colors.grey
                                                                  .withOpacity(
                                                                      0.6),
                                                        ),
                                                      );
                                                    }).toList()),
                                              ),
                                            )
                                          : Container(),
                                      widget.feed!.postMultiImage == 1
                                          ? Positioned.fill(
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Image.asset(
                                                      "assets/images/multiple.png",
                                                      height: 2.0.h,
                                                    ),
                                                  )),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.0.w, vertical: 1.0.h),
                            child: Text(
                              widget.feed!.postContent!,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
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
                          min: 0,
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
                            print(
                                "maxval=${(value.toInt() * 1400)} days=${days}");
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
                              print("minReach $newMin");

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
                      Padding(
                        padding: EdgeInsets.only(left: 2.0.w, top: 1.0.h),
                        child: Text(
                            AppLocalizations.of(
                              "Refine your audience or add budget to reach more of the people who matter to you.",
                            ),
                            style: greyNormal.copyWith(fontSize: 14)),
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
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        side: BorderSide(color: Colors.grey)),
                                  )),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(
                                  "Close",
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: 3.0.w,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      primaryBlueColor)),
                              child: Text(
                                AppLocalizations.of(
                                  "Save",
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
          padding: EdgeInsets.all(1.0.h),
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
                  Text(widget.location!),
                  Text(widget.formattedLocation!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
