import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/audience_model.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/promote_post_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/models/address_search_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/utilities/colors.dart';

import '../../services/current_user.dart';

class EditAudienceAdvert extends StatefulWidget {
  final NewsFeedModel? feed;
  final String? memberID;
  final String? country;
  final String? logo;
  final String? memberName;
  final String? memberImage;
  final String? audienceId;
  final Function? refresh;

  EditAudienceAdvert(
      {Key? key,
      this.feed,
      this.memberID,
      this.country,
      this.logo,
      this.memberName,
      this.memberImage,
      this.audienceId,
      this.refresh})
      : super(key: key);

  @override
  _EditAudienceAdvertState createState() => _EditAudienceAdvertState();
}

class _EditAudienceAdvertState extends State<EditAudienceAdvert> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String all = "All";
  String men = "Men";
  String women = "Women";
  late String selectedGender;

  var selectedMinAge;
  var selectedMaxAge;
  bool showLocationList = false;

  bool allButton = false;
  bool menButton = false;
  bool womenButton = false;

  bool hasData = false;

  var minAgeList = new List<int>.generate(65, (i) => i + 1);
  var maxAgeList = new List<int>.generate(65, (i) => i + 1);

  late Addresses address;
  late Audiences audienceList;
  bool hasAudience = false;
  late String locations;
  late String audienceLocations;

  List selectedLocations = [];

  Future<String> getAudienceData() async {
    var url =
        "https://www.bebuzee.com/api/get_audience_data_seperate.php?action=get_audience_data_seperate&user_id=${widget.memberID}&audience_id=${widget.audienceId}";
    print("get audience data edit=${url}");
    var response = await ApiProvider().fireApi(url);

    if (response.statusCode == 200) {
      setState(() {
        selectedMinAge = response.data['age_from'].toInt();
        selectedMaxAge = response.data['age_to'].toInt();
        selectedGender = response.data['gender_type'];
        _nameController.text = response.data['audience_name'];
        selectedLocations =
            response.data['audience_location'].toString().split('~~').toList();
        hasAudience = true;
      });

      if (selectedGender == "Men") {
        setState(() {
          menButton = true;
        });
      } else if (selectedGender == "Women") {
        setState(() {
          womenButton = true;
        });
      } else {
        setState(() {
          allButton = true;
        });
      }
    }
    return "Success";
  }

  Future<String> updateAudienceData() async {
    print("update audience data called");

    var url =
        "https://www.bebuzee.com/api/audience_data_update.php?action=update_audience_data&user_id=${widget.memberID}&name=${_nameController.text}&audience_id=${widget.audienceId}&all_location=$locations&age_from=$selectedMinAge&age_to=$selectedMaxAge&gender_type=$selectedGender";
    var response = await ApiProvider().fireApi(url);
    print("update audien response=${response.data}");
    if (response.data['success'] == 1) {
      setState(() {
        print('update audience response=${response.data}');
      });
    }
    return "Success";
  }

  Future<List> getLocationData(String search) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/other/locationSuggestion?action=location_sugession&keywords=$search");

    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var response = await client
        .postUri(
          url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);
    print(response.data);
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

  @override
  void initState() {
    getAudienceData();
    print(widget.memberID);
    print(widget.audienceId);
    print(selectedGender);
    setState(() {
      // selectedGender = all;
      //selectedMinAge = 18;
      //selectedMaxAge = 65;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 4.0.h),
      child: hasAudience
          ? Container(
              child: Wrap(
                children: [
                  Text(
                    "Edit Audience",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1.0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Make sure that you save your edits once you've finished.",
                          style: greyNormal,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Text(
                            AppLocalizations.of(
                              'Name',
                            ),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 14),
                          ),
                        ),
                        Container(
                          height: 5.0.h,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.0.h),
                            child: Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                  onTap: () {
                                    setState(() {});
                                  },
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  controller: _nameController,
                                  keyboardType: TextInputType.text,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryBlueColor,
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      hintText: AppLocalizations.of(
                                        'Name',
                                      ),
                                      contentPadding:
                                          EdgeInsets.only(left: 1.0.h)

                                      // 48 -> icon width
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Text(
                            AppLocalizations.of(
                              'Gender',
                            ),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 14),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          side:
                                              BorderSide(color: Colors.grey))),
                                  backgroundColor: MaterialStateProperty.all(
                                      allButton == true
                                          ? primaryBlueColor
                                          : Colors.white)),

                              onPressed: () {
                                setState(() {
                                  allButton = true;
                                  womenButton = false;
                                  menButton = false;
                                  selectedGender = all;
                                  print(selectedGender);
                                });
                              },
                              // color: allButton == true
                              //     ? primaryBlueColor
                              //     : Colors.white,
                              child: Text(
                                all,
                                style: TextStyle(
                                    color: allButton == true
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          side:
                                              BorderSide(color: Colors.grey))),
                                  backgroundColor: MaterialStateProperty.all(
                                      menButton == true
                                          ? primaryBlueColor
                                          : Colors.white)),
                              onPressed: () {
                                setState(() {
                                  allButton = false;
                                  womenButton = false;
                                  menButton = true;
                                  selectedGender = men;
                                  print(selectedGender);
                                });
                              },
                              child: Text(
                                men,
                                style: TextStyle(
                                    color: menButton == true
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      womenButton == true
                                          ? primaryBlueColor
                                          : Colors.white),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0.0),
                                          side:
                                              BorderSide(color: Colors.grey)))),
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(0.0),
                              //     side: BorderSide(color: Colors.grey)),
                              onPressed: () {
                                setState(() {
                                  allButton = false;
                                  womenButton = true;
                                  menButton = false;
                                  selectedGender = women;
                                  print(selectedGender);
                                });
                              },
                              // color: womenButton == true
                              //     ? primaryBlueColor
                              //     : Colors.white,
                              child: Text(
                                women,
                                style: TextStyle(
                                    color: womenButton == true
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Text(
                            AppLocalizations.of(
                              'Age',
                            ),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 14),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: DropdownButton(
                                  isExpanded: false,
                                  //hint: Text("Select Category "),
                                  items: minAgeList.map((e) {
                                    return DropdownMenuItem(
                                      child: Text((e.toString())),
                                      value: e,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedMinAge = val;
                                    });

                                    print(selectedMinAge);
                                  },
                                  value: selectedMinAge,
                                ),
                              ),
                            ),
                            Text("  to  "),
                            Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: DropdownButton(
                                  isExpanded: false,
                                  //hint: Text("Select Category "),
                                  items: maxAgeList.map((e) {
                                    return DropdownMenuItem(
                                      child: Text((e.toString())),
                                      value: e,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedMaxAge = val;
                                    });

                                    print(selectedMaxAge);
                                  },
                                  value: selectedMaxAge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Text(
                      AppLocalizations.of(
                        'Locations',
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14),
                    ),
                  ),
                  selectedLocations.length > 0
                      ? ListView.builder(
                          itemCount: selectedLocations.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
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
                                      horizontal: 2.0.w, vertical: 0.5.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(selectedLocations[index].toString()),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedLocations.removeAt(index);
                                            locations =
                                                selectedLocations.join('~~');
                                          });

                                          print(selectedLocations);
                                        },
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3.0.w),
                                              child: Icon(
                                                Icons.delete,
                                                size: 20,
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                  Container(
                    height: 5.0.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.0.h),
                      child: Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: TextFormField(
                            onTap: () {
                              setState(() {});
                            },
                            onChanged: (string) {
                              if (string == "") {
                                getLocationData("");

                                setState(() {
                                  showLocationList = false;
                                });
                              } else {
                                setState(() {
                                  showLocationList = true;
                                });

                                print(string);
                                getLocationData(string);
                              }
                            },
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            controller: _locationController,
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
                                  "Add Location",
                                ),
                                contentPadding: EdgeInsets.only(left: 1.0.h)

                                // 48 -> icon width
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  showLocationList == true && hasData == true
                      ? StatefulBuilder(builder: (context, setState) {
                          return Container(
                            height: 30.0.h,
                            child: ListView.builder(
                              itemCount: address.addresses.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return LocationsList(
                                  onPress: () {
                                    this.setState(() {
                                      selectedLocations.add(address
                                          .addresses[index].formattedAddress);
                                      locations = selectedLocations.join('~~');
                                      print(selectedLocations);
                                    });
                                  },
                                  location: address.addresses[index].name,
                                  formattedLocation:
                                      address.addresses[index].formattedAddress,
                                );
                              },
                            ),
                          );
                        })
                      : Container(),
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
                                      borderRadius: BorderRadius.circular(0.0),
                                      side: BorderSide(color: Colors.grey)))),
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
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryBlueColor),
                            // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(0.0),
                            //     side: BorderSide(color: Colors.grey)))
                          ),
                          onPressed: () {
                            print(selectedMinAge.toString());
                            print(selectedMaxAge.toString());
                            print(locations);

                            if (_nameController.text.isEmpty) {
                              ScaffoldMessenger.of(
                                      _scaffoldKey.currentState!.context)
                                  .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                          'Enter audience name')));
                            } else if (selectedLocations.length == 0) {
                              ScaffoldMessenger.of(
                                      _scaffoldKey.currentState!.context)
                                  .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                          'Enter atleast one location')));
                            } else {
                              updateAudienceData();
                              widget.refresh!();
                              Navigator.pop(context);
                            }
                          },
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
            )
          : Container(),
    );
  }
}
