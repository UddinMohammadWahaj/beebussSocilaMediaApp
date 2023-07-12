import 'dart:async';
import 'dart:math';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/nearby_places_chat_model.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import 'controllers/chat_home_controller.dart';

class LocationSharing extends StatefulWidget {
  final Function? sendLocation;

  const LocationSharing({Key? key, this.sendLocation}) : super(key: key);

  @override
  _LocationSharingState createState() => _LocationSharingState();
}

class _LocationSharingState extends State<LocationSharing> {
  String _bingURL = "";

  late NearbyPlaces _nearbyPlaces;
  late double latitude;
  late double longitude;
  bool isLocationNull = true;
  ChatHomeController chatHomeController = Get.put(ChatHomeController());
  late Future _nearbyLocations;
  String _bingKey =
      "AiXVR299olZyoi4WEeUBcr5qIIHVBFIuiQwsYSiC0b8gspd3Ig5xP_JMF44bloyQ";

  late MapZoomPanBehavior _zoomPanBehavior;
  ScreenshotController screenshotController = ScreenshotController();
  late Future _mapFuture;

  var markerKey = GlobalKey();
  Offset _position = Offset(100, 100);

  void _calculatePosition() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final RenderObject? box = markerKey.currentContext!.findRenderObject();

      final RenderRepaintBoundary? box =
          markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      setState(() {
        _position = box!.localToGlobal(Offset.zero);
      });
      print(_position);
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890eiamdakk33r33433kkfwmkppvj58298ghha';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  void _getNearbyPlaces() {
    _nearbyLocations = DirectApiCalls.getNearbyPlaces(
            _currentLocation.latitude.toString(),
            _currentLocation.longitude.toString())
        .then((value) {
      setState(() {
        _nearbyPlaces = value;
      });
      return value;
    });
  }

  Widget _buildBingMap(String urlTemplate) {
    return SfMaps(
      layers: [
        MapTileLayer(
          initialMarkersCount: 5,
          markerBuilder: (BuildContext context, int index) {
            return MapMarker(
              latitude: latitude,
              longitude: longitude,
              iconColor: Colors.blue,
              iconStrokeColor: Colors.black,
              iconStrokeWidth: 2,
            );
          },
          markerTooltipBuilder: (BuildContext context, int index) {
            return Container(
              child: Icon(Icons.location_on),
            );
          },
          urlTemplate: urlTemplate,
          zoomPanBehavior: _zoomPanBehavior,
        ),
      ],
    );
  }

  late LocationData _currentLocation;

  Future<void> _getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      _currentLocation = _locationData;
      latitude = _currentLocation.latitude!;
      longitude = _currentLocation.longitude!;
      _mapFuture = getBingUrlTemplate(_bingURL);
      isLocationNull = false;
    });
    /*Timer(Duration(seconds: 2), () {
      _calculatePosition();
    });*/

    _getNearbyPlaces();
  }

  void _sendLocation(String locationTitle, String locationSubtitle) {
    String filename = "location_${generateRandomString(8)}.jpg";

    screenshotController
        .captureAndSave(
            chatHomeController
                .thumbsPath.value, //set path where screenshot will be saved
            fileName: filename)
        .then((value) {
      widget.sendLocation!(
          value, latitude, longitude, locationTitle, locationSubtitle);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    _getLocation().then((value) {
      _zoomPanBehavior = MapZoomPanBehavior(
        minZoomLevel: 10,
        maxZoomLevel: 22,
        zoomLevel: 15,
        focalLatLng: MapLatLng(latitude, longitude),
      );
    });
    _bingURL =
        'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/RoadOnDemand?output=json&uriScheme=https&include=ImageryProviders&key=' +
            _bingKey;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(
            "Send location",
          ),
          style: TextStyle(fontSize: 20),
        ),
        flexibleSpace: gradientContainer(null),
      ),
      body: isLocationNull == false
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: Container(
                      height: 300,
                      child: FutureBuilder(
                        future: _mapFuture,
                        builder: (BuildContext context, dynamic snapshot) {
                          if (snapshot.hasData) {
                            final String urlTemplate = snapshot.data;
                            return _buildBingMap(urlTemplate);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 105,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Text(
                            AppLocalizations.of(
                              "Nearby places",
                            ),
                            style: greyNormal.copyWith(fontSize: 14),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            _sendLocation("", "");
                          },
                          title: Text(
                              AppLocalizations.of(
                                "Send your current location",
                              ),
                              style: TextStyle(color: darkColor, fontSize: 17)),
                          leading: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: darkColor,
                                width: 1.2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: new Border.all(
                                    color: darkColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    radius: 5,
                                    backgroundColor: darkColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100.0.h - (300 + 105 + 80 + 7),
                    child: FutureBuilder(
                        future: _nearbyLocations,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: _nearbyPlaces.places.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          _sendLocation(
                                              _nearbyPlaces.places[index].name!,
                                              _nearbyPlaces
                                                  .places[index].addressLine!);
                                          /* longitude = _nearbyPlaces.places[index].longitude;
                                          latitude = _nearbyPlaces.places[index].latitude;
                                          _mapFuture = getBingUrlTemplate(_bingURL);*/
                                        });
                                        print("tappped");
                                      },
                                      title: Text(
                                          _nearbyPlaces.places[index].name!,
                                          style: TextStyle(fontSize: 18)),
                                      leading: Icon(
                                        Icons.location_on,
                                        size: 25,
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Container();
                          }
                        }),
                  )
                ],
              ),
            )
          : Container(),
    );
  }
}
