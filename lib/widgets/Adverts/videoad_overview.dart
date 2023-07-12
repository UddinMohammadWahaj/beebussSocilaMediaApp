import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/Adverts/video_advert.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/view_resuts_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:http/http.dart' as http;

import 'edit_banner_ad.dart';

class People {
  final String range;
  final int value;

  People(this.range, this.value);
}

class Placement {
  final String title;
  final int value;

  Placement(this.title, this.value);
}

class VideoAdsOverview extends StatefulWidget {
  // final List<String> bannerImages;

  final String? dataID;

  VideoAdsOverview({
    Key? key,
    this.dataID,

    // this.bannerImages
  }) : super(key: key);

  @override
  _VideoAdsOverviewState createState() => _VideoAdsOverviewState();
}

class _VideoAdsOverviewState extends State<VideoAdsOverview> {
  bool areResultsLoaded = false;

  var spentAmount;
  var clicks;
  late int intClicks;
  var reach;
  var perClickCost;
  var days;
  var status;
  var objective;
  var totalBudget;
  var duration;
  var endDate;
  var creationDate;
  var createdBy;
  var availableBalance;
  var locationsBoosted;
  var audienceName;
  var age;
  var audienceId;
  var resp;

  bool peopleButton = true;
  bool placementsButton = false;
  bool locationsButton = false;

  String people = "People";
  String placements = "Placements";
  String locations = "Locations";
  late String selectedAudience;

  late int totalMaleFrom1317;
  late int totalMaleFrom1824;
  late int totalMaleFrom2534;
  late int totalMaleFrom3544;
  late int totalMaleFrom4554;
  late int totalMaleFrom5564;
  late int totalMaleFrom65;
  late int totalFemaleFrom1317;
  late int totalFemaleFrom1824;
  late int totalFemaleFrom2534;
  late int totalFemaleFrom3544;
  late int totalFemaleFrom4554;
  late int totalFemaleFrom5564;
  late int totalFemaleFrom65;

  late int newsFeedPercentage;
  late int blogbuzPercentage;
  late int hashtagPercentage;
  late int relatedBlogPercentage;
  late int postDetailsPercentage;
  late int peopleImagesPercentage;

  late List<charts.Series> peopleList;
  late List<charts.Series> placementList;

  Future<void> getResults() async {
    var url =
        "https://www.bebuzee.com/api/boost_post_status_video.php?action=boost_post_status_banner&user_id=${CurrentUser().currentUser.memberID}&data_id=${widget.dataID}";
    // var response = await http.get(url);
    print("get result video url=$url");
    var response = await ApiProvider().fireApi(url).then((value) => value);
    print('response of get result banner=${response.data}');
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          spentAmount = response.data['spent_amount'];
          clicks = response.data['total_links_click'];
          intClicks = response.data['link_clicks_int'];
          reach = response.data['total_reach'];
          perClickCost = response.data['cost_per_link'];
          days = response.data['days'];
          status = response.data['status_edit'];
          objective = response.data['objective'];
          totalBudget = response.data['budget'];
          duration = response.data['duration'];
          endDate = response.data['end_date'];
          creationDate = response.data['created'];
          createdBy = response.data['user_name'];
          availableBalance = response.data['wallet_balance'];
          locationsBoosted = response.data['chart_location_fn_val'];
          audienceName = response.data['audience_name'];
          age = response.data['age'];
          audienceId = response.data['audience_id'];

          totalMaleFrom1317 = response.data['total_male_from13_17'];
          totalMaleFrom1824 = response.data['total_male_from18_24'];
          totalMaleFrom2534 = response.data['total_male_from25_34'];
          totalMaleFrom3544 = response.data['total_male_from35_44'];
          totalMaleFrom4554 = response.data['total_male_from45_54'];
          totalMaleFrom5564 = response.data['total_male_from55_64'];
          totalMaleFrom65 = response.data['total_male_from65'];

          totalFemaleFrom1317 = response.data['total_female_from13_17'];
          totalFemaleFrom1824 = response.data['total_female_from18_24'];
          totalFemaleFrom2534 = response.data['total_female_from25_34'];
          totalFemaleFrom3544 = response.data['total_female_from35_44'];
          totalFemaleFrom4554 = response.data['total_female_from45_54'];
          totalFemaleFrom5564 = response.data['total_female_from55_64'];
          totalFemaleFrom65 = response.data['total_female_from65'];

          newsFeedPercentage = response.data['news_feed_percentage'];
          peopleImagesPercentage = response.data['people_images_percentage'];
          hashtagPercentage = response.data['hashtag_percentage'];
          postDetailsPercentage = response.data['post_details_percentage'];
          print("load success");
          peopleList = _createPeopleData();
          placementList = _createPlacementData();

          areResultsLoaded = true;
        });
      }
    }

    if (response.data == null || response.statusCode != 200) {
      setState(() {
        areResultsLoaded = false;
      });
    }
  }

  List<charts.Series<Placement, String>> _createPlacementData() {
    final blue = charts.MaterialPalette.blue.makeShades(1);
    final red = charts.MaterialPalette.red.makeShades(1);
    final green = charts.MaterialPalette.green.makeShades(1);
    final purple = charts.MaterialPalette.purple.makeShades(1);

    final placementData = [
      Placement('News Feed', newsFeedPercentage.toInt()),
      Placement('People Images', peopleImagesPercentage.toInt()),
      Placement('Display Hashtags', hashtagPercentage.toInt()),
      Placement('Post Views', postDetailsPercentage.toInt()),
    ];

    return [
      charts.Series<Placement, String>(
          id: 'Placements',
          domainFn: (Placement placements, _) => placements.title,
          measureFn: (Placement placements, _) => placements.value,
          labelAccessorFn: (Placement placements, _) =>
              '${placements.value.toString()}%',
          data: placementData,
          fillColorFn: (Placement placements, _) {
            switch (placements.title) {
              case "News Feed":
                {
                  return blue[1];
                }

              case "People Images":
                {
                  return red[1];
                }

              case "Display Hashtags":
                {
                  return purple[1];
                }

              case "Post Views":
                {
                  return green[1];
                }

              default:
                {
                  return red[0];
                }
            }
          }),
    ];
  }

  List<charts.Series<People, String>> _createPeopleData() {
    final menData = [
      People('13-17', totalMaleFrom1317),
      People('18-24', totalMaleFrom1824),
      People('25-34', totalMaleFrom2534),
      People('35-44', totalMaleFrom3544),
      People('45-54', totalMaleFrom4554),
      People('55-64', totalMaleFrom5564),
      People('65+', totalMaleFrom65),
    ];

    final womenData = [
      People('13-17', totalFemaleFrom1317),
      People('18-24', totalFemaleFrom1824),
      People('25-34', totalFemaleFrom2534),
      People('35-44', totalFemaleFrom3544),
      People('45-54', totalFemaleFrom4554),
      People('55-64', totalFemaleFrom5564),
      People('65+', totalFemaleFrom65),
    ];

    return [
      charts.Series<People, String>(
        id: 'People',
        domainFn: (People sales, _) => sales.range,
        measureFn: (People sales, _) => sales.value,
        labelAccessorFn: (People sales, _) =>
            '${sales.value} : ${sales.value.toString()}%',
        data: menData,
        fillColorFn: (People sales, _) {
          return charts.MaterialPalette.blue.shadeDefault;
        },
      ),
      charts.Series<People, String>(
        id: 'People',
        domainFn: (People sales, _) => sales.range,
        measureFn: (People sales, _) => sales.value,
        labelAccessorFn: (People sales, _) =>
            '${sales.value} : ${sales.value.toString()}%',
        data: womenData,
        fillColorFn: (People sales, _) {
          return charts.MaterialPalette.green.shadeDefault;
        },
      ),
    ];
  }

  barChartPeople() {
    return Container(
        height: 50.0.h,
        child: charts.BarChart(
          peopleList as List<charts.Series<dynamic, String>>,
          animate: true,
          vertical: true,

          barGroupingType: charts.BarGroupingType.grouped,
          defaultRenderer: charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped,
            strokeWidthPx: 1.0,
          ),
          // domainAxis: charts.OrdinalAxisSpec(
          //   renderSpec: charts.NoneRenderSpec(),
        ));
  }

  barChartPlacements() {
    return Container(
        height: 50.0.h,
        child: charts.BarChart(
          placementList as List<charts.Series<dynamic, String>>,
          animate: true,
          vertical: false,
          barRendererDecorator: charts.BarLabelDecorator(
              labelPosition: charts.BarLabelPosition.inside,
              labelAnchor: charts.BarLabelAnchor.end),

          // domainAxis: charts.OrdinalAxisSpec(
          //   renderSpec: charts.NoneRenderSpec(),
        ));
  }

  @override
  void initState() {
    setState(() {
      selectedAudience = people;
    });
    getResults();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: areResultsLoaded == true
          ? SingleChildScrollView(
              child: Container(
                width: 100.0.w,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5.0.h, bottom: 2.0.h, left: 2.0.h, right: 2.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                                  "Overview",
                                ),
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditVideoAd(
                                          dataID: widget.dataID!,
                                          audienceId: audienceId)));

                              print("edit");
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(
                                  width: 1.0.w,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    "Upgrade",
                                  ),
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Text(
                        AppLocalizations.of(
                          "Performance",
                        ),
                        style: blackBold,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(
                                  "You've spent" + " ",
                                ),
                              ),
                              TextSpan(text: spentAmount, style: blackBold),
                              TextSpan(text: " over "),
                              TextSpan(text: days + ".", style: blackBold)
                            ])),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LinkClicks(
                              title: AppLocalizations.of(
                                "Link Clicks",
                              ),
                              value: clicks,
                            ),
                            Reach(
                              reachTitle: AppLocalizations.of(
                                "Reach",
                              ),
                              reachValue: reach.toString(),
                              clickTitle: AppLocalizations.of(
                                "Costs per \n link click",
                              ),
                              clickValue: perClickCost,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Text(
                          AppLocalizations.of(
                            "Activity",
                          ),
                          style: blackBold,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                          child: Text(
                            AppLocalizations.of(
                              "Engagement on Bebuzee",
                            ),
                            style: blackBoldShaded.copyWith(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              AppLocalizations.of("Link Clicks"),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 8.0.h,
                                  width: 1.5,
                                  color: Colors.grey,
                                ),
                                Container(
                                  height: 6.0.h,
                                  width: 60.0.w,
                                  color: primaryBlueColor,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  intClicks.toString(),
                                  style: blackBoldShaded,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  "Reach more people",
                                ),
                                style: blackBold.copyWith(fontSize: 16),
                              ),
                              SizedBox(
                                height: 1.0.h,
                              ),
                              Text(
                                AppLocalizations.of(
                                  "This ad can reach more people in your audience when you add budget and duration",
                                ),
                                style: blackBoldShaded,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.5.h),
                                    child: Text(
                                      AppLocalizations.of(
                                        "Add more budget",
                                      ),
                                      style: blackBold.copyWith(
                                          color: primaryBlueColor),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                "Details",
                              ),
                              style: blackBold,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                        child: Column(
                          children: [
                            Details(
                              title: AppLocalizations.of(
                                "Status",
                              ),
                              value: status,
                              divider: true,
                            ),
                            Details(
                              title: AppLocalizations.of(
                                "Objective",
                              ),
                              value: objective,
                              divider: true,
                            ),
                            Details(
                              title: AppLocalizations.of(
                                "Total Budget",
                              ),
                              value: "\$" + totalBudget,
                              divider: true,
                            ),
                            Details(
                              title: AppLocalizations.of(
                                "Amount Spent",
                              ),
                              value: spentAmount,
                              divider: true,
                            ),
                            Details(
                              title: AppLocalizations.of(
                                "Duration",
                              ),
                              value: duration.toString() + " days",
                              divider: true,
                            ),
                            Details(
                              title: AppLocalizations.of(
                                "End Date",
                              ),
                              value: endDate,
                              divider: true,
                            ),
                            Details(
                              title: AppLocalizations.of(
                                "Date Created",
                              ),
                              value: creationDate,
                              divider: true,
                            ),
                            Details(
                              title: AppLocalizations.of(
                                "Created By",
                              ),
                              value: createdBy,
                              divider: true,
                            ),
                            Details(
                              title: AppLocalizations.of(
                                "Payment Method",
                              ),
                              value: AppLocalizations.of(
                                    "Available balance",
                                  ) +
                                  " (\$${availableBalance.toString()} USD)",
                              divider: true,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Text(
                          AppLocalizations.of(
                            "Audience",
                          ),
                          style: blackBold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(
                                      "This ad reache",
                                    ) +
                                    " ",
                              ),
                              TextSpan(text: reach, style: blackBold),
                              TextSpan(
                                text: " " +
                                    AppLocalizations.of(
                                      "people in your audience.",
                                    ),
                              ),
                            ])),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 30.0.w,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        peopleButton == true
                                            ? primaryBlueColor
                                            : Colors.white),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            side: BorderSide(
                                                color: Colors.grey)))),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(0.0),
                                //     side: BorderSide(color: Colors.grey)),
                                onPressed: () {
                                  setState(() {
                                    peopleButton = true;
                                    locationsButton = false;
                                    placementsButton = false;
                                    selectedAudience = people;
                                    print(selectedAudience);
                                  });
                                },
                                // color: peopleButton == true
                                //     ? primaryBlueColor
                                //     : Colors.white,
                                child: Text(
                                  people,
                                  style: TextStyle(
                                      color: peopleButton == true
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              width: 30.0.w,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        peopleButton == true
                                            ? primaryBlueColor
                                            : Colors.white),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            side: BorderSide(
                                                color: Colors.grey)))),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(0.0),
                                //     side: BorderSide(color: Colors.grey)),
                                onPressed: () {
                                  setState(() {
                                    peopleButton = false;
                                    locationsButton = false;
                                    placementsButton = true;
                                    selectedAudience = placements;
                                    print(selectedAudience);
                                  });
                                },
                                // color: placementsButton == true
                                //     ? primaryBlueColor
                                //     : Colors.white,
                                child: Text(
                                  placements,
                                  style: TextStyle(
                                      color: placementsButton == true
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              width: 30.0.w,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        locationsButton == true
                                            ? primaryBlueColor
                                            : Colors.white),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            side: BorderSide(
                                                color: Colors.grey)))),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(0.0),
                                //     side: BorderSide(color: Colors.grey)),
                                onPressed: () {
                                  setState(() {
                                    peopleButton = false;
                                    locationsButton = true;
                                    placementsButton = false;
                                    selectedAudience = locations;
                                    print(selectedAudience);
                                  });
                                },
                                // color: locationsButton == true
                                //     ? primaryBlueColor
                                //     : Colors.white,
                                child: Text(
                                  locations,
                                  style: TextStyle(
                                      color: locationsButton == true
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      peopleButton == true && areResultsLoaded == true
                          ? Column(children: [
                              barChartPeople(),
                              Padding(
                                padding: EdgeInsets.only(top: 1.5.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 7,
                                          backgroundColor: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 2.0.w,
                                        ),
                                        Text(
                                          AppLocalizations.of(
                                            "Men",
                                          ),
                                          style: blackBold,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 7,
                                          backgroundColor: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 2.0.w,
                                        ),
                                        Text(
                                          AppLocalizations.of(
                                            "Women",
                                          ),
                                          style: blackBold,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ])
                          : placementsButton == true
                              ? barChartPlacements()
                              : Container(),
                      Padding(
                        padding: EdgeInsets.only(top: 2.5.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppLocalizations.of("Audience Name"),
                                    style: blackBoldShaded),
                                Text(audienceName)
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Text(
                                AppLocalizations.of(
                                  "Location - Living In",
                                ),
                                style: blackBoldShaded),
                            Text(
                              locationsBoosted == null || locationsBoosted == ""
                                  ? ""
                                  : locationsBoosted,
                              style: TextStyle(color: Colors.grey),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    AppLocalizations.of(
                                      "Age",
                                    ),
                                    style: blackBoldShaded),
                                Text(age)
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0.h),
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
                                  "Close",
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: 3.0.w,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      primaryBlueColor)),

                              onPressed: () {},

                              // color: primaryBlueColor,
                              child: Text(
                                AppLocalizations.of(
                                  "Boost Another Post",
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
