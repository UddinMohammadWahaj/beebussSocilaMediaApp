import 'package:bizbultest/view/Properbuz/add_items/add_New_tradesmen_view.dart';
import 'package:bizbultest/view/Properbuz/menu/premium_package_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';
import '../../../models/Tradesmen/tradesmens_work_category_model.dart';
import '../../../services/Chat/direct_api.dart';
import '../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../utilities/colors.dart';
import '../../../utilities/custom_icons.dart';
import '../add_items/add_solo_tradesmen.dart';
import 'manage_tradesman_view.dart';

class ManageCompanyTradesmenView extends StatefulWidget {
  const ManageCompanyTradesmenView({Key? key}) : super(key: key);

  @override
  State<ManageCompanyTradesmenView> createState() =>
      _ManageCompanyTradesmenViewState();
}

class _ManageCompanyTradesmenViewState
    extends State<ManageCompanyTradesmenView> {
  Future<List<DataCompany>>? ExitingCompanyData;
  List DataCompanyObject = [];
  AddTradesmenController ctr1 = Get.put(AddTradesmenController());
  @override
  void initState() {
    setState(() {
      ExitingCompanyData =
          DirectApiCalls.existingCompanyList()! as Future<List<DataCompany>>?;
    });
  }

  Widget _customTextButton(
      String value, Color textColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 40,
          width: 47.5.w,
          color: bgColor,
          child: Center(
              child: Text(
            value,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w500, fontSize: 15),
          ))),
    );
  }

  Widget _actionRow(context, snapshot, index) {
    return Row(
      children: [
        _customTextButton(
            AppLocalizations.of(
              "Upgrade",
            ),
            Colors.white,
            settingsColor, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PremiumPackageView()));
        }),
        _customTextButton(
            AppLocalizations.of(
              "Edit",
            ),
            settingsColor,
            Colors.grey.shade200, () {
          DataCompanyObject.add({
            'name': snapshot.data[index].name,
            'mobile': snapshot.data[index].mobile,
            'logo': snapshot.data[index].logo == null ||
                    snapshot.data[index].logo == ""
                ? ""
                : snapshot.data[index].logo,
            'coverPic': snapshot.data[index].coverPic,
            'email': snapshot.data[index].email,
            'website': snapshot.data[index].website,
            'country': snapshot.data[index].countryId,
            'location': snapshot.data[index].location,
            'workArea': snapshot.data[index].workArea,
            'managerName': snapshot.data[index].managerName,
            'ManagerNum': snapshot.data[index].managerMobile,
            'details': snapshot.data[index].details,
            'companyId': snapshot.data[index].companyId,
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewTradesmenView(
                        "company",
                        DataCompanyObject,
                      ))).then((value) => {
                DataCompanyObject = [],
                setState(
                  () {
                    ExitingCompanyData = DirectApiCalls.existingCompanyList()
                        as Future<List<DataCompany>>?;
                    print("==== #### 33 $ExitingCompanyData");
                  },
                ),
              });
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //  Get.put<AddTradesmenController>
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      //  backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: appBarColor,
        brightness: Brightness.dark,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);

            Get.delete<AddTradesmenController>();
          },
        ),
        title: Text(
          AppLocalizations.of("Manage") + " " + AppLocalizations.of("Company"),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<DataCompany>>(
          future: ExitingCompanyData,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              print("has data ");
              if (snapshot.hasData) {
                print("has data ");
                if (snapshot.data!.isEmpty) {
                  print("==== ### 11");

                  return ctr1.noCompanyView();
                }
                return Container(
                    // padding: EdgeInsets.only(top: 10),
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.bottomCenter,
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 0),
                                child: Column(children: [
                                  Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      shape: BoxShape.rectangle,
                                      color: settingsColor,
                                      border: new Border.all(
                                        color: settingsColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    width: double.infinity,
                                    height: 50,
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data![index].name!,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: (() {
                                      ctr1.selectedIndex = index;
                                      ctr1.companyId =
                                          snapshot.data![index].companyId!;
                                      print("companyId == ${ctr1.companyId}");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManageTradesmanView(
                                                      ctr1.companyId)));
                                    }),
                                    contentPadding: EdgeInsets.only(
                                        left: 10, bottom: 0, top: 5),
                                    leading: Container(
                                      margin:
                                          EdgeInsets.only(right: 5, left: 5),
                                      height: 50,
                                      width: 50,
                                      child: CircleAvatar(
                                        backgroundColor: settingsColor,
                                        child: ClipOval(
                                          child: snapshot.data![index].logo ==
                                                      null ||
                                                  snapshot.data![index].logo ==
                                                      ""
                                              ? Icon(
                                                  CustomIcons.employee,
                                                  size: 40,
                                                  color: Colors.white,
                                                )
                                              : Image.network(
                                                  snapshot.data![index].logo!,
                                                  fit: BoxFit.fill,
                                                  height: 50,
                                                  width: 50,
                                                ),
                                        ),
                                      ),
                                    ),
                                    title: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppLocalizations.of("Contact") +
                                            " " +
                                            AppLocalizations.of("number") +
                                            " : ${snapshot.data![index].mobile.toString()}",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 0),
                                      child: Text(AppLocalizations.of("Work") +
                                          " " +
                                          AppLocalizations.of("Area") +
                                          " : ${snapshot.data![index].workArea}"),
                                    ),
                                    trailing: IconButton(
                                        onPressed: (() {}),
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: settingsColor,
                                        )),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 10, bottom: 5),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(AppLocalizations.of(
                                          snapshot.data![index].createdAt!)),
                                    ),
                                  ),
                                  _actionRow(context, snapshot, index),
                                ]),
                              ),
                            ),
                          );
                        }));
              } else {
                return ctr1.noCompanyView();
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return Center(
                child: Container(
                    height: 30,
                    child: CircularProgressIndicator(
                      color: settingsColor,
                    )));
          },
        ),
      ),
    );
  }
}
