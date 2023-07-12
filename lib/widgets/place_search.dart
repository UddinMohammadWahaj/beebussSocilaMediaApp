import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/tags_search_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/discover_search_page.dart';
import 'package:bizbultest/view/locations_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/models/place_model.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/models/people_search_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PlacesSearchPage extends StatefulWidget {
  final String? search;
  final String? memberID;
  final String? country;
  final double? lat;
  final double? long;
  final String? memberImage;
  final bool? hasData;
  final DiscoverSearchPageState? parent;

  PlacesSearchPage(
      {Key? key,
      this.search,
      this.memberID,
      this.hasData,
      this.parent,
      this.country,
      this.lat,
      this.long,
      this.memberImage})
      : super(key: key);

  @override
  _PlacesSearchPageState createState() => _PlacesSearchPageState();
}

class _PlacesSearchPageState extends State<PlacesSearchPage> {
  String? latitude;
  String? longitude;
  Places? placesList;
  bool? hasData = false;
  String? searchCurrent = "";
  bool? coordinatesLoaded = false;

  Future<void> getPlaces(text) async {
    print("text is:" + text);

    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=near_by_places&keywords=$text&lat=${widget.lat}&long=${widget.long}&country=${widget.country}");

    // var response = await http.get(url);
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/other/locationSuggestion?keywords=$text');
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var client = Dio();
    var response = await client
        .postUri(newurl,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }))
        .then((value) => value);
    //print(response.body);
    if (response.statusCode == 200) {
      print("Places suggestion response from the api=${response}");
      Places placeData = Places.fromJson(response.data['data']);

      //print(peopleData.people[0].name);
      setState(() {
        placesList = placeData;
        hasData = true;
      });

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          hasData = false;
        });
      }
    }
  }

  Future<void> getCoordinates(String name) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope.php?action=get_latlong_location_data&location=$name");

    // var response = await http.get(url);
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/other/locationLetLong?location=$name');

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
    print('coordinates loadeddd ${response.data}');
    print("url of place=${newurl}");
    if (response.statusCode == 200 && response.data['success'] != 0) {
      setState(() {
        latitude = (response.data['data']['lat']);
        longitude = (response.data['data']['long']);
        coordinatesLoaded = true;
      });
    }
    if (response.statusCode == 200 && response.data['success'] == 0) {
      setState(() {
        coordinatesLoaded = false;
      });
    }

    if (response.data == null || response.statusCode != 200) {
      setState(() {
        coordinatesLoaded = false;
      });
    }
  }

  @override
  void initState() {
    print(widget.memberID);
    print(widget.search);
    placesList = Places([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("lat=${widget.long} long=${widget.lat}");
    if (widget.parent!.searchText != "") {
      if (searchCurrent != widget.parent!.searchText) {
        getPlaces(widget.parent!.searchText);
      }
      searchCurrent = widget.parent!.searchText;
    } else {
      placesList!.places = [];
    }
    return GestureDetector(
      child: Container(
          child: hasData == true
              ? ListView.builder(
                  itemCount: placesList!.places.length,
                  itemBuilder: (context, index) {
                    var places = placesList!.places[index];

                    return ListTile(
                      onTap: () async {
                        await getCoordinates(places.formattedAddress!)
                            .then((value) {});
                        if (coordinatesLoaded == true) {
                          print(
                              "coordinateees= long=${longitude} lat=${latitude}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationPage(
                                        memberImage: widget.memberImage!,
                                        country: widget.country!,
                                        memberID: widget.memberID!,
                                        locationName: places.formattedAddress!,
                                        longitude: longitude!,
                                        latitude: latitude!,
                                      )));
                        } else {
                          Get.snackbar(
                              'Not found', 'No post for this location yet',
                              backgroundColor: Colors.white);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => LocationPage(
                          //               memberImage: widget.memberImage,
                          //               country: widget.country,
                          //               memberID: widget.memberID,
                          //               locationName: places.formattedAddress,
                          //               longitude: longitude,
                          //               latitude: latitude,
                          //             )));
                        }
                      },
                      dense: false,
                      leading: Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: Colors.black.withOpacity(0.6),
                            width: 0.5,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      title: Text(
                        places.name!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        places.formattedAddress!,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  },
                )
              : Container()),
    );
  }
}
