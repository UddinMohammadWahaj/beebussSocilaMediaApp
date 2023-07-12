import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Analytics/OverViewData.dart';
import 'package:bizbultest/models/Analytics/Revenue.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/Boomarks/seeMoreAnalytics.dart';
import 'package:bizbultest/view/Boomarks/seeMoreLinechart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class Analytics extends StatefulWidget {
  const Analytics({Key? key, this.postId}) : super(key: key);
  final postId;

  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int initialIndex = 0;

  late Revenue? revenueData;
  late OverViewData? overViewData;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
    _handleTabSelection();
  }

  num _currentIndex = 0;

  _handleTabSelection() {
    // setState(() {
    _currentIndex = _tabController.index;
    if (_currentIndex == 0) {
      setState(() {
        overViewData = null;
      });
      _getAnalyticsOverView();
    } else if (_currentIndex == 1) {
      setState(() {
        revenueData = null;
      });
      _getAnalyticsRevenue();
    }

    // });
  }

  Future<void> _getAnalyticsRevenue() async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_analytics_revenue.php");
    // var response = await http.post(
    //   url,
    //   body: {
    //     "user_id": "${CurrentUser().currentUser.memberID}",
    //     "from_date": date1?.toString() ?? "",
    //     "to_date": date2?.toString() ?? "",
    //     "post_id": widget.postId ?? "",
    //   },
    // );

    var sendData = {
      "user_id": "${CurrentUser().currentUser.memberID}",
      "from_date": date1?.toString() ?? "",
      "to_date": date2?.toString() ?? "",
      "post_id": widget.postId ?? "",
    };

    var response =
        await ApiRepo.postWithToken("api/analytics_revenue.php", sendData);
    if (response!.success == 1) {
      if (this.mounted) {
        setState(() {
          revenueData = Revenue.fromJson(response!.data['data']);
        });
      }
    }
  }

  Future<void> _getAnalyticsOverView() async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_analytics_overview.php");
    // var response = await http.post(
    //   url,
    //   body: {
    //     "user_id": "${CurrentUser().currentUser.memberID}",
    //     "from_date": date1?.toString() ?? "",
    //     "to_date": date2?.toString() ?? "",
    //     "post_id": widget.postId ?? "",
    //   },
    // );

    var sendData = {
      "user_id": "${CurrentUser().currentUser.memberID}",
      "from_date": date1?.toString() ?? "",
      "to_date": date2?.toString() ?? "",
      "post_id": widget.postId ?? "",
    };

    var response =
        await ApiRepo.postWithToken("api/analytics_overview.php", sendData);
    if (response!.success == 1) {
      if (this.mounted) {
        setState(() {
          overViewData = OverViewData.fromJson(response!.data["data"]);
        });
      }
    }
  }

  String dateRangeDropdownValue = AppLocalizations.of(
    'Last 7 days',
  );
  List<String> listOfData = [
    'Last 7 days',
    'Last 28 days',
    'Last 90 days',
    'Last 365 days',
    'Lifetime',
    'Custom',
  ];
  DateTime? date1 = DateTime.now().subtract(Duration(days: 7));
  DateTime? date2 = DateTime.now();

  getDateFrom(DateTime d1, DateTime d2) {
    date1 = d1;
    date2 = d2;
    print('.....$date1.............$date2');
  }

  onChangeDateRange() {
    date2 = DateTime.now();
    switch (dateRangeDropdownValue) {
      case 'Last 7 days':
        date1 = DateTime.now().subtract(Duration(days: 7));
        break;
      case 'Last 28 days':
        date1 = DateTime.now().subtract(Duration(days: 28));
        break;
      case 'Last 90 days':
        date1 = DateTime.now().subtract(Duration(days: 90));
        break;
      case 'Last 365 days':
        date1 = DateTime.now().subtract(Duration(days: 365));
        break;
      case 'Lifetime':
        date1 = null;
        date2 = null;
        break;
      case 'Custom':
        break;
    }
    _handleTabSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data:
            ThemeData(primarySwatch: primaryCustom, accentColor: kGoldenColor),
        // data: Theme.of(context).copyWith(),
        child: Builder(
          builder: (context) => Scaffold(
              appBar: AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.white)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dateRangeDropdownValue,
                          isExpanded: true,
                          onChanged: (String? newValue) async {
                            print('///${newValue}');
                            dateRangeDropdownValue = newValue!;
                            if (newValue == "Custom")
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DisplayDialog(
                                      getDateFrom: getDateFrom,
                                    );
                                  });
                            onChangeDateRange();
                            setState(() {});
                          },
                          items: listOfData.map((e) {
                            return DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                '$e',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                          dropdownColor: Theme.of(context).primaryColor,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                bottom: TabBar(
                  tabs: <Tab>[
                    Tab(
                      child: Text(
                        AppLocalizations.of(
                          "OverView",
                        ),
                        style: whiteBold.copyWith(fontSize: 10.0.sp),
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(
                          "Revenue",
                        ),
                        style: whiteBold.copyWith(fontSize: 10.0.sp),
                      ),
                    ),
                  ],
                  controller: _tabController,
                  onTap: (int index) {
                    print(index);

                    setState(() {
                      initialIndex = index;
                    });
                  },
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  overViewData == null
                      ? Container(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Overview(
                          overViewData: overViewData!,
                          postId: widget.postId,
                        ),
                  revenueData == null
                      ? Container(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : RevenueTab(
                          revenue: revenueData!,
                          postId: widget.postId,
                        ),
                ],
              )),
        ));
  }
}

class Overview extends StatefulWidget {
  final OverViewData overViewData;
  final String postId;
  Overview({
    Key? key,
    required this.overViewData,
    required this.postId,
  }) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview>
    with SingleTickerProviderStateMixin {
  late TabController _tabController1;
  int initialIndex = 0;
  late OverViewData overViewData;
  @override
  void initState() {
    overViewData = widget.overViewData;
    _tabController1 = new TabController(length: 4, vsync: this);

    super.initState();
  }

  List<int> printpoints(int nop, double startNum, double endNum) {
    List<int> numList = [];
    var qnop = nop - 1;
    var exnum = endNum - startNum;
    for (var i = 0; i < nop; i++) {
      var finalnum = ((exnum / qnop) * i) + startNum;
      numList.add(finalnum.round());
    }
    print("numList  :-> $numList");
    return numList;
  }

  late double viewMinY, viewMaxY, viewMinX, viewMaxX;
  late DateTime viewMinXDate, viewMaxXDate;
  List<int> viewDataYpointList = [];
  List<LineChartBarData> viewBarData =
      List<LineChartBarData>.empty(growable: true);

  void getViewlinebar() {
    var allValue = overViewData.graphViews!
        .map((e) => double.parse(e.value ?? "0"))
        .toList();
    allValue.sort((a, b) {
      return a.compareTo(b);
    });
    viewMinY = allValue?.first?.toDouble() ?? 0;
    viewMaxY = allValue?.last?.toDouble() ?? 0;

    var allDate =
        overViewData.graphViews!.map((e) => DateTime.parse(e.date!)).toList();
    allDate.sort((a, b) {
      return a.compareTo(b);
    });

    viewMinXDate = allDate.first;
    viewMaxXDate = allDate.last;
    viewMinX = 0;
    setState(() {
      viewMaxX = (allDate.last.difference(allDate.first).inDays + 1).toDouble();
    });
    viewDataYpointList =
        printpoints((viewMaxY % 2) == 0 ? 4 : 5, viewMinY, viewMaxY);
    // var newMap = groupBy(
    //   seeMoreAllData.graphData.map((e) {
    //     if (seeMoreAllData.geographyData?.any((element) => element.countryName == e.platform) ?? false) {
    //       var recordData = seeMoreAllData.geographyData.firstWhere((element) => element.countryName == e.platform);
    //       e.barColor = recordData.barColor;
    //     } else {
    //       e.barColor = Colors.black;
    //     }
    //     return e;
    //   }),
    //       (GraphData obj) => obj.platform,
    // );
    List<DateTime> allDisplayDates = List.generate(
        viewMaxX.toInt(), (index) => viewMinXDate.add(Duration(days: index)));
    overViewData.graphViews!.sort((a, b) {
      return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
    });
    viewBarData.clear();
    var barData = LineChartBarData(
      isCurved: true,
      colors: [Colors.black54],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 3,
          color: Colors.black,
          strokeWidth: 1,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(show: false),
      spots: overViewData.graphViews!
          .map(
            (e) => FlSpot(
              allDisplayDates
                  .indexWhere((element) => element == DateTime.parse(e.date!))
                  .toDouble(),
              num.parse(e.value ?? "0").toDouble(),
            ),
          )
          .toList(),
    );
    viewBarData.add(barData);
  }

  late double watchTimeMinY, watchTimeMaxY, watchTimeMinX, watchTimeMaxX;
  late DateTime watchTimeMinXDate, watchTimeMaxXDate;
  List<int> watchTimeDataYpointList = [];
  List<LineChartBarData> watchTimeData =
      List<LineChartBarData>.empty(growable: true);

  void getwatchTimelinebar() {
    var allValue = overViewData.graphWatchTime!
        .map((e) => double.parse(e.value ?? "0"))
        .toList();
    allValue.sort((a, b) {
      return a.compareTo(b);
    });
    watchTimeMinY = allValue?.first?.toDouble() ?? 0;
    watchTimeMaxY = allValue?.last?.toDouble() ?? 0;

    var allDate = overViewData.graphWatchTime!
        .map((e) => DateTime.parse(e.date!))
        .toList();
    allDate.sort((a, b) {
      return a.compareTo(b);
    });

    watchTimeMinXDate = allDate.first;
    watchTimeMaxXDate = allDate.last;
    watchTimeMinX = 0;
    watchTimeMaxX =
        (allDate.last.difference(allDate.first).inDays + 1).toDouble();

    viewDataYpointList = printpoints(
        (watchTimeMaxY % 2) == 0 ? 4 : 5, watchTimeMinY, watchTimeMaxY);

    List<DateTime> allDisplayDates = List.generate(watchTimeMaxX.toInt(),
        (index) => watchTimeMinXDate.add(Duration(days: index)));
    overViewData.graphWatchTime!.sort((a, b) {
      return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
    });
    watchTimeData.clear();
    var barData = LineChartBarData(
      isCurved: true,
      colors: [Colors.black54],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 3,
          color: Colors.black,
          strokeWidth: 1,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(show: false),
      spots: overViewData.graphWatchTime!
          .map(
            (e) => FlSpot(
              allDisplayDates
                  .indexWhere((element) => element == DateTime.parse(e.date!))
                  .toDouble(),
              num.parse(e.value ?? "0").toDouble(),
            ),
          )
          .toList(),
    );
    watchTimeData.add(barData);
    setState(() {});
  }

  late double followersMinY, followersMaxY, followersMinX, followersMaxX;
  late DateTime followersMinXDate, followersMaxXDate;
  List<int> followersDataYpointList = [];
  List<LineChartBarData> followersBarData =
      List<LineChartBarData>.empty(growable: true);

  void getfollowerslinebar() {
    var allValue = overViewData.graphFollowers!
        .map((e) => double.parse(e.value ?? "0"))
        .toList();
    allValue.sort((a, b) {
      return a.compareTo(b);
    });
    followersMinY = allValue?.first?.toDouble() ?? 0;
    followersMaxY = allValue?.last?.toDouble() ?? 0;

    var allDate = overViewData.graphFollowers!
        .map((e) => DateTime.parse(e.date!))
        .toList();
    allDate.sort((a, b) {
      return a.compareTo(b);
    });

    followersMinXDate = allDate.first;
    followersMaxXDate = allDate.last;
    followersMinX = 0;
    followersMaxX =
        (allDate.last.difference(allDate.first).inDays + 1).toDouble();

    viewDataYpointList = printpoints(
        (followersMaxY % 2) == 0 ? 4 : 5, followersMinY, followersMaxY);

    List<DateTime> allDisplayDates = List.generate(followersMaxX.toInt(),
        (index) => followersMinXDate.add(Duration(days: index)));
    overViewData.graphFollowers!.sort((a, b) {
      return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
    });
    followersBarData.clear();
    var barData = LineChartBarData(
      isCurved: true,
      colors: [Colors.black54],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 3,
          color: Colors.black,
          strokeWidth: 1,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(show: false),
      spots: overViewData.graphFollowers!
          .map(
            (e) => FlSpot(
              allDisplayDates
                  .indexWhere((element) => element == DateTime.parse(e.date!))
                  .toDouble(),
              num.parse(e.value ?? "0").toDouble(),
            ),
          )
          .toList(),
    );
    followersBarData.add(barData);
  }

  late double revenueMinY, revenueMaxY, revenueMinX, revenueMaxX;
  late DateTime revenueMinXDate, revenueMaxXDate;
  List<int> revenueDataYpointList = [];
  List<LineChartBarData> revenueBarData =
      List<LineChartBarData>.empty(growable: true);

  void getrevenuelinebar() {
    var allValue = overViewData.graphRevenue!
        .map((e) => double.parse(e.value ?? "0"))
        .toList();
    allValue.sort((a, b) {
      return a.compareTo(b);
    });
    revenueMinY = allValue?.first?.toDouble() ?? 0;
    revenueMaxY = allValue?.last?.toDouble() ?? 0;

    var allDate =
        overViewData.graphRevenue!.map((e) => DateTime.parse(e.date!)).toList();
    allDate.sort((a, b) {
      return a.compareTo(b);
    });

    revenueMinXDate = allDate.first;
    revenueMaxXDate = allDate.last;
    revenueMinX = 0;
    revenueMaxX =
        (allDate.last.difference(allDate.first).inDays + 1).toDouble();

    viewDataYpointList =
        printpoints((revenueMaxY % 2) == 0 ? 4 : 5, revenueMinY, revenueMaxY);

    List<DateTime> allDisplayDates = List.generate(revenueMaxX.toInt(),
        (index) => revenueMinXDate.add(Duration(days: index)));
    overViewData.graphRevenue!.sort((a, b) {
      return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
    });
    revenueBarData.clear();
    var barData = LineChartBarData(
      isCurved: true,
      colors: [Colors.black54],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 3,
          color: Colors.black,
          strokeWidth: 1,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(show: false),
      spots: overViewData.graphRevenue!
          .map(
            (e) => FlSpot(
              allDisplayDates
                  .indexWhere((element) => element == DateTime.parse(e.date!))
                  .toDouble(),
              num.parse(e.value ?? "0").toDouble(),
            ),
          )
          .toList(),
    );
    revenueBarData.add(barData);
  }

  @override
  Widget build(BuildContext context) {
    if (overViewData != null) {
      if (!overViewData.graphViews!.isNullorEmpty) getViewlinebar();
      if (!overViewData.graphWatchTime!.isNullorEmpty) getwatchTimelinebar();
      if (!overViewData.graphFollowers!.isNullorEmpty) getfollowerslinebar();
      if (!overViewData.graphRevenue!.isNullorEmpty) getrevenuelinebar();
    }
    return overViewData == null
        ? Container(
            child: Center(child: CircularProgressIndicator()),
          )
        : Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(
                          'Your channel got 6 views in the last 7 days.',
                        ),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: TabBar(
                      indicatorColor: primaryCustom,
                      controller: _tabController1,
                      tabs: <Tab>[
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  AppLocalizations.of(
                                    "Views",
                                  ),
                                  style: blackLight.copyWith(fontSize: 10.0.sp),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '${overViewData.views ?? 0}',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: blackBold.copyWith(
                                            fontSize: 12.0.sp),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  AppLocalizations.of(
                                    "Watch time",
                                  ),
                                  style: blackLight.copyWith(fontSize: 10.0.sp),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.watch_later_outlined,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '${overViewData.watchTime ?? 0}',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: blackBold.copyWith(
                                            fontSize: 12.0.sp),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  AppLocalizations.of(
                                    "Followers",
                                  ),
                                  style: blackLight.copyWith(fontSize: 10.0.sp),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_outline_outlined,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '${overViewData.followers ?? 0}',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: blackBold.copyWith(
                                            fontSize: 12.0.sp),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  "Revenue",
                                ),
                                style: blackLight.copyWith(fontSize: 10.0.sp),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '${overViewData.revenue ?? 0}',
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: blackBold.copyWith(
                                            fontSize: 12.0.sp),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 200,
                      child: TabBarView(
                        controller: _tabController1,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                if (!(overViewData?.graphViews?.isNullorEmpty ??
                                    true))
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1),
                                      color: Colors.black12,
                                    ),
                                    height: 180,
                                    width: double.infinity,
                                    //color: Colors.black12,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: ((viewMaxX ?? 1.0) * 15) >
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    45)
                                            ? ((viewMaxX ?? 1.0) * 15)
                                            : (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                45),
                                        child: LineChartWithData(
                                          lineBarsData: viewBarData,
                                          lCminX: viewMinX,
                                          lCmaxX: viewMaxX,
                                          lCminY: viewMinY - 1,
                                          lCmaxY: viewMaxY + 1,
                                          lCgetTitlesY: (value) {
                                            if (viewDataYpointList
                                                .contains(value)) {
                                              return value.toInt().toString();
                                            } else {
                                              return '';
                                            }
                                          },
                                          lCgetTitlesX: (value) {
                                            var d = viewMinXDate.add(
                                                Duration(days: value.toInt()));
                                            // if (d == viewMaxXDate || d == viewMinXDate) {
                                            //   return "${d.year}/${d.month < 10 ? '0' + d.month.toString() : d.month}/${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                            // }

                                            if (d.day == 1) {
                                              return "${d.year}/${d.month < 10 ? '0' + d.month.toString() : d.month}/${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                            } else {
                                              switch (d.day) {
                                                case 5:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 10:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 15:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 20:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 25:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                              }
                                            }

                                            return '';
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1),
                                      color: Colors.black12,
                                    ),
                                    child: Center(
                                        child: Text(
                                      AppLocalizations.of("no data to show"),
                                    )),
                                  )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                if (!(overViewData
                                        ?.graphWatchTime?.isNullorEmpty ??
                                    true))
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1),
                                      color: Colors.black12,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: ((watchTimeMaxX ?? 1.0) * 15) >
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    45)
                                            ? ((watchTimeMaxX ?? 1.0) * 15)
                                            : (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                45),
                                        child: LineChartWithData(
                                          lineBarsData: watchTimeData,
                                          lCminX: watchTimeMinX,
                                          lCmaxX: watchTimeMaxX,
                                          lCminY: watchTimeMinY - 1,
                                          lCmaxY: watchTimeMaxY + 1,
                                          lCgetTitlesY: (value) {
                                            if (viewDataYpointList
                                                .contains(value)) {
                                              return value.toInt().toString();
                                            } else {
                                              return '';
                                            }
                                          },
                                          lCgetTitlesX: (value) {
                                            var d = watchTimeMinXDate.add(
                                                Duration(days: value.toInt()));
                                            // if (d == watchTimeMaxXDate || d == watchTimeMinXDate) {
                                            //   return "${d.year}/${d.month < 10 ? '0' + d.month.toString() : d.month}/${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                            // }

                                            if (d.day == 1) {
                                              return "${d.year}/${d.month < 10 ? '0' + d.month.toString() : d.month}/${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                            } else {
                                              switch (d.day) {
                                                case 5:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 10:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 15:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 20:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 25:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                              }
                                            }
                                            return '';
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1),
                                      color: Colors.black12,
                                    ),
                                    child: Center(
                                        child: Text(
                                      AppLocalizations.of("no data to show"),
                                    )),
                                  )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                if (!(overViewData
                                        ?.graphFollowers?.isNullorEmpty ??
                                    true))
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1),
                                      color: Colors.black12,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: ((followersMaxX ?? 1.0) * 15) >
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    45)
                                            ? ((followersMaxX ?? 1.0) * 15)
                                            : (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                45),
                                        child: LineChartWithData(
                                          lineBarsData: followersBarData,
                                          lCminX: followersMinX,
                                          lCmaxX: followersMaxX,
                                          lCminY: followersMinY - 1,
                                          lCmaxY: followersMaxY + 1,
                                          lCgetTitlesY: (value) {
                                            if (viewDataYpointList
                                                .contains(value)) {
                                              return value.toInt().toString();
                                            } else {
                                              return '';
                                            }
                                          },
                                          lCgetTitlesX: (value) {
                                            var d = followersMinXDate.add(
                                                Duration(days: value.toInt()));
                                            //if (d == followersMaxXDate || d == followersMinXDate) {
                                            // return "${d.year}/${d.month < 10 ? '0' + d.month.toString() : d.month}/${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                            //}
                                            //
                                            //

                                            if (d.day == 1) {
                                              return "${d.year}/${d.month < 10 ? '0' + d.month.toString() : d.month}/${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                            } else {
                                              switch (d.day) {
                                                case 5:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 10:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 15:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 20:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 25:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                              }
                                            }
                                            return '';
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1),
                                      color: Colors.black12,
                                    ),
                                    child: Center(
                                        child: Text(
                                      AppLocalizations.of("no data to show"),
                                    )),
                                  )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                if (!(overViewData
                                        ?.graphRevenue?.isNullorEmpty ??
                                    true))
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1),
                                      color: Colors.black12,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: ((revenueMaxX ?? 1.0) * 15) >
                                                (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    45)
                                            ? ((revenueMaxX ?? 1.0) * 15)
                                            : (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                45),
                                        child: LineChartWithData(
                                          lineBarsData: revenueBarData,
                                          lCminX: revenueMinX,
                                          lCmaxX: revenueMaxX,
                                          lCminY: revenueMinY - 1,
                                          lCmaxY: revenueMaxY + 1,
                                          lCgetTitlesY: (value) {
                                            if (viewDataYpointList
                                                .contains(value)) {
                                              return value.toInt().toString();
                                            } else {
                                              return '';
                                            }
                                          },
                                          lCgetTitlesX: (value) {
                                            var d = revenueMinXDate.add(
                                                Duration(days: value.toInt()));
                                            // if (d == revenueMaxXDate || d == revenueMinXDate) {
                                            //   return "${d.year}/${d.month < 10 ? '0' + d.month.toString() : d.month}/${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                            // }

                                            if (d.day == 1) {
                                              return "${d.year}/${d.month < 10 ? '0' + d.month.toString() : d.month}/${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                            } else {
                                              switch (d.day) {
                                                case 5:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 10:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 15:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 20:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                                case 25:
                                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                                              }
                                            }
                                            return '';
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    height: 180,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1),
                                      color: Colors.black12,
                                    ),
                                    child: Center(
                                        child: Text(
                                      AppLocalizations.of("no data to show"),
                                    )),
                                  )
                              ],
                            ),
                          ),
                        ],
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SeeMore(
                                  postId: widget.postId,
                                )));
                      },
                      child: Text(
                        AppLocalizations.of(
                          'SEE MORE',
                        ),
                      )),
                  if (!(widget.postId != null && widget.postId != "")) ...[
                    Divider(
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(
                              "Your top videos in this period",
                            ),
                            style: blackLight.copyWith(fontSize: 14.0.sp),
                          ),
                          ...overViewData!.topVideo!
                              .map((e) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 3,
                                            spreadRadius: 1),
                                      ],
                                      color: Colors.white,
                                    ),
                                    margin: EdgeInsets.all(5),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Analytics(
                                                      postId: e.postId,
                                                    )));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            // Text("1"),
                                            // SizedBox(
                                            //   width: 5,
                                            // ),
                                            Container(
                                              height: 50,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                color: Colors.grey,
                                              ),
                                              child: e.videoVideo != null ||
                                                      e.videoVideo != ""
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                      child: Image.network(
                                                        "https://www.bebuzee.com/" +
                                                            e.videoVideo!,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Text(
                                                      AppLocalizations.of(
                                                          "Vido iamge"),
                                                    )),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${e.videoTitle}",
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "${e.totalTime} (${e.totalPer})"),
                                                      Text(
                                                        AppLocalizations.of(
                                                                "view") +
                                                            " ${e.totalViews}",
                                                        style:
                                                            blackLight.copyWith(
                                                                fontSize:
                                                                    14.0.sp),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))!
                              .toList(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SeeMore(
                                        postId: widget.postId,
                                      )));
                            },
                            child: Text(
                              AppLocalizations.of(
                                'SEE MORE',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
  }
}

class RevenueTab extends StatefulWidget {
  final Revenue revenue;
  final String? postId;
  RevenueTab({
    Key? key,
    required this.revenue,
    this.postId,
  }) : super(key: key);

  @override
  _RevenueTabState createState() => _RevenueTabState();
}

class _RevenueTabState extends State<RevenueTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Revenue revenueData;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    revenueData = widget.revenue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          TabBar(
            tabs: <Tab>[
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(
                        "Your estimated revenue",
                      ),
                      style: blackLight.copyWith(fontSize: 10.0.sp),
                    ),
                    Text(
                      "\$ ${revenueData?.estimatedRevenue ?? '0'}",
                      style: blackBold.copyWith(fontSize: 18.0.sp),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RPM",
                      style: blackLight.copyWith(fontSize: 10.0.sp),
                    ),
                    Text(
                      "\$ ${revenueData?.rPM ?? '0'}",
                      style: blackBold.copyWith(fontSize: 18.0.sp),
                    ),
                  ],
                ),
              ),
            ],
            controller: _tabController,
            onTap: (int index) {
              print(index);
            },
          ),
          SizedBox(
            height: 210,
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      if (!(revenueData.ghaphEstimatedRevenue!.isNullorEmpty ??
                          true))
                        Center(
                          child: LineChartRevenue(
                            revenue: revenueData,
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.grey[300],
                          child: Center(
                            child: Text(
                              AppLocalizations.of('no data for show'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            AppLocalizations.of('GrphView for RPM'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 20,
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                "Monthly estimated revenue",
                              ),
                              style: blackBold.copyWith(fontSize: 14.0.sp),
                            ),
                            Text(
                              AppLocalizations.of(
                                "Your estimated revenue · Last 6 months",
                              ),
                              style: blackLight.copyWith(fontSize: 10.0.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Column(
                          children: [
                            ...revenueData?.monthEstimatedRevenue
                                    ?.map((e) => Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${e.month}"),
                                              Text("\$ ${e.value}"),
                                            ],
                                          ),
                                        ))
                                    ?.toList()
                                    ?.expand(
                                        (element) => [element, Divider()]) ??
                                [],
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMore(
                                    postId: widget.postId,
                                  )));
                        },
                        child: Text(
                          AppLocalizations.of(
                            "See more",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 20,
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                "Revenue sources",
                              ),
                              style: blackBold.copyWith(fontSize: 14.0.sp),
                            ),
                            Text(
                              AppLocalizations.of(
                                "Your estimated revenue · Last 7 days",
                              ),
                              style: blackLight.copyWith(fontSize: 10.0.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: revenueData!.revenueSources != null &&
                                revenueData!.revenueSources!.isNotEmpty
                            ? Column(
                                children: revenueData!.revenueSources!
                                    .map(
                                      (e) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 3,
                                                spreadRadius: 1),
                                          ],
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(10),
                                        // margin: EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            // SizedBox(
                                            //   width: 5,
                                            // ),
                                            Expanded(
                                                child: Text(
                                              "${e.videoName}",
                                              maxLines: 3,
                                            )),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("\$ ${e.earning}"),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Text(
                                AppLocalizations.of(
                                  "Nothing to show for these dates",
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMore(
                                    postId: widget.postId,
                                  )));
                        },
                        child: Text(
                          AppLocalizations.of(
                            "See more",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 20,
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                "Top-earning videos",
                              ),
                              style: blackBold.copyWith(fontSize: 14.0.sp),
                            ),
                            Text(
                              AppLocalizations.of(
                                "Your estimated revenue · Last 7 days",
                              ),
                              style: blackLight.copyWith(fontSize: 10.0.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          child: revenueData!.topVideos != null &&
                                  revenueData!.topVideos!.isNotEmpty
                              ? Column(
                                  children: revenueData!.topVideos!
                                      .map(
                                        (e) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 3,
                                                  spreadRadius: 1),
                                            ],
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          // margin: EdgeInsets.all(5),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SeeMore(
                                                            postId: e.postId,
                                                          )));
                                            },
                                            child: Row(
                                              children: [
                                                // Text("1"),
                                                // SizedBox(
                                                //   width: 5,
                                                // ),
                                                Container(
                                                  height: 50,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                    color: Colors.grey,
                                                  ),
                                                  child: e.videoThumb != null ||
                                                          e.videoThumb != ""
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(5),
                                                          ),
                                                          child: Image.network(
                                                            "https://www.bebuzee.com/" +
                                                                e.videoThumb!,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      : Center(
                                                          child: Text(
                                                          AppLocalizations.of(
                                                              "Vido iamge"),
                                                        )),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  "${e.videoName}",
                                                  maxLines: 3,
                                                )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("\$ ${e.earning}"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                )
                              : Text(
                                  AppLocalizations.of(
                                    "Nothing to show for these dates",
                                  ),
                                )),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMore(
                                    postId: widget.postId,
                                  )));
                        },
                        child: Text(
                          AppLocalizations.of(
                            "See more",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 20,
                        spreadRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                "Ad types",
                              ),
                              style: blackBold.copyWith(fontSize: 14.0.sp),
                            ),
                            Text(
                              AppLocalizations.of(
                                "Bebuzee ad revenue · Last 7 days",
                              ),
                              style: blackLight.copyWith(fontSize: 10.0.sp),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(
                              "Video Ad",
                            ),
                          ),
                          Text(
                            AppLocalizations.of("Banner Ad"),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SeeMore(
                                    postId: widget.postId,
                                  )));
                        },
                        child: Text(
                          AppLocalizations.of("See more"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartRevenue extends StatefulWidget {
  final Revenue revenue;

  const LineChartRevenue({Key? key, required this.revenue}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LineChartRevenueState();
}

class LineChartRevenueState extends State<LineChartRevenue> {
  late Revenue revenue;

  late List<GhaphEstimatedRevenue> ghaphEstimatedRevenue;
  late double ymax;
  late double ymin;

  List<int> ypointList = [];
  @override
  void initState() {
    super.initState();
    revenue = widget.revenue;
    getDataShortdata();
  }

  List<int> printpoints(int nop, double startNum, double endNum) {
    List<int> numList = [];
    // var min = 0;
    // var max = nop;
    // var mid = ((min + max) / 2).round();
    // var fmid = ((min + mid) / 2).round();
    // var lmid = ((max + mid) / 2).round();
    // numList = [min, fmid, mid, lmid, max];

    var qnop = nop - 1;
    var exnum = endNum - startNum;
    for (var i = 0; i < nop; i++) {
      var finalnum = ((exnum / qnop) * i) + startNum;
      numList.add(finalnum.round());
    }
    print("numList  :-> $numList");
    return numList;
  }

  void getDataShortdata() {
    ghaphEstimatedRevenue = revenue?.ghaphEstimatedRevenue?.map((e) {
          e.eData = DateTime.parse(e.date!);
          return e;
        })?.toList() ??
        [];

    ghaphEstimatedRevenue.sort((a, b) {
      return -a.eData!.compareTo(b.eData!);
    });
    ghaphEstimatedRevenue = ghaphEstimatedRevenue.reversed.toList();

    List<GhaphEstimatedRevenue> listOfvalue = List.of(ghaphEstimatedRevenue);
    listOfvalue.sort((a, b) {
      return -double.parse(a.value!).compareTo(double.parse(b.value!));
    });
    ymax = listOfvalue.isNullorEmpty
        ? 0
        : double.parse(listOfvalue!.first!.value!);
    ymin =
        listOfvalue.isNullorEmpty ? 0 : double.parse(listOfvalue!.last!.value!);
    ypointList = printpoints(5, 0, ghaphEstimatedRevenue.length.toDouble() - 1);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 180,
          padding: EdgeInsets.only(bottom: 20),
          width: ((ghaphEstimatedRevenue.length ?? 1.0) * 15) >
                  (MediaQuery.of(context).size.width - 30)
              ? ((ghaphEstimatedRevenue.length ?? 1.0) * 15)
              : (MediaQuery.of(context).size.width - 30),
          child: LineChart(
            chartData1(),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
      ),
    );
  }

  LineChartData chartData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            // getTextStyles: (value) => Theme.of(context).textTheme.caption,
            // margin: 10,
            rotateAngle: -90,
            getTitles: (value) {
              if (ghaphEstimatedRevenue.length > value.toInt()) {
                var d = ghaphEstimatedRevenue[value.toInt()].eData;
                // if (d == maxXDate || d == minXDate) {
                //   return "${d.day < 10 ? '0' + d.day.toString() : d.day}-${DateFormat("MMM").format(d)}";
                // }
                if (d!.day == 1) {
                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}\n${DateFormat("MMM").format(d)}-${d.year}";
                } else {
                  switch (d!.day) {
                    case 5:
                      return "${d!.day < 10 ? '0' + d.day.toString() : d.day}";
                    case 10:
                      return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                    case 15:
                      return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                    case 20:
                      return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                    case 25:
                      return "${d.day < 10 ? '0' + d.day.toString() : d.day}";
                    default:
                      return '';
                  }
                }
              } else {
                return '';
              }
            }),
        leftTitles: SideTitles(
          showTitles: true,
          // getTextStyles: (value) => Theme.of(context).textTheme.caption,
          getTitles: (value) {
            return '';
            // return value.toString();
          },
          margin: 0,
          reservedSize: 10,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black54,
            width: 2,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: ghaphEstimatedRevenue?.length?.toDouble() ?? 0,
      minY: ymin,
      maxY: ymax,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        ...ghaphEstimatedRevenue.map((e) {
          var index = ghaphEstimatedRevenue.indexOf(e);
          return FlSpot(index.toDouble(), double.tryParse(e.value!) ?? 0);
        }).toList(),
      ],
      curveSmoothness: 0.3,
      isCurved: false,
      colors: [
        Colors.black,
      ],
      barWidth: 2,
      isStrokeCapRound: false,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 3,
            color: Colors.black,
            strokeWidth: 0,
            strokeColor: Colors.white,
          );
        },
      ),
    );

    return [
      lineChartBarData2,
    ];
  }
}

class DisplayDialog extends StatefulWidget {
  DisplayDialog({Key? key, required Function? getDateFrom}) : super(key: key);
  //DateTime fromDate;
  Function? getDateFrom;
  @override
  _DisplayDialogState createState() => _DisplayDialogState();
}

class _DisplayDialogState extends State<DisplayDialog> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  Future<void> _selectFromDate(BuildContext context) async {
    //selectedDate = DateTime.now().add(Duration(days: int.parse(_daysController.text)));
    print('...${fromDate}');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate)
      setState(() {
        fromDate = picked;
      });
    print(fromDate);
    setState(() {
      fromDate = fromDate;
    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    //selectedDate = DateTime.now().add(Duration(days: int.parse(_daysController.text)));
    print('...${toDate}');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate)
      setState(() {
        toDate = picked;
      });
    print(toDate);
    setState(() {
      toDate = toDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of('From'),
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              onTap: () async {
                print("${fromDate.toLocal()}".split(' ')[0]);

                await _selectFromDate(context);
                print("${fromDate.toLocal()}".split(' ')[0]);
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
                      horizontal: 1,
                      //  1.0.w,
                      vertical: 1,
                      //0.5.w
                    ),
                    child: Row(
                      children: [
                        Text(
                          fromDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                                  .split("-")[2] +
                              "-" +
                              fromDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                                  .split("-")[1] +
                              "-" +
                              fromDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                                  .split("-")[0],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 1,
                          //1.0.w,
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                        )
                      ],
                    ),
                  ))),
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(
              'To',
            ),
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              onTap: () {
                print("${toDate.toLocal()}".split(' ')[0]);

                _selectToDate(context);
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
                        horizontal: 1,

                        // 1.0.w,
                        vertical: 1

                        //0.5.w
                        ),
                    child: Row(
                      children: [
                        Text(
                          toDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                                  .split("-")[2] +
                              "-" +
                              toDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                                  .split("-")[1] +
                              "-" +
                              toDate
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                                  .split("-")[0],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 1.0
                            // width: 1.0.w,
                            ),
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                        )
                      ],
                    ),
                  ))),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of('Cancel'),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.getDateFrom!(fromDate, toDate);

                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of('ok'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
