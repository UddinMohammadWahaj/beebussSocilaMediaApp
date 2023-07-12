import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Analytics/SeeMoreAllData.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import "package:collection/collection.dart";
import 'seeMoreLinechart.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../../api/ApiRepo.dart' as ApiRepo;

extension MyExtandList on List {
  bool get isNullorEmpty {
    return this == null || this.isEmpty;
  }
}

class SeeMore extends StatefulWidget {
  const SeeMore({Key? key, this.postId}) : super(key: key);
  final postId;
  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  DateTime? date1 = DateTime.now().subtract(Duration(days: 7));
  DateTime? date2 = DateTime.now();
  int initialIndex = 0;

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
    _getAnalyticsRevenueFilter();
  }

  Future<void> _getAnalyticsRevenueFilter() async {
    setState(() {
      seeMoreAllData = null;
    });
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_analytics_revenue_filter.php");
    var sendData = {
      "user_id": "${CurrentUser().currentUser.memberID}",
      "from_date": date1?.toString() ?? "",
      "to_date": date2?.toString() ?? "",
      "post_id": widget.postId ?? "",
      "first_metric": firstMetric,
      "second_metric": secondMetric ?? "",
      "filter_revenue": filterTabName,
      "search_keyword": "",
    };
    print(CurrentUser().currentUser.memberID);
    print(sendData);
    var response = await ApiRepo.postWithToken(
        "api/analytics_revenue_filter.php", sendData);

    // var response = await http.post(
    //   url,
    //   body: sendData,
    // );
    if (response!.success == 1) {
      if (this.mounted) {
        setState(() {
          seeMoreAllData = SeeMoreAllData.fromJson(response.data['data']);
        });
        // print(passMatch);
      }
    }
  }

  late SeeMoreAllData? seeMoreAllData;

  String filterTabName = "Video";
  late String search_keyword;

  String dateRangeDropdownValue = 'Last 7 days';
  String firstMetric = 'viewVideo';
  String? secondMetric = null;
  String chartTypeValue = 'Line Chart';
  List<String> listOfData = [
    'Last 7 days',
    'Last 28 days',
    'Last 90 days',
    'Last 365 days',
    'Lifetime',
    'Custom',
  ];
  List<String> listOfTab = [
    AppLocalizations.of('Video'),
    AppLocalizations.of('trafficSource'),
    AppLocalizations.of('Geography'),
    AppLocalizations.of('viewerAge'),
    AppLocalizations.of('viewerGender'),
    AppLocalizations.of('Date'),
    AppLocalizations.of('Playlist'),
    AppLocalizations.of('deviceType'),
  ];
  List<Map> listOfSecondryData = [
    {'name': 'Select secondry metrix', 'value': null},
    {'name': 'view by : Video', 'value': "viewVideo"},
    {'name': 'watch time(hours) by : Video', 'value': "watchTimeVideo"},
    {
      'name': 'Your estimated revenue by: Video',
      'value': "estimatedRevenueVideo"
    },
  ];
  List<Map> listOfMainData = [
    {'name': 'view by : Video', 'value': "viewVideo"},
    {'name': 'watch time(hours) by : Video', 'value': "watchTimeVideo"},
    {
      'name': 'Your estimated revenue by: Video',
      'value': "estimatedRevenueVideo"
    },
  ];
  List<String> listOfChartData = [
    'Line Chart',
    'Bar Chart',
  ];
  @override
  void initState() {
    _tabController = new TabController(length: 8, vsync: this);
    //_tabController1 = new TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _getAnalyticsRevenueFilter();
    super.initState();
  }

  int _currentIndex = 0;

  _handleTabSelection() {
    // setState(() {
    _currentIndex = _tabController.index;
    filterTabName = listOfTab[_currentIndex];
    firstMetric = (filterTabName == "Date")
        ? AppLocalizations.of('viewDate')
        : AppLocalizations.of('viewVideo');

    listOfMainData = [
      if (filterTabName == "Date")
        {'name': 'view by : Date', 'value': "viewDate"},
      {'name': 'view by : Video', 'value': "viewVideo"},
      {'name': 'watch time(hours) by : Video', 'value': "watchTimeVideo"},
      if (filterTabName == "Date" || filterTabName == "Video")
        {
          'name': 'Your estimated revenue by: Video',
          'value': "estimatedRevenueVideo"
        },
    ];

    secondMetric = null;
    listOfSecondryData = [
      {'name': 'Select secondry metrix', 'value': null},
      {'name': 'view by : Video', 'value': "viewVideo"},
      {'name': 'watch time(hours) by : Video', 'value': "watchTimeVideo"},
      if (filterTabName == "Video")
        {
          'name': 'Your estimated revenue by: Video',
          'value': "estimatedRevenueVideo"
        },
    ];
    _getAnalyticsRevenueFilter();
    // });
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
                    titleSpacing: 0,
                    title: Text(
                      AppLocalizations.of(
                        'Channel',
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    // elevation: 0,
                    // backgroundColor: Colors.white,
                    leading: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 150,
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
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
                      isScrollable: true,
                      tabs: <Tab>[
                        Tab(
                          child: Text(
                            AppLocalizations.of(
                              "Video",
                            ),

                            // style: TextStyle(color: Colors.black),
                            style: blackBold.copyWith(
                                color: Colors.white, fontSize: 10.0.sp),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(
                              "Traffic Source",
                            ),
                            style: blackBold.copyWith(
                                color: Colors.white, fontSize: 10.0.sp),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(
                              "Geography",
                            ),
                            style: blackBold.copyWith(
                                color: Colors.white, fontSize: 10.0.sp),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(
                              "Viewer age",
                            ),
                            style: blackBold.copyWith(
                                color: Colors.white, fontSize: 10.0.sp),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(
                              "Viewer gender",
                            ),
                            style: blackBold.copyWith(
                                color: Colors.white, fontSize: 10.0.sp),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(
                              "Date",
                            ),
                            style: blackBold.copyWith(
                                color: Colors.white, fontSize: 10.0.sp),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(
                              "Playlist",
                            ),
                            style: blackBold.copyWith(
                                color: Colors.white, fontSize: 10.0.sp),
                          ),
                        ),
                        Tab(
                          child: Text(
                            AppLocalizations.of(
                              "Device type",
                            ),
                            style: blackBold.copyWith(
                                color: Colors.white, fontSize: 10.0.sp),
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
                      videoTabView(),
                      trafficSourceTabView(),
                      geographyTabView(),
                      vieweAgeTabView(),
                      genderTabView(),
                      dateTabView(),
                      playlistTabView(),
                      deviceTabView(),
                    ],
                  ),
                )));
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

  videoTabView() {
    late double barminY, barmaxY, barminX, barmaxX;
    var barGraphData = seeMoreAllData?.videoData
            ?.map((e) => GraphData(
                platform: e.videoTitle, value: num.parse(e.totalViews!)))
            ?.toList() ??
        [];
    bargetYdata(bool isMin) {
      var allValue = seeMoreAllData!.videoData
          .map((e) => num.parse(e.totalViews!))
          .toList();
      allValue.sort((a, b) {
        return a.compareTo(b);
      });
      barminY = allValue?.first?.toDouble() ?? 0;
      barmaxY = allValue?.last?.toDouble() ?? 0;
      if (barminY == barmaxY) barminY = 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    bargetXdata(bool isMin, {bool sendDate = false}) {
      barminX = 0;
      barmaxX = (seeMoreAllData?.videoData?.length ?? 0).toDouble();
      return isMin ? 0 : seeMoreAllData?.videoData?.length ?? 0;
    }

    Widget bargetbars() {
      bargetYdata(true);
      bargetXdata(true);
      return SizedBox();
    }

    late double minY, maxY, minX, maxX;
    late DateTime minXDate, maxXDate;
    List<int> exercisestateDataYpointList = [];
    getYdata(bool isMin) {
      var allValue = seeMoreAllData!.graphData.map((e) => e.value).toList();
      allValue.sort((a, b) {
        return a!.compareTo(b!);
      });
      minY = allValue?.first?.toDouble() ?? 0;
      maxY = allValue?.last?.toDouble() ?? 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    getXdata(bool isMin, {bool sendDate = false}) {
      var allDate = seeMoreAllData!.graphData
          .map((e) => DateTime.parse(e.date!))
          .toList();
      allDate.sort((a, b) {
        return a.compareTo(b);
      });
      minXDate = allDate.first;
      maxXDate = allDate.last;
      minX = 0;
      maxX = (allDate.last.difference(allDate.first).inDays + 1).toDouble();
      if (sendDate) {
        return isMin ? allDate.first : allDate.last;
      } else {
        return isMin ? 0 : allDate.last.difference(allDate.first).inDays + 1;
      }
    }

    List<LineChartBarData> returnData =
        List<LineChartBarData>.empty(growable: true);
    Widget getbars() {
      getYdata(true);
      getXdata(true);
      exercisestateDataYpointList =
          printpoints((maxY % 2) == 0 ? 4 : 5, minY, maxY);
      var newMap = groupBy(
        seeMoreAllData!.graphData.map((e) {
          if (seeMoreAllData!.videoData
              .any((element) => element.videoTitle == e.platform)) {
            var recordData = seeMoreAllData!.videoData
                .firstWhere((element) => element.videoTitle == e.platform);
            e.barColor = recordData.barColor;
          } else {
            e.barColor = Colors.black54;
          }
          return e;
        }),
        (GraphData obj) => obj.platform,
      );
      List<DateTime> allDisplayDates = List.generate(
          maxX.toInt(), (index) => minXDate.add(Duration(days: index)));
      newMap.forEach((key, value) {
        value.sort((a, b) {
          return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
        });
        var barData = LineChartBarData(
          isCurved: true,
          colors: [value.first.barColor ?? Colors.black],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: [
            ...value
                .map(
                  (e) => FlSpot(
                    allDisplayDates
                        .indexWhere(
                            (element) => element == DateTime.parse(e.date!))
                        .toDouble(),
                    e.value!.toDouble(),
                  ),
                )
                .toList(),
          ],
        );
        returnData.add(barData);
      });
      return SizedBox();
    }

    if (seeMoreAllData != null &&
        !seeMoreAllData!.videoData.isNullorEmpty &&
        !seeMoreAllData!.graphData.isNullorEmpty) getbars();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: seeMoreAllData != null && seeMoreAllData!.videoData != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // height: 110,
                    // color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: firstMetric,
                                  isDense: true,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      firstMetric = newValue!;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfMainData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: secondMetric,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      secondMetric = newValue;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfSecondryData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: chartTypeValue,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    print('///${newValue}');
                                    chartTypeValue = newValue!;
                                    setState(() {});
                                  },
                                  items: listOfChartData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        '${e}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (chartTypeValue == "Line Chart") ...[
                    if (seeMoreAllData!.graphData != null &&
                        seeMoreAllData!.graphData.isNotEmpty) ...[
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.only(bottom: 20),
                            width: ((maxX ?? 1.0) * 15) >
                                    (MediaQuery.of(context).size.width - 16)
                                ? ((maxX ?? 1.0) * 15)
                                : (MediaQuery.of(context).size.width - 16),
                            child: LineChartWithData(
                              lineBarsData: returnData,
                              lCminX: minX,
                              lCmaxX: maxX,
                              lCminY: minY - 1,
                              lCmaxY: maxY + 1,
                              lCgetTitlesY: (value) {
                                if (exercisestateDataYpointList
                                    .contains(value)) {
                                  return value.toInt().toString();
                                } else {
                                  return '';
                                }
                              },
                              lCgetTitlesX: (value) {
                                var d =
                                    minXDate.add(Duration(days: value.toInt()));
                                if (d == maxXDate || d == minXDate) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}-${DateFormat("MMM").format(d)}";
                                }
                                if (d.day == 1) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}\n${DateFormat("MMM").format(d)}-${d.year}";
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
                    ] else
                      SizedBox()
                  ] else if (seeMoreAllData!.videoData != null &&
                      seeMoreAllData!.videoData.isNotEmpty) ...[
                    bargetbars(),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Container(
                          height: 180,
                          padding: EdgeInsets.only(bottom: 20),
                          width: ((barmaxX! ?? 1.0) * 35) >
                                  (MediaQuery.of(context).size.width - 16)
                              ? ((barmaxX! ?? 1.0) * 35)
                              : (MediaQuery.of(context).size.width - 16),
                          child: BarChart1(
                            lCminX: barminX!,
                            lCmaxX: barmaxX!,
                            lCminY: barminY!,
                            lCmaxY:
                                barmaxY! + ((barmaxY - barminY) / 4).toInt(),
                            graphData: barGraphData,
                          ),
                        ),
                      ),
                    )
                  ],
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(dataRowHeight: 50, columns: <DataColumn>[
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(
                            'Video',
                          ),
                        )),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Views',
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Watch time(h)',
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Your estimated revenue',
                            ),
                          ),
                          numeric: true,
                        ),
                      ], rows: [
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Center(
                                child: Text(
                              AppLocalizations.of(
                                "Total",
                              ),
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            ))), //Extracting from Map element the value
                            DataCell(Text(
                              "${seeMoreAllData!.totalViews}",
                              // "${seeMoreAllData.totalViews=="null"?"0":seeMoreAllData.totalViews}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            DataCell(Text(
                              "${seeMoreAllData!.totalTime}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            DataCell(Text(
                              "${seeMoreAllData!.totalRevenue}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                          ],
                        ),
                        ...seeMoreAllData?.videoData
                                ?.map((e) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Row(
                                            children: [
                                              Container(
                                                height: 10,
                                                width: 10,
                                                color: e.barColor,
                                              ),
                                              SizedBox(width: 10),
                                              // Container(
                                              //   height: 50,
                                              //   width: 80,
                                              //   decoration: BoxDecoration(
                                              //     borderRadius: BorderRadius.all(
                                              //       Radius.circular(5),
                                              //     ),
                                              //     color: Colors.grey,
                                              //   ),
                                              //   child: e. != null || e.videoVideo != ""
                                              //       ? ClipRRect(
                                              //     borderRadius: BorderRadius.all(
                                              //       Radius.circular(5),
                                              //     ),
                                              //     child: Image.network(
                                              //       "https://www.bebuzee.com/" + e.videoVideo,
                                              //       fit: BoxFit.fill,
                                              //     ),
                                              //   )
                                              //       : Center(child: Text("Vido iamge")),
                                              // ),
                                              SizedBox(width: 10),
                                              Text("${e.videoTitle}"),
                                            ],
                                          ),
                                        ), //Extracting from Map element the value
                                        DataCell(Text(
                                            "${e.totalViews} (${e.totalViewsPercent})")),
                                        DataCell(Text(
                                            "${e.totalTime} (${e.totalTimePercent})")),
                                        DataCell(Text(
                                            "${e.totalRevenue} (${e.totalRevenuePercent})")),
                                      ],
                                    ))
                                ?.toList() ??
                            [],
                      ]),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  trafficSourceTabView() {
    late double minY, maxY, minX, maxX;
    late DateTime minXDate, maxXDate;

    List<int> exercisestateDataYpointList = [];
    getYdata(bool isMin) {
      var allValue = seeMoreAllData!.graphData.map((e) => e.value).toList();
      allValue.sort((a, b) {
        return a!.compareTo(b!);
      });
      minY = allValue?.first?.toDouble() ?? 0;
      maxY = allValue?.last?.toDouble() ?? 0;

      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    getXdata(bool isMin, {bool sendDate = false}) {
      var allDate = seeMoreAllData!.graphData
          .map((e) => DateTime.parse(e.date!))
          .toList();
      allDate.sort((a, b) {
        return a.compareTo(b);
      });

      minXDate = allDate.first;
      maxXDate = allDate.last;
      minX = 0;
      maxX = (allDate.last.difference(allDate.first).inDays + 1).toDouble();
      if (sendDate) {
        return isMin ? allDate.first : allDate.last;
      } else {
        return isMin ? 0 : allDate.last.difference(allDate.first).inDays + 1;
      }
    }

    List<LineChartBarData> returnData =
        List<LineChartBarData>.empty(growable: true);
    Widget getbars() {
      getYdata(true);
      getXdata(true);
      exercisestateDataYpointList =
          printpoints((maxY % 2) == 0 ? 4 : 5, minY, maxY);
      var newMap = groupBy(
        seeMoreAllData!.graphData.map((e) {
          if (seeMoreAllData!.trafficData
              .any((element) => element.trafficVal == e.platform)) {
            var recordData = seeMoreAllData!.trafficData
                .firstWhere((element) => element.trafficVal == e.platform);
            e.barColor = recordData.barColor;
          } else {
            e.barColor = Colors.black;
          }
          return e;
        }),
        (GraphData obj) => obj.platform,
      );
      List<DateTime> allDisplayDates = List.generate(
          maxX.toInt(), (index) => minXDate.add(Duration(days: index)));
      newMap.forEach((key, value) {
        value.sort((a, b) {
          return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
        });
        var barData = LineChartBarData(
          isCurved: true,
          colors: [value.first.barColor ?? Colors.black],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: [
            ...value
                .map(
                  (e) => FlSpot(
                    allDisplayDates
                        .indexWhere(
                            (element) => element == DateTime.parse(e.date!))
                        .toDouble(),
                    e.value!.toDouble(),
                  ),
                )
                .toList(),
          ],
        );

        returnData.add(barData);
      });

      return SizedBox();
    }

    if (seeMoreAllData != null &&
        !seeMoreAllData!.trafficData.isNullorEmpty &&
        !seeMoreAllData!.graphData.isNullorEmpty) getbars();

    late double barminY, barmaxY, barminX, barmaxX;
    var barGraphData = seeMoreAllData?.trafficData
            ?.map((e) => GraphData(
                platform: e.trafficVal, value: num.parse(e.totalViews!)))
            ?.toList() ??
        [];
    bargetYdata(bool isMin) {
      var allValue = seeMoreAllData!.trafficData
          .map((e) => num.parse(e.totalViews!))
          .toList();
      allValue.sort((a, b) {
        return a.compareTo(b);
      });
      barminY = allValue?.first?.toDouble() ?? 0;
      barmaxY = allValue?.last?.toDouble() ?? 0;
      if (barminY == barmaxY) barminY = 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    bargetXdata(bool isMin, {bool sendDate = false}) {
      barminX = 0;
      barmaxX = (seeMoreAllData?.trafficData?.length ?? 0).toDouble();
      return isMin ? 0 : seeMoreAllData?.trafficData?.length ?? 0;
    }

    Widget bargetbars() {
      bargetYdata(true);
      bargetXdata(true);
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: seeMoreAllData != null && seeMoreAllData!.trafficData != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // height: 110,
                    // color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: firstMetric,
                                  isDense: true,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      firstMetric = newValue!;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfMainData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: secondMetric,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      secondMetric = newValue;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfSecondryData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: chartTypeValue,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      chartTypeValue = newValue!;
                                    });
                                  },
                                  items: listOfChartData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        '${e}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (chartTypeValue == "Line Chart") ...[
                    if (seeMoreAllData!.graphData != null &&
                        seeMoreAllData!.graphData.isNotEmpty)
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.only(bottom: 20),
                            width: ((maxX ?? 1.0) * 15) >
                                    (MediaQuery.of(context).size.width - 16)
                                ? ((maxX ?? 1.0) * 15)
                                : (MediaQuery.of(context).size.width - 16),
                            child: LineChartWithData(
                              lineBarsData: returnData,
                              lCminX: minX,
                              lCmaxX: maxX,
                              lCminY: minY - 1,
                              lCmaxY: maxY + 1,
                              lCgetTitlesY: (value) {
                                if (exercisestateDataYpointList
                                    .contains(value)) {
                                  return value.toInt().toString();
                                } else {
                                  return '';
                                }
                              },
                              lCgetTitlesX: (value) {
                                var d =
                                    minXDate.add(Duration(days: value.toInt()));
                                if (d == maxXDate || d == minXDate) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}-${DateFormat("MMM").format(d)}";
                                }
                                if (d.day == 1) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}\n${DateFormat("MMM").format(d)}-${d.year}";
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
                      SizedBox()
                  ] else if (seeMoreAllData!.trafficData != null &&
                      seeMoreAllData!.trafficData.isNotEmpty) ...[
                    bargetbars(),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Container(
                          height: 180,
                          padding: EdgeInsets.only(bottom: 20),
                          width: ((barmaxX ?? 1.0) * 35) >
                                  (MediaQuery.of(context).size.width - 16)
                              ? ((barmaxX ?? 1.0) * 35)
                              : (MediaQuery.of(context).size.width - 16),
                          child: BarChart1(
                            lCminX: barminX,
                            lCmaxX: barmaxX,
                            lCminY: barminY,
                            lCmaxY: barmaxY + ((barmaxY - barminY) / 4).toInt(),
                            graphData: barGraphData,
                          ),
                        ),
                      ),
                    )
                  ],
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(dataRowHeight: 50, columns: <DataColumn>[
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(
                            'Video',
                          ),
                        )),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Views',
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Watch time(h)',
                            ),
                          ),
                          numeric: true,
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Your es­tim­ated rev­en­ue',
                        //   ),
                        //   numeric: true,
                        // ),
                      ], rows: [
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Center(
                                child: Text(
                              AppLocalizations.of(
                                "Total",
                              ),
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            ))), //Extracting from Map element the value
                            DataCell(Text(
                              "${seeMoreAllData!.totalViews}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            DataCell(Text(
                              "${seeMoreAllData!.totalTime}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            // DataCell(Text(
                            //   "${seeMoreAllData.totalRevenue}",
                            //   style: blackBold.copyWith(fontSize: 17.0.sp),
                            // )),
                          ],
                        ),
                        ...seeMoreAllData?.trafficData
                                ?.map((e) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Row(
                                            children: [
                                              Container(
                                                height: 10,
                                                width: 10,
                                                color:
                                                    e.barColor ?? Colors.black,
                                              ),
                                              SizedBox(width: 10),
                                              Text("${e.trafficVal}"),
                                            ],
                                          ),
                                        ), //Extracting from Map element the value
                                        DataCell(Text(
                                            "${e.totalViews} (${e.totalViewsPercent})")),
                                        DataCell(Text(
                                            "${e.totalTime} (${e.totalTimePercent})")),
                                        // DataCell(Text("${e.totalRevenue} (${e.totalRevenuePercent})")),
                                      ],
                                    ))
                                ?.toList() ??
                            [],
                      ]),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  geographyTabView() {
    late double minY, maxY, minX, maxX;
    late DateTime minXDate, maxXDate;
    List<int> exercisestateDataYpointList = [];
    getYdata(bool isMin) {
      var allValue = seeMoreAllData!.graphData.map((e) => e.value).toList();
      allValue.sort((a, b) {
        return a!.compareTo(b!);
      });
      minY = allValue?.first?.toDouble() ?? 0;
      maxY = allValue?.last?.toDouble() ?? 0;

      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    getXdata(bool isMin, {bool sendDate = false}) {
      var allDate = seeMoreAllData!.graphData
          .map((e) => DateTime.parse(e.date!))
          .toList();
      allDate.sort((a, b) {
        return a.compareTo(b);
      });
      minXDate = allDate.first;
      maxXDate = allDate.last;
      minX = 0;
      maxX = (allDate.last.difference(allDate.first).inDays + 1).toDouble();
      if (sendDate) {
        return isMin ? allDate.first : allDate.last;
      } else {
        return isMin ? 0 : allDate.last.difference(allDate.first).inDays + 1;
      }
    }

    List<LineChartBarData> returnData =
        List<LineChartBarData>.empty(growable: true);
    Widget getbars() {
      getYdata(true);
      getXdata(true);
      exercisestateDataYpointList =
          printpoints((maxY % 2) == 0 ? 4 : 5, minY, maxY);
      var newMap = groupBy(
        seeMoreAllData!.graphData.map((e) {
          if (seeMoreAllData!.geographyData
                  ?.any((element) => element.countryName == e.platform) ??
              false) {
            var recordData = seeMoreAllData!.geographyData
                .firstWhere((element) => element.countryName == e.platform);
            e.barColor = recordData.barColor;
          } else {
            e.barColor = Colors.black;
          }
          return e;
        }),
        (GraphData obj) => obj.platform,
      );
      List<DateTime> allDisplayDates = List.generate(
          maxX.toInt(), (index) => minXDate.add(Duration(days: index)));
      newMap.forEach((key, value) {
        value.sort((a, b) {
          return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
        });
        var barData = LineChartBarData(
          isCurved: true,
          colors: [value.first.barColor ?? Colors.black],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: [
            ...value
                .map(
                  (e) => FlSpot(
                    allDisplayDates
                        .indexWhere(
                            (element) => element == DateTime.parse(e.date!))
                        .toDouble(),
                    e.value!.toDouble(),
                  ),
                )
                .toList(),
          ],
        );

        returnData.add(barData);
      });
      return SizedBox();
    }

    if (seeMoreAllData != null &&
        !seeMoreAllData!.geographyData.isNullorEmpty &&
        !seeMoreAllData!.graphData.isNullorEmpty) getbars();

    late double barminY, barmaxY, barminX, barmaxX;
    var barGraphData = seeMoreAllData?.geographyData
            ?.map((e) => GraphData(
                platform: e.countryName, value: num.parse(e.totalViews!)))
            ?.toList() ??
        [];
    bargetYdata(bool isMin) {
      var allValue = seeMoreAllData!.geographyData
          .map((e) => num.parse(e.totalViews!))
          .toList();
      allValue.sort((a, b) {
        return a.compareTo(b);
      });
      barminY = allValue?.first?.toDouble() ?? 0;
      barmaxY = allValue?.last?.toDouble() ?? 0;
      if (barminY == barmaxY) barminY = 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    bargetXdata(bool isMin, {bool sendDate = false}) {
      barminX = 0;
      barmaxX = (seeMoreAllData?.geographyData?.length ?? 0).toDouble();
      return isMin ? 0 : seeMoreAllData?.geographyData?.length ?? 0;
    }

    Widget bargetbars() {
      bargetYdata(true);
      bargetXdata(true);
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: seeMoreAllData != null && seeMoreAllData!.geographyData != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // height: 110,
                    // color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: firstMetric,
                                  isDense: true,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      firstMetric = newValue!;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfMainData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: secondMetric,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      secondMetric = newValue;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfSecondryData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: chartTypeValue,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      chartTypeValue = newValue!;
                                    });
                                  },
                                  items: listOfChartData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        '${e}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (chartTypeValue == "Line Chart") ...[
                    if (seeMoreAllData!.graphData != null &&
                        seeMoreAllData!.graphData.isNotEmpty)
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.only(bottom: 20),
                            width: ((maxX ?? 1.0) * 15) >
                                    (MediaQuery.of(context).size.width - 16)
                                ? ((maxX ?? 1.0) * 15)
                                : (MediaQuery.of(context).size.width - 16),
                            child: LineChartWithData(
                              lineBarsData: returnData,
                              lCminX: minX,
                              lCmaxX: maxX,
                              lCminY: minY - 1,
                              lCmaxY: maxY + 1,
                              lCgetTitlesY: (value) {
                                if (exercisestateDataYpointList
                                    .contains(value)) {
                                  return value.toInt().toString();
                                } else {
                                  return '';
                                }
                              },
                              lCgetTitlesX: (value) {
                                var d =
                                    minXDate.add(Duration(days: value.toInt()));
                                if (d == maxXDate || d == minXDate) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}-${DateFormat("MMM").format(d)}";
                                }
                                if (d.day == 1) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}\n${DateFormat("MMM").format(d)}-${d.year}";
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
                      SizedBox()
                  ] else if (seeMoreAllData!.geographyData != null &&
                      seeMoreAllData!.geographyData.isNotEmpty) ...[
                    bargetbars(),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Container(
                          height: 180,
                          padding: EdgeInsets.only(bottom: 20),
                          width: ((barmaxX ?? 1.0) * 35) >
                                  (MediaQuery.of(context).size.width - 16)
                              ? ((barmaxX ?? 1.0) * 35)
                              : (MediaQuery.of(context).size.width - 16),
                          child: BarChart1(
                            lCminX: barminX,
                            lCmaxX: barmaxX,
                            lCminY: barminY,
                            lCmaxY: barmaxY + ((barmaxY - barminY) / 4).toInt(),
                            graphData: barGraphData,
                          ),
                        ),
                      ),
                    )
                  ],
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(dataRowHeight: 50, columns: <DataColumn>[
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(
                            'Country Name',
                          ),
                        )),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Views',
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Watch time(h)',
                            ),
                          ),
                          numeric: true,
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Your es­tim­ated rev­en­ue',
                        //   ),
                        //   numeric: true,
                        // ),
                      ], rows: [
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Center(
                                child: Text(
                              AppLocalizations.of(
                                "Total",
                              ),
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            ))), //Extracting from Map element the value
                            DataCell(Text(
                              "${seeMoreAllData!.totalViews}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            DataCell(Text(
                              "${seeMoreAllData!.totalTime}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                          ],
                        ),
                        ...seeMoreAllData?.geographyData
                                ?.map((e) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Row(
                                            children: [
                                              Container(
                                                height: 10,
                                                width: 10,
                                                color:
                                                    e.barColor ?? Colors.black,
                                              ),
                                              SizedBox(width: 10),
                                              Text("${e.countryName}"),
                                            ],
                                          ),
                                        ), //Extracting from Map element the value
                                        DataCell(Text(
                                            "${e.totalViews} (${e.totalViewsPercent})")),
                                        DataCell(Text(
                                            "${e.totalTime} (${e.totalTimePercent})")),
                                        // DataCell(Text("${e.totalRevenue} (${e.totalRevenuePercent})")),
                                      ],
                                    ))
                                ?.toList() ??
                            [],
                      ]),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  vieweAgeTabView() {
    late double minY, maxY, minX, maxX;
    getYdata(bool isMin) {
      var allValue = seeMoreAllData!.graphData.map((e) => e.value).toList();
      allValue.sort((a, b) {
        return a!.compareTo(b!);
      });
      minY = allValue?.first?.toDouble() ?? 0;
      maxY = allValue?.last?.toDouble() ?? 0;
      if (minY == maxY) minY = 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    getXdata(bool isMin, {bool sendDate = false}) {
      minX = 0;
      maxX = (seeMoreAllData?.graphData?.length ?? 0).toDouble();
      return isMin ? 0 : seeMoreAllData?.graphData?.length ?? 0;
    }

    Widget getbars() {
      getYdata(true);
      getXdata(true);
      return SizedBox();
    }

    if (seeMoreAllData != null &&
        seeMoreAllData!.viewerAge != null &&
        !seeMoreAllData!.graphData.isNullorEmpty) getbars();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: seeMoreAllData != null && seeMoreAllData!.viewerAge != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all()),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: firstMetric,
                        isDense: true,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            print('///${newValue}');

                            firstMetric = newValue!;
                          });
                          _getAnalyticsRevenueFilter();
                        },
                        items: listOfMainData.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['value'],
                            child: Text(
                              '${e['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!seeMoreAllData!.graphData.isNullorEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.only(bottom: 20),
                            width: ((maxX ?? 1.0) * 35) >
                                    (MediaQuery.of(context).size.width - 16)
                                ? ((maxX ?? 1.0) * 35)
                                : (MediaQuery.of(context).size.width - 16),
                            child: BarChart1(
                              lCminX: minX,
                              lCmaxX: maxX,
                              lCminY: minY,
                              lCmaxY: maxY + ((maxY - minY) / 4).toInt(),
                              graphData: seeMoreAllData!.graphData,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(dataRowHeight: 50, columns: <DataColumn>[
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(
                            'Video',
                          ),
                        )),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Views',
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Watch time(h)',
                            ),
                          ),
                          numeric: true,
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Your es­tim­ated rev­en­ue',
                        //   ),
                        //   numeric: true,
                        // ),
                      ], rows: [
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Center(
                                child: Text(
                              AppLocalizations.of(
                                "Total",
                              ),
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            ))), //Extracting from Map element the value
                            DataCell(Text(
                              "${seeMoreAllData!.totalViews}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            DataCell(Text(
                              "${seeMoreAllData!.watchHours}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            // DataCell(Text(
                            //   "${seeMoreAllData.totalRevenue}",
                            //   style: blackBold.copyWith(fontSize: 17.0.sp),
                            // )),
                          ],
                        ),
                        ...seeMoreAllData?.viewerAge
                                ?.map((e) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          // Container(
                                          //   height: 50,
                                          //   width: 80,
                                          //   decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.all(
                                          //       Radius.circular(5),
                                          //     ),
                                          //     color: Colors.grey,
                                          //   ),
                                          //   child: Center(child: Text("Video image")),
                                          // ),
                                          Text("${e.viewerAge}"),
                                        ), //Extracting from Map element the value
                                        DataCell(Text(
                                            "${e.totalViews} (${e.totalViewsPercent})")),
                                        DataCell(Text(
                                            "${e.watchTime} (${e.watchTimePercent})")),
                                        // DataCell(Text("${e.totalRevenue} (${e.totalRevenuePercent})")),
                                      ],
                                    ))
                                ?.toList() ??
                            [],
                      ]),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  genderTabView() {
    late double minY, maxY, minX, maxX;
    getYdata(bool isMin) {
      var allValue = seeMoreAllData!.graphData.map((e) => e.value).toList();
      allValue.sort((a, b) {
        return a!.compareTo(b!);
      });
      minY = allValue?.first?.toDouble() ?? 0;
      maxY = allValue?.last?.toDouble() ?? 0;
      if (minY == maxY) minY = 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    getXdata(bool isMin, {bool sendDate = false}) {
      minX = 0;
      maxX = (seeMoreAllData?.graphData?.length ?? 0).toDouble();
      return isMin ? 0 : seeMoreAllData?.graphData?.length ?? 0;
    }

    getbars() {
      getYdata(true);
      getXdata(true);
    }

    if (seeMoreAllData != null &&
        seeMoreAllData!.viewerGender != null &&
        !seeMoreAllData!.graphData.isNullorEmpty) getbars();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: seeMoreAllData != null && seeMoreAllData!.viewerGender != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all()),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: firstMetric,
                        isDense: true,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            print('///${newValue}');
                            firstMetric = newValue!;
                          });
                          _getAnalyticsRevenueFilter();
                        },
                        items: listOfMainData.map((e) {
                          return DropdownMenuItem<String>(
                            value: e['value'],
                            child: Text(
                              '${e['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!seeMoreAllData!.graphData.isNullorEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.only(bottom: 20),
                            width: ((maxX ?? 1.0) * 35) >
                                    (MediaQuery.of(context).size.width - 16)
                                ? ((maxX ?? 1.0) * 35)
                                : (MediaQuery.of(context).size.width - 16),
                            child: BarChart1(
                              lCminX: minX,
                              lCmaxX: maxX,
                              lCminY: minY,
                              lCmaxY: maxY + ((maxY - minY) / 4).toInt(),
                              graphData: seeMoreAllData!.graphData,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(dataRowHeight: 50, columns: <DataColumn>[
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(
                            'Video',
                          ),
                        )),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Views',
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Watch time(h)',
                            ),
                          ),
                          numeric: true,
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Your es­tim­ated rev­en­ue',
                        //   ),
                        //   numeric: true,
                        // ),
                      ], rows: [
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Center(
                                child: Text(
                              AppLocalizations.of(
                                "Total",
                              ),
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            ))), //Extracting from Map element the value
                            DataCell(Text(
                              "${seeMoreAllData!.totalViews}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            DataCell(Text(
                              "${seeMoreAllData!.watchHours}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            // DataCell(Text(
                            //   "${seeMoreAllData.totalRevenue}",
                            //   style: blackBold.copyWith(fontSize: 17.0.sp),
                            // )),
                          ],
                        ),
                        ...seeMoreAllData?.viewerGender
                                ?.map((e) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          // Container(
                                          //   height: 50,
                                          //   width: 80,
                                          //   decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.all(
                                          //       Radius.circular(5),
                                          //     ),
                                          //     color: Colors.grey,
                                          //   ),
                                          //   child: Center(child: Text("Video image")),
                                          // ),
                                          Text("${e.viewerAge}"),
                                        ), //Extracting from Map element the value
                                        DataCell(Text(
                                            "${e.totalViews} (${e.totalViewsPercent})")),
                                        DataCell(Text(
                                            "${e.watchTime} (${e.watchTimePercent})")),
                                        // DataCell(Text("${e.totalRevenue} (${e.totalRevenuePercent})")),
                                      ],
                                    ))
                                ?.toList() ??
                            [],
                      ]
                          // ...List.generate(3, (i) {
                          //   return DataRow(
                          //     // Container(
                          //     //   padding: EdgeInsets.all(10),
                          //     //   child: Row(
                          //     //     children: [
                          //     //       Container(
                          //     //         height: 70,
                          //     //         width: 100,
                          //     //         color: Colors.grey,
                          //     //         child: Center(child: Text("Video image")),
                          //     //       ),
                          //     //     ],
                          //     //   ),
                          //     // ),
                          //     // Container(
                          //     //   padding: EdgeInsets.only(top: 30),
                          //     //   alignment: Alignment.center,
                          //     //   child: Center(child: Text("00:00:09")),
                          //     // ),
                          //     // Container(
                          //     //   padding: EdgeInsets.only(top: 30),
                          //     //   child: Center(child: Text("${200}")),
                          //     // ),
                          //   );
                          // }),
                          ),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  dateTabView() {
    late double minY, maxY, minX, maxX;
    late DateTime minXDate, maxXDate;
    List<int> exercisestateDataYpointList = [];
    getYdata(bool isMin) {
      var allValue = seeMoreAllData!.graphData.map((e) => e.value).toList();
      allValue.sort((a, b) {
        return a!.compareTo(b!);
      });
      minY = allValue?.first?.toDouble() ?? 0;
      maxY = allValue?.last?.toDouble() ?? 0;

      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    getXdata(bool isMin, {bool sendDate = false}) {
      var allDate = seeMoreAllData!.graphData
          .map((e) => DateTime.parse(e.date!))
          .toList();
      allDate.sort((a, b) {
        return a.compareTo(b);
      });

      minXDate = allDate.first;
      maxXDate = allDate.last;
      minX = 0;
      maxX = (allDate.last.difference(allDate.first).inDays + 1).toDouble();
      if (sendDate) {
        return isMin ? allDate.first : allDate.last;
      } else {
        return isMin ? 0 : allDate.last.difference(allDate.first).inDays + 1;
      }
    }

    List<LineChartBarData> returnData =
        List<LineChartBarData>.empty(growable: true);

    Widget getbars() {
      getYdata(true);
      getXdata(true);
      exercisestateDataYpointList =
          printpoints((maxY % 2) == 0 ? 4 : 5, minY, maxY);

      var newMap = groupBy(
        seeMoreAllData!.graphData.map((e) {
          if (seeMoreAllData!.dateData
                  ?.any((element) => element.date == e.platform) ??
              false) {
            var recordData = seeMoreAllData!.dateData
                .firstWhere((element) => element.date == e.platform);
            e.barColor = recordData.barColor;
          } else {
            e.barColor = Colors.black;
          }
          return e;
        }),
        (GraphData obj) => obj.platform,
      );
      List<DateTime> allDisplayDates = List.generate(
          maxX.toInt(), (index) => minXDate.add(Duration(days: index)));
      newMap.forEach((key, value) {
        value.sort((a, b) {
          return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
        });
        var barData = LineChartBarData(
          isCurved: true,
          colors: [value.first.barColor ?? Colors.black],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: [
            ...value
                .map(
                  (e) => FlSpot(
                    allDisplayDates
                        .indexWhere(
                            (element) => element == DateTime.parse(e.date!))
                        .toDouble(),
                    e.value!.toDouble(),
                  ),
                )
                .toList(),
          ],
        );

        returnData.add(barData);
      });

      return SizedBox();
    }

    if (seeMoreAllData != null &&
        !seeMoreAllData!.dateData.isNullorEmpty &&
        !seeMoreAllData!.graphData.isNullorEmpty) getbars();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: seeMoreAllData != null && seeMoreAllData!.dateData != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // height: 110,
                    // color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 150,
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all()),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: firstMetric,
                              isDense: true,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  print('///${newValue}');

                                  firstMetric = newValue!;
                                });
                                _getAnalyticsRevenueFilter();
                              },
                              items: listOfMainData.map((e) {
                                return DropdownMenuItem<String>(
                                  value: e['value'],
                                  child: Text(
                                    '${e['name']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 40,
                          width: 150,
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all()),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: secondMetric,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  print('///${newValue}');

                                  secondMetric = newValue;
                                });
                                _getAnalyticsRevenueFilter();
                              },
                              items: listOfSecondryData.map((e) {
                                return DropdownMenuItem<String>(
                                  value: e['value'],
                                  child: Text(
                                    '${e['name']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (seeMoreAllData!.graphData != null &&
                      seeMoreAllData!.graphData.isNotEmpty)
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          height: 180,
                          padding: EdgeInsets.only(bottom: 20),
                          width: ((maxX ?? 1.0) * 15) >
                                  (MediaQuery.of(context).size.width - 16)
                              ? ((maxX ?? 1.0) * 15)
                              : (MediaQuery.of(context).size.width - 16),
                          child: LineChartWithData(
                            lineBarsData: returnData,
                            lCminX: minX,
                            lCmaxX: maxX,
                            lCminY: minY - 1,
                            lCmaxY: maxY + 1,
                            lCgetTitlesY: (value) {
                              if (exercisestateDataYpointList.contains(value)) {
                                return value.toInt().toString();
                              } else {
                                return '';
                              }
                            },
                            lCgetTitlesX: (value) {
                              var d =
                                  minXDate.add(Duration(days: value.toInt()));
                              if (d == maxXDate || d == minXDate) {
                                return "${d.day < 10 ? '0' + d.day.toString() : d.day}-${DateFormat("MMM").format(d)}";
                              }
                              if (d.day == 1) {
                                return "${d.day < 10 ? '0' + d.day.toString() : d.day}\n${DateFormat("MMM").format(d)}-${d.year}";
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
                    ),
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(dataRowHeight: 50, columns: <DataColumn>[
                        DataColumn(
                            label: Text(
                          AppLocalizations.of(
                            'Date',
                          ),
                        )),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Views',
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Watch time(h)',
                            ),
                          ),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text(
                            AppLocalizations.of(
                              'Your estimated revenue',
                            ),
                          ),
                          numeric: true,
                        ),
                      ], rows: [
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Center(
                                child: Text(
                              AppLocalizations.of(
                                "Total",
                              ),
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            ))), //Extracting from Map element the value
                            DataCell(Text(
                              "${seeMoreAllData!.totalViews}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            DataCell(Text(
                              "${seeMoreAllData!.watchTimeHours}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                            DataCell(Text(
                              "${seeMoreAllData!.estimatdRevenue}",
                              style: blackBold.copyWith(fontSize: 17.0.sp),
                            )),
                          ],
                        ),
                        ...seeMoreAllData?.dateData
                                ?.map((e) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Row(
                                            children: [
                                              Container(
                                                height: 10,
                                                width: 10,
                                                color:
                                                    e.barColor ?? Colors.black,
                                              ),
                                              SizedBox(width: 10),
                                              Text("${e.date}"),
                                            ],
                                          ),
                                        ), //Extracting from Map element the value
                                        DataCell(Text(
                                            "${e.totalViews} (${e.totalViewsPercent})")),
                                        DataCell(Text(
                                            "${e.watchTime} (${e.watchTimePercent})")),
                                        DataCell(Text(
                                            "${e.estimatedRevenue} (${e.estimatedRevenuePercent})")),
                                      ],
                                    ))
                                ?.toList() ??
                            [],
                      ]),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  playlistTabView() {
    late double minY, maxY, minX, maxX;
    late DateTime minXDate, maxXDate;
    List<int> exercisestateDataYpointList = [];
    getYdata(bool isMin) {
      var allValue = seeMoreAllData!.graphData.map((e) => e.value).toList();
      allValue.sort((a, b) {
        return a!.compareTo(b!);
      });
      minY = allValue?.first?.toDouble() ?? 0;
      maxY = allValue?.last?.toDouble() ?? 0;

      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    getXdata(bool isMin, {bool sendDate = false}) {
      var allDate = seeMoreAllData!.graphData
          .map((e) => DateTime.parse(e.date!))
          .toList();
      allDate.sort((a, b) {
        return a.compareTo(b);
      });

      minXDate = allDate.first;
      maxXDate = allDate.last;
      minX = 0;
      maxX = (allDate.last.difference(allDate.first).inDays + 1).toDouble();
      if (sendDate) {
        return isMin ? allDate.first : allDate.last;
      } else {
        return isMin ? 0 : allDate.last.difference(allDate.first).inDays + 1;
      }
    }

    List<LineChartBarData> returnData =
        List<LineChartBarData>.empty(growable: true);
    Widget getbars() {
      getYdata(true);
      getXdata(true);
      exercisestateDataYpointList =
          printpoints((maxY % 2) == 0 ? 4 : 5, minY, maxY);
      var newMap = groupBy(
        seeMoreAllData!.graphData.map((e) {
          if (seeMoreAllData!.playlist
                  ?.any((element) => element.playlistTitle == e.platform) ??
              false) {
            var recordData = seeMoreAllData!.playlist
                .firstWhere((element) => element.playlistTitle == e.platform);
            e.barColor = recordData.barColor;
          } else {
            e.barColor = Colors.black;
          }
          return e;
        }),
        (GraphData obj) => obj.platform,
      );
      List<DateTime> allDisplayDates = List.generate(
          maxX.toInt(), (index) => minXDate.add(Duration(days: index)));
      newMap.forEach((key, value) {
        value.sort((a, b) {
          return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
        });
        var barData = LineChartBarData(
          isCurved: true,
          colors: [value.first.barColor ?? Colors.black],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: [
            ...value
                .map(
                  (e) => FlSpot(
                    allDisplayDates
                        .indexWhere(
                            (element) => element == DateTime.parse(e.date!))
                        .toDouble(),
                    e.value!.toDouble(),
                  ),
                )
                .toList(),
          ],
        );

        returnData.add(barData);
      });

      return SizedBox();
    }

    if (seeMoreAllData != null &&
        !seeMoreAllData!.playlist.isNullorEmpty &&
        !seeMoreAllData!.graphData.isNullorEmpty) getbars();

    late double barminY, barmaxY, barminX, barmaxX;
    var barGraphData = seeMoreAllData?.playlist
            ?.map((e) => GraphData(
                platform: e.playlistTitle, value: num.parse(e.totalViews!)))
            ?.toList() ??
        [];
    bargetYdata(bool isMin) {
      var allValue = seeMoreAllData!.playlist
          .map((e) => num.parse(e.totalViews!))
          .toList();
      allValue.sort((a, b) {
        return a.compareTo(b);
      });
      barminY = allValue?.first?.toDouble() ?? 0;
      barmaxY = allValue?.last?.toDouble() ?? 0;
      if (barminY == barmaxY) barminY = 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    bargetXdata(bool isMin, {bool sendDate = false}) {
      barminX = 0;
      barmaxX = (seeMoreAllData?.playlist?.length ?? 0).toDouble();
      return isMin ? 0 : seeMoreAllData?.playlist?.length ?? 0;
    }

    Widget bargetbars() {
      bargetYdata(true);
      bargetXdata(true);
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: seeMoreAllData != null && seeMoreAllData!.playlist != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // height: 110,
                    // color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: firstMetric,
                                  isDense: true,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      firstMetric = newValue!;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfMainData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: secondMetric,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      secondMetric = newValue!;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfSecondryData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: chartTypeValue,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      chartTypeValue = newValue!;
                                    });
                                  },
                                  items: listOfChartData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        '${e}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (chartTypeValue == "Line Chart") ...[
                    if (seeMoreAllData!.graphData != null &&
                        seeMoreAllData!.graphData.isNotEmpty)
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.only(bottom: 20),
                            width: ((maxX ?? 1.0) * 15) >
                                    (MediaQuery.of(context).size.width - 16)
                                ? ((maxX ?? 1.0) * 15)
                                : (MediaQuery.of(context).size.width - 16),
                            child: LineChartWithData(
                              lineBarsData: returnData,
                              lCminX: minX,
                              lCmaxX: maxX,
                              lCminY: minY - 1,
                              lCmaxY: maxY + 1,
                              lCgetTitlesY: (value) {
                                if (exercisestateDataYpointList
                                    .contains(value)) {
                                  return value.toInt().toString();
                                } else {
                                  return '';
                                }
                              },
                              lCgetTitlesX: (value) {
                                var d =
                                    minXDate.add(Duration(days: value.toInt()));
                                if (d == maxXDate || d == minXDate) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}-${DateFormat("MMM").format(d)}";
                                }
                                if (d.day == 1) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}\n${DateFormat("MMM").format(d)}-${d.year}";
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
                      SizedBox()
                  ] else if (seeMoreAllData!.playlist != null &&
                      seeMoreAllData!.playlist.isNotEmpty) ...[
                    bargetbars(),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Container(
                          height: 180,
                          padding: EdgeInsets.only(bottom: 20),
                          width: ((barmaxX ?? 1.0) * 35) >
                                  (MediaQuery.of(context).size.width - 16)
                              ? ((barmaxX ?? 1.0) * 35)
                              : (MediaQuery.of(context).size.width - 16),
                          child: BarChart1(
                            lCminX: barminX,
                            lCmaxX: barmaxX,
                            lCminY: barminY,
                            lCmaxY: barmaxY + ((barmaxY - barminY) / 4).toInt(),
                            graphData: barGraphData,
                          ),
                        ),
                      ),
                    )
                  ],
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        dataRowHeight: 50,
                        columns: <DataColumn>[
                          DataColumn(
                              label: Text(
                            AppLocalizations.of(
                              'Playlist',
                            ),
                          )),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(
                                'Views',
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(
                                'Watch time(h)',
                              ),
                            ),
                            numeric: true,
                          ),
                          // DataColumn(
                          //   label: Text(
                          //     'Your es­tim­ated rev­en­ue',
                          //   ),
                          //   numeric: true,
                          // ),
                        ],
                        rows: [
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Center(
                                  child: Text(
                                AppLocalizations.of(
                                  "Total",
                                ),
                                style: blackBold.copyWith(fontSize: 17.0.sp),
                              ))), //Extracting from Map element the value
                              DataCell(Text(
                                "${seeMoreAllData!.totalViews}",
                                style: blackBold.copyWith(fontSize: 17.0.sp),
                              )),
                              DataCell(Text(
                                "${seeMoreAllData!.watchTime}",
                                style: blackBold.copyWith(fontSize: 17.0.sp),
                              )),
                              // DataCell(Text(
                              //   "${seeMoreAllData.estimatdRevenue}",
                              //   style: blackBold.copyWith(fontSize: 17.0.sp),
                              // )),
                            ],
                          ),
                          ...seeMoreAllData?.playlist
                                  ?.map((e) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  color: e.barColor ??
                                                      Colors.black,
                                                ),
                                                SizedBox(width: 10),
                                                Text("${e.playlistTitle}"),
                                              ],
                                            ),
                                          ), //Extracting from Map element the value
                                          DataCell(Text(
                                              "${e.totalViews} (${e.totalViewsPercent})")),
                                          DataCell(Text(
                                              "${e.watchTime} (${e.watchTimePercent})")),
                                          // DataCell(Text("${e.estimatedRevenue} (${e.estimatedRevenuePercent})")),
                                        ],
                                      ))
                                  ?.toList() ??
                              [],
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  deviceTabView() {
    late double minY, maxY, minX, maxX;
    late DateTime minXDate, maxXDate;
    List<int> exercisestateDataYpointList = [];
    getYdata(bool isMin) {
      var allValue = seeMoreAllData!.graphData.map((e) => e.value).toList();
      allValue.sort((a, b) {
        return a!.compareTo(b!);
      });
      minY = allValue?.first?.toDouble() ?? 0;
      maxY = allValue?.last?.toDouble() ?? 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    getXdata(bool isMin, {bool sendDate = false}) {
      var allDate = seeMoreAllData!.graphData
          .map((e) => DateTime.parse(e.date!))
          .toList();
      allDate.sort((a, b) {
        return a.compareTo(b);
      });

      minXDate = allDate.first;
      maxXDate = allDate.last;
      minX = 0;
      maxX = (allDate.last.difference(allDate.first).inDays + 1).toDouble();
      if (sendDate) {
        return isMin ? allDate.first : allDate.last;
      } else {
        return isMin ? 0 : allDate.last.difference(allDate.first).inDays + 1;
      }
    }

    List<LineChartBarData> returnData =
        List<LineChartBarData>.empty(growable: true);

    Widget getbars() {
      getYdata(true);
      getXdata(true);
      exercisestateDataYpointList =
          printpoints((maxY % 2) == 0 ? 4 : 5, minY, maxY);
      var newMap = groupBy(
        seeMoreAllData!.graphData.map((e) {
          if (seeMoreAllData!.devices
                  ?.any((element) => element.deviceType == e.platform) ??
              false) {
            var recordData = seeMoreAllData!.devices
                .firstWhere((element) => element.deviceType == e.platform);
            e.barColor = recordData.barColor;
          } else {
            e.barColor = Colors.black;
          }
          return e;
        }),
        (GraphData obj) => obj.platform,
      );
      List<DateTime> allDisplayDates = List.generate(
          maxX.toInt(), (index) => minXDate.add(Duration(days: index)));
      newMap.forEach((key, value) {
        value.sort((a, b) {
          return DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!));
        });
        var barData = LineChartBarData(
          isCurved: true,
          colors: [value.first.barColor ?? Colors.black],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: [
            ...value
                .map(
                  (e) => FlSpot(
                    allDisplayDates
                        .indexWhere(
                            (element) => element == DateTime.parse(e.date!))
                        .toDouble(),
                    e.value!.toDouble(),
                  ),
                )
                .toList(),
          ],
        );

        returnData.add(barData);
      });

      return SizedBox();
    }

    if (seeMoreAllData != null &&
        !seeMoreAllData!.devices.isNullorEmpty &&
        !seeMoreAllData!.graphData.isNullorEmpty) getbars();

    late double barminY, barmaxY, barminX, barmaxX;
    var barGraphData = seeMoreAllData?.devices
            ?.map((e) => GraphData(
                platform: e.deviceType, value: num.parse(e.totalViews!)))
            ?.toList() ??
        [];
    bargetYdata(bool isMin) {
      var allValue =
          seeMoreAllData!.devices.map((e) => num.parse(e.totalViews!)).toList();
      allValue.sort((a, b) {
        return a.compareTo(b);
      });
      barminY = allValue?.first?.toDouble() ?? 0;
      barmaxY = allValue?.last?.toDouble() ?? 0;
      if (barminY == barmaxY) barminY = 0;
      return isMin ? allValue?.first ?? 0 : allValue?.last ?? 0;
    }

    bargetXdata(bool isMin, {bool sendDate = false}) {
      barminX = 0;
      barmaxX = (seeMoreAllData?.devices?.length ?? 0).toDouble();
      return isMin ? 0 : seeMoreAllData?.devices?.length ?? 0;
    }

    Widget bargetbars() {
      bargetYdata(true);
      bargetXdata(true);
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: seeMoreAllData != null && seeMoreAllData!.devices != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // height: 110,
                    // color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: firstMetric,
                                  isDense: true,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      firstMetric = newValue!;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfMainData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: secondMetric,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      secondMetric = newValue;
                                    });
                                    _getAnalyticsRevenueFilter();
                                  },
                                  items: listOfSecondryData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e['value'],
                                      child: Text(
                                        '${e['name']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 150,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: chartTypeValue,
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      print('///${newValue}');

                                      chartTypeValue = newValue!;
                                    });
                                  },
                                  items: listOfChartData.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        '${e}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (chartTypeValue == "Line Chart") ...[
                    if (seeMoreAllData!.graphData != null &&
                        seeMoreAllData!.graphData.isNotEmpty)
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 180,
                            padding: EdgeInsets.only(bottom: 20),
                            width: ((maxX ?? 1.0) * 15) >
                                    (MediaQuery.of(context).size.width - 16)
                                ? ((maxX ?? 1.0) * 15)
                                : (MediaQuery.of(context).size.width - 16),
                            child: LineChartWithData(
                              lineBarsData: returnData,
                              lCminX: minX,
                              lCmaxX: maxX,
                              lCminY: minY - 1,
                              lCmaxY: maxY + 1,
                              lCgetTitlesY: (value) {
                                if (exercisestateDataYpointList
                                    .contains(value)) {
                                  return value.toInt().toString();
                                } else {
                                  return '';
                                }
                              },
                              lCgetTitlesX: (value) {
                                var d =
                                    minXDate.add(Duration(days: value.toInt()));
                                if (d == maxXDate || d == minXDate) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}-${DateFormat("MMM").format(d)}";
                                }
                                if (d.day == 1) {
                                  return "${d.day < 10 ? '0' + d.day.toString() : d.day}\n${DateFormat("MMM").format(d)}-${d.year}";
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
                      SizedBox()
                  ] else if (seeMoreAllData!.devices != null &&
                      seeMoreAllData!.devices.isNotEmpty) ...[
                    bargetbars(),
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Container(
                          height: 180,
                          padding: EdgeInsets.only(bottom: 20),
                          width: ((barmaxX ?? 1.0) * 35) >
                                  (MediaQuery.of(context).size.width - 16)
                              ? ((barmaxX ?? 1.0) * 35)
                              : (MediaQuery.of(context).size.width - 16),
                          child: BarChart1(
                            lCminX: barminX,
                            lCmaxX: barmaxX,
                            lCminY: barminY,
                            lCmaxY: barmaxY + ((barmaxY - barminY) / 4).toInt(),
                            graphData: barGraphData,
                          ),
                        ),
                      ),
                    )
                  ],
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        dataRowHeight: 50,
                        columns: <DataColumn>[
                          DataColumn(
                              label: Text(
                            AppLocalizations.of(
                              'Device Type',
                            ),
                          )),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(
                                'Views',
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              AppLocalizations.of(
                                'Watch time(h)',
                              ),
                            ),
                            numeric: true,
                          ),
                          // DataColumn(
                          //   label: Text(
                          //     'Your es­tim­ated rev­en­ue',
                          //   ),
                          //   numeric: true,
                          // ),
                        ],
                        rows: [
                          DataRow(
                            cells: <DataCell>[
                              DataCell(Center(
                                  child: Text(
                                "Total",
                                style: blackBold.copyWith(fontSize: 17.0.sp),
                              ))), //Extracting from Map element the value
                              DataCell(Text(
                                "${seeMoreAllData!.totalViews}",
                                style: blackBold.copyWith(fontSize: 17.0.sp),
                              )),
                              DataCell(Text(
                                "${seeMoreAllData!.watchTime}",
                                style: blackBold.copyWith(fontSize: 17.0.sp),
                              )),
                              // DataCell(Text(
                              //   "${seeMoreAllData.estimatdRevenue}",
                              //   style: blackBold.copyWith(fontSize: 17.0.sp),
                              // )),
                            ],
                          ),
                          ...seeMoreAllData?.devices
                                  ?.map((e) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  color: e.barColor ??
                                                      Colors.black,
                                                ),
                                                SizedBox(width: 10),
                                                Text("${e.deviceType}"),
                                              ],
                                            ),
                                          ), //Extracting from Map element the value
                                          DataCell(Text(
                                              "${e.totalViews} (${e.totalViewsPercent})")),
                                          DataCell(Text(
                                              "${e.watchTime} (${e.watchTimePercent})")),
                                          // DataCell(Text("${e.estimatedRevenue} (${e.estimatedRevenuePercent})")),
                                        ],
                                      ))
                                  ?.toList() ??
                              [],
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }
}

class DisplayDialog extends StatefulWidget {
  DisplayDialog({Key? key, required Function this.getDateFrom})
      : super(key: key);
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('From'),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () async {
                  print("${fromDate.toLocal()}".split(' ')[0]);

                  await _selectFromDate(context);
                  print("${fromDate.toLocal()}".split(' ')[0]);
                },
                child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,

                          // 1.0.w,
                          vertical: 10

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
            Text('To'),
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
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      border: new Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,

                          // 1.0.w,
                          vertical: 10

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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of('Cancel'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.getDateFrom!(fromDate, toDate);

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(
                      'ok',
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
