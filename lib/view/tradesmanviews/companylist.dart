import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/tradesmanviews/company_detail_page.dart';
import 'package:bizbultest/view/tradesmanviews/newaddcompanyview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../models/Tradesmen/CompanyTradesmenList.dart';
import '../../models/Tradesmen/tradesmenofcompanieslist.dart';
import '../../utilities/custom_icons.dart';
import '../../utilities/loading_indicator.dart';

class CompanyListView extends StatefulWidget {
  const CompanyListView({Key? key}) : super(key: key);

  @override
  State<CompanyListView> createState() => _CompanyListViewState();
}

class _CompanyListViewState extends State<CompanyListView> {
  var ctr = Get.put(CompanyListingController());
  @override
  Widget build(BuildContext context) {
    void companyPopUp(index) {
      showBarModalBottomSheet(
          context: context,
          builder: (ctx) => Container(
                height: 30.0.h,
                child: Column(
                  children: [
                    ListTile(
                      trailing: GestureDetector(
                        child: Icon(Icons.close),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    ListTile(
                        title: Text('Edit Company'),
                        trailing: Icon(Icons.edit),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => NewAddCompanyView(
                                    companylistingctr: ctr,
                                    companyDetails:
                                        ctr.companytradesmenList[index],
                                    type: 'edit',
                                  )));
                          // Navigator.of(context).pop();
                        }),
                    ListTile(
                        title: Text('Delete Company'),
                        trailing: Icon(Icons.delete),
                        onTap: () {
                          ctr.removeCompany(
                              index, ctr.companytradesmenList[index].companyId);
                          Get.snackbar(
                            'Success',
                            'Company removed successfully',
                            backgroundColor: Colors.white,
                            duration: Duration(milliseconds: 650),
                          );
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ));
    }

    return WillPopScope(
      onWillPop: () async {
        Get.delete<CompanyListingController>();
        return true;
      },
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
              title: Text('Your companies'), backgroundColor: settingsColor),
          body: SmartRefresher(
            onLoading: ctr.onLoading,
            onRefresh: ctr.onRefresh,
            header: CustomHeader(
              builder: (context, mode) {
                return Container(
                  child: Center(child: loadingAnimation()),
                );
              },
            ),
            controller: ctr.companylistrefreshcontroller,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;

                if (mode == LoadStatus.idle) {
                  body = Text("");
                } else if (mode == LoadStatus.loading) {
                  print("loading gif");
                  body = Container(
                    child: Center(child: loadingAnimation()),
                  );
                } else if (mode == LoadStatus.failed) {
                  body = Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(color: Colors.black, width: 0.7),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(CustomIcons.reload),
                      ));
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("");
                } else {
                  body = Text("");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            enablePullUp: true,
            enablePullDown: true,
            child: ctr.companytradesmenList.length == 0
                ? Center(child: loadingAnimation())
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        Divider(height: 2.0.h),
                    shrinkWrap: true,
                    itemCount: ctr.companytradesmenList.length,
                    itemBuilder: ((context, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => CompanyDetailPageView(
                                    controller: ctr,
                                    id: ctr
                                        .companytradesmenList[index].companyId
                                        .toString())));
                          },
                          child: Container(
                            height: 30.0.h,
                            width: 100.0.w,
                            color: Colors.grey.shade200,
                            child: Column(
                              children: [
                                Container(
                                  height: 20.0.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              'http://www.bebuzee.com/upload/images/properbuz/tradesmen/images/' +
                                                  ctr
                                                      .companytradesmenList[
                                                          index]
                                                      .companyLogo!))),
                                ),
                                ListTile(
                                    trailing: IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        companyPopUp(index);
                                      },
                                    ),
                                    title: Text(
                                        '${ctr.companytradesmenList[index].companyName}'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${ctr.companytradesmenList[index].companyLocation}'),
                                        Text(
                                            '${ctr.companytradesmenList[index].serviceDescription}'),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ))),
          ),
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: settingsColor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => NewAddCompanyView(
                          companylistingctr: ctr,
                        )));
              },
              label: Text('Add company +')),
        ),
      ),
    );
  }
}

class CompanyListingController extends GetxController {
  var companytradesmenList = <CompanyTradesmenListRecord>[].obs;
  final companylistrefreshcontroller = RefreshController(
    initialRefresh: false,
  );
  var tradesmenList = <Tradesman>[].obs;
  var page = 1.obs;
  void getTradesmenList(companyId) async {
    var data = await TradesmanApi.getTradesmenUnderCompanyList(companyId)
        .then((value) => value);
    tradesmenList.value = data!;
  }

  void removeCompanyTradesmen(tradesmenId) async {
    await TradesmanApi.deleteCompanyTradesmen(tradesmenId);
    Get.snackbar('Success', 'Removed successfully',
        duration: Duration(milliseconds: 650), backgroundColor: Colors.white);
  }

  void getCompanyList() async {
    var data = await TradesmanApi.getTraddesmenCompanyList();
    companytradesmenList.value = data!;
  }

  void onRefresh() async {
    page.value = 1;
    var data = await TradesmanApi.getTraddesmenCompanyList();
    companytradesmenList.value = data!;
    companylistrefreshcontroller.refreshCompleted();
  }

  void onLoadingTest() async {}

  void onLoading() async {
    page.value++;
    var data = await TradesmanApi.getTraddesmenCompanyList(page: page.value);
    companytradesmenList.value.addAll(data!);
    companytradesmenList.refresh();
    companylistrefreshcontroller.loadComplete();
  }

  void removeCompany(index, id) async {
    companytradesmenList.removeAt(index);
    var data = await TradesmanApi.deleteTradesmenCompany(id);

    companytradesmenList.refresh();
  }

  @override
  void onInit() {
    getCompanyList();
    super.onInit();
  }
}
