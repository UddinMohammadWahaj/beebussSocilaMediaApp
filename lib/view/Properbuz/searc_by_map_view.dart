import 'dart:async';
import 'dart:typed_data';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/find_tradsemen_view.dart';
import 'package:location/location.dart' as loc;
import 'package:bizbultest/models/Properbuz/SearchTextLocationModel.dart';
import 'package:bizbultest/services/Properbuz/api/searchbymapapi.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/searchbymapitem.dart';
import 'package:bizbultest/view/Properbuz/searchbymaplocationlist.dart';
import 'package:bizbultest/widgets/Properbuz/GoogleMap/searchbymaplocationsearch.dart';
import 'package:bizbultest/widgets/Properbuz/property/searchbymapdetail.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../../Language/appLocalization.dart';
import '../../utilities/colors.dart';

class MyPainter extends CustomPainter {
  //         <-- CustomPainter class
  RxList<Offset> lstoffset;
  RxInt drawstatus;

  MyPainter(this.lstoffset, this.drawstatus);

  @override
  void paint(Canvas canvas, Size size) {
    print("painttting");
    final pointMode = ui.PointMode.polygon;

    final paint = Paint()
      ..color = hotPropertiesThemeColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(pointMode, this.lstoffset, paint);
    if (drawstatus.value == 2) {
      canvas.drawPoints(
          pointMode,
          [this.lstoffset[0], this.lstoffset[this.lstoffset.length - 1]],
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

class SearchByMapView extends GetView<SearchByMapController> {
  MapSearchType? maptype;

  SearchByMapView({
    this.maptype,
  });
  Widget _customButton(String title, Color color, ui.VoidCallback onTap) {
    return ElevatedButton(
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onTap,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          elevation: MaterialStateProperty.all(10)),
    );
  }

  // ignore: unused_element
  Widget _customMessage(String title,
      {Color color = Colors.white, Color titleColor = Colors.grey}) {
    return Container(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(title, style: TextStyle(color: titleColor)),
          ),
        ],
      ),
    );
  }

  Widget _bottomAppBar(int drawStatus, BuildContext context) {
    switch (drawStatus) {
      case 0:
        if (this.maptype == MapSearchType.searchByMetro)
          return _customButton(
              AppLocalizations.of('Tap on a metro station to continue'),
              Colors.white, () {
            controller.drawStatus.value = 2;
          });
        else if (this.maptype == MapSearchType.searchByName) {
          return _customMessage(
              AppLocalizations.of(
                  'Type the address to select your desired location'),
              color: hotPropertiesThemeColor,
              titleColor: Colors.white);
        }
        return _customButton(
            AppLocalizations.of('DRAW THE AREA'), hotPropertiesThemeColor, () {
          controller.mapEnabled.value = false;
          controller.drawStatus.value = 1;
        });
      case 1:
        return _customMessage(
            AppLocalizations.of('Drag and draw an area to search'));
      case 2:
        return _customButton(
            AppLocalizations.of('Search').toUpperCase(), Colors.red, () {
          if (this.maptype == MapSearchType.searchByMetro) {
            print("current selected metro ${controller.selectedLatLong}");

            controller.fetchMetroPropertyList();
          } else if (this.maptype == MapSearchType.searchByDraw) {
            controller.fetchPropertyDetailsDraw();
          } else
            controller.fetchPropertyDetails();
          Navigator.of(Get.context!).push(MaterialPageRoute(
              builder: (context) => SearchByMapLocationList(
                  from: this.maptype == MapSearchType.searchByMetro
                      ? 'metro'
                      : '')));
        });

      default:
        return _customButton(
            AppLocalizations.of('DRAW THE AREA'), hotPropertiesThemeColor, () {
          controller.drawStatus.value = 1;
        });
    }
  }

  Widget _customTextField(
      TextEditingController textEditingController, String labelText) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                labelText,
                style: TextStyle(fontSize: 15, color: controller.textColor),
              )),
          (controller.drawStatus.value != 2)
              ? TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: controller.searchTextLoc,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[350],
                      contentPadding: EdgeInsets.all(10),
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: hotPropertiesThemeColor,
                      ),

                      hintText: AppLocalizations.of("Enter Address"),

                      hintStyle: TextStyle(
                        fontSize: 20,
                      ),

                      border: InputBorder.none,

                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      // 48 -> icon width
                    ),
                  ),
                  onSuggestionSelected: (Result suggestion) async {
                    newdata = "";
                    controller.searchTextLoc.text =
                        suggestion.formattedAddress.toString();
                    newdata = suggestion.formattedAddress.toString();
                    // newdata = controller.searchTextLoc.text;
                    controller.currentMapSearchType.value = this.maptype!;

                    if (this.maptype == MapSearchType.searchByName) {
                      Navigator.of(Get.context!).push(MaterialPageRoute(
                        builder: (context) => SearchByMapLocationList(
                          from: 'metro',
                        ),
                      ));
                      controller.currentLocation = LatLng(
                          suggestion.geometry!.location!.lat!,
                          suggestion.geometry!.location!.lng!);
                      controller.getSearchByName(
                          suggestion.geometry!.location!.lat!,
                          suggestion.geometry!.location!.lng!,
                          page: 1);
                      controller.selectedLatLong.clear();
                      controller.selectedLatLong
                          .add(controller.currentLocation);
                    } else
                      controller.controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                              controller.positonMapToNewLocation(
                                  suggestion.geometry!.location!.lat!,
                                  suggestion.geometry!.location!.lng!)));
                  },
                  itemBuilder: (context, Result suggestion) {
                    print("sugesstion aya-- ${suggestion.name}");

                    return ListTile(
                      leading: Icon(Icons.location_city),
                      title: Text(suggestion.isBlank!
                          ? AppLocalizations.of('No Location Found |||')
                          : AppLocalizations.of(suggestion.formattedAddress!)),
                      subtitle: Text(suggestion.isBlank!
                          ? ''
                          : AppLocalizations.of('${suggestion.name}')),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    print(" 33333" + pattern);
                    return await SearchByMapApi.getLocDetails(pattern);
                  },
                )
              // TextFormField(
              //     enabled: false,
              //     cursorColor: controller.textColor,
              //     autofocus: false,
              //     controller: textEditingController,
              //     maxLines: 1,
              //     textAlign: TextAlign.left,
              //     keyboardType: TextInputType.text,
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 14,
              //         fontWeight: FontWeight.normal),
              //     decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.location_city),
              //       hintText: (controller.message.value != '')
              //           ? controller.message.value
              //           : "Enter Address",

              //       hintStyle: TextStyle(
              //         fontSize: 20,
              //       ),
              //       contentPadding: EdgeInsets.all(10),

              //       border: InputBorder.none,

              //       focusedBorder: InputBorder.none,
              //       enabledBorder: InputBorder.none,
              //       errorBorder: InputBorder.none,
              //       disabledBorder: InputBorder.none,
              //       // 48 -> icon width
              //     ),
              //   )
              : (this.maptype != MapSearchType.searchByName)
                  ? _customButton(
                      AppLocalizations.of('RESET'), hotPropertiesThemeColor,
                      () {
                      controller.mapEnabled.value = true;
                      controller.lstoffset.value = [];
                      controller.selectedLatLong.value = [];
                      controller.circleset.value = {};
                      if (this.maptype != MapSearchType.searchByMetro)
                        controller.drawStatus.value = 1;
                      if (this.maptype == MapSearchType.searchByMetro)
                        controller.drawStatus.value = 0;
                    })
                  : SizedBox(
                      height: 0,
                    ),
        ],
      ),
    );
  }

  Set<Marker> getData() {
    Set<Marker> lst = {};
    List<Marker> markerList = [];
    controller.selectedLatLong.forEach((element) {
      lst.add(Marker(
        icon: BitmapDescriptor.fromBytes(controller.markerIcon as Uint8List),
        onDragEnd: (x) {
          print("dragging");
        },
        markerId: MarkerId('${element.latitude}${element.longitude}'),
        position: element,
      ));
    });
    print('getdata called $lst');
    lst.forEach((element) {
      markerList.add(element);
    });
    print(
        "latlong====${Marker(markerId: MarkerId('value'), anchor: Offset(50, 100)).position}");
    markerList[0].anchor;
    return lst;
  }

  goBack(BuildContext context) {
    switch (controller.drawStatus.value) {
      case 1:
        controller.drawStatus.value = 0;
        controller.selectedLatLong.clear();
        break;
      default:
        Navigator.of(context).pop();
        Get.delete<SearchByMapController>();
        break;
    }
  }

  Widget _customTextButton(BuildContext context, colors) {
    return TextButton(
        onPressed: () {
          locationController.text = newdata;
          goBack(context);
          Navigator.of(context).pop();
        },
        child: Text(
          "Done",
          style: TextStyle(color: colors),
        ));
  }

  List<LatLng> createPoints() {
    final List<LatLng> points = <LatLng>[];

    points.add(LatLng(1.875249, 0.845140));
    points.add(LatLng(4.851221, 1.715736));
    points.add(LatLng(8.196142, 2.094979));
    points.add(LatLng(12.196142, 3.094979));
    points.add(LatLng(16.196142, 4.094979));
    points.add(LatLng(20.196142, 5.094979));
    return points;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SearchByMapController(maptype: this.maptype!));
    // TODO: implement build
    // final Polyline polyline = Polyline(
    //   polylineId: PolylineId('s'),
    //   consumeTapEvents: true,
    //   color: settingsColor,
    //   width: 5,
    //   points: createPoints(),
    // );
    // Function goBack() {
    //   switch (controller.drawStatus.value) {
    //     case 1:
    //       controller.drawStatus.value = 0;
    //       controller.selectedLatLong.clear();
    //       break;
    //     default:
    //       Navigator.of(context).pop();
    //       Get.delete<SearchByMapController>();
    //       break;
    //   }
    // }

    return WillPopScope(
      onWillPop: () async {
        goBack(context);
        if (controller.drawStatus.value != 1)
          return true;
        else
          return false;
      },
      child: Obx(
        () => Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: BackButton(
                color: Colors.black,
                onPressed: () {
                  goBack(context);
                },
              ),
              backgroundColor: Colors.transparent,
              toolbarHeight: kToolbarHeight * 1.2,
              title: (controller.drawStatus.value != 1)
                  ? _customTextField(controller.searchTextLoc, '')
                  : Text(AppLocalizations.of('Tap to draw an area '),
                      style: TextStyle(
                          color: hotPropertiesThemeColor, fontSize: 20)),
              actions: <Widget>[
                Container(),
              ],
            ),
            body:
                // this.maptype == MapSearchType.searchByName
                //     ? Container(
                //         child: Center(
                //             child: Text(
                //         'No Properties found',
                //         style: TextStyle(color: settingsColor, letterSpacing: 2),
                //       )))
                //     :
                Obx(
              () => GestureDetector(
                  onTap: () {
                    print("tapped");
                  },
                  onPanUpdate: (loc) {
                    print("updatee called -- ${controller.drawStatus.value}");
                    if (controller.drawStatus.value == 1) {
                      final box = context.findRenderObject() as RenderBox;
                      final point = box.globalToLocal(loc.globalPosition);

                      print(
                          "-----11 ${loc.localPosition.dx.toInt()} ${loc.localPosition.dy.toInt()}");

                      // controller.convertOffsettoLatLng(
                      //     loc.localPosition.dx.toInt(),
                      //     loc.localPosition.dy.toInt());
                      controller.convertOffsettoLatLng(
                          loc.localPosition.dx, loc.localPosition.dy);
                      // controller.setOffset(
                      //     Offset(loc.localPosition.dx, loc.localPosition.dy));
                    }
                  },
                  onPanEnd: (f) {
                    controller.convertOffsetToScreenCoordinates();
                    if (controller.drawStatus.value == 1)
                      controller.drawStatus.value = 2;
                  },
                  onPanStart: (loc) {
                    print("updateee");
                    print("${loc.localPosition.direction}");
                    if (controller.drawStatus.value == 1) {
                      final box = context.findRenderObject() as RenderBox;
                      final point = box.globalToLocal(loc.globalPosition);

                      print(
                          "${loc.localPosition.dx.toInt()},${loc.localPosition.dy.toInt()}");

                      // controller.convertOffsettoLatLng(
                      //     loc.localPosition.dx.toInt(),
                      //     loc.localPosition.dy.toInt());
                      // controller.setOffset(
                      //     Offset(loc.localPosition.dx, loc.localPosition.dy));
                    }
                  },
                  child: RepaintBoundary(
                    child: CustomPaint(
                      foregroundPainter: (controller.lstoffset.length > 0)
                          ? MyPainter(
                              controller.lstoffset, controller.drawStatus)
                          : MyPainter(
                              controller.lstoffset, controller.drawStatus),
                      child: GoogleMap(
                        circles: controller.circleset.length == 0
                            ? controller.circleset
                            : controller.circleset,
                        zoomControlsEnabled:
                            this.maptype == MapSearchType.searchByMetro
                                ? true
                                : (controller.drawStatus.value >= 1)
                                    ? false
                                    : true,
                        zoomGesturesEnabled:
                            this.maptype == MapSearchType.searchByMetro
                                ? true
                                : (controller.drawStatus.value >= 1)
                                    ? false
                                    : true,
                        scrollGesturesEnabled:
                            (controller.drawStatus.value == 1) ? false : true,
                        onTap: (argument) {
                          var lat = argument.latitude,
                              long = argument.longitude;

                          if (controller.drawStatus.value == 1)
                            controller.addMarker(lat, long);
                        },
                        mapToolbarEnabled: true,
                        gestureRecognizers: (controller.drawStatus.value >= 1 &&
                                this.maptype != MapSearchType.searchByMetro)
                            ? <Factory<OneSequenceGestureRecognizer>>[].toSet()
                            : <Factory<OneSequenceGestureRecognizer>>[
                                new Factory<OneSequenceGestureRecognizer>(
                                  () => new EagerGestureRecognizer(),
                                ),
                              ].toSet(),
                        markers: controller.markset.value,
                        // polygons: controller.selectedLatLong.length == 0
                        //     ? {}
                        //     : {
                        //         Polygon(
                        //             polygonId: PolygonId('s'),
                        //             points: controller.selectedLatLong)
                        //       },
                        // polylines: {
                        //   Polyline(
                        //     polylineId: PolylineId('s'),
                        //     consumeTapEvents: true,
                        //     color: settingsColor,
                        //     width: 5,
                        //     points: controller.selectedLatLong.value,
                        //   )
                        // },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onMapCreated: (gmapController) async {
                          await loc.Location.instance
                              .getLocation()
                              .then((value) {
                            controller.currentLocation =
                                LatLng(value.latitude!, value.longitude!);
                            print(
                                "current location=${controller.currentLocation}");
                          });
                          controller.mapcontroller.complete(gmapController);
                          await gmapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  controller.positonMapToCurrentLocation()));
                        },
                        initialCameraPosition: CameraPosition(
                          target: (controller.currentLocation != null)
                              ? controller.currentLocation
                              : LatLng(20.5937, 78.9629),
                        ),
                      ),
                    ),
                  )
                  // : GoogleMap(
                  //     scrollGesturesEnabled: false,
                  //     onTap: (argument) {
                  //       var lat = argument.latitude,
                  //           long = argument.longitude;
                  //       controller.addMarker(lat, long);
                  //     },
                  //     markers: controller.selectedLatLong.length == 0
                  //         ? <Marker>{}
                  //         : () {
                  //             Set<Marker> lst = {};
                  //             controller.selectedLatLong.forEach((element) {
                  //               lst.add(Marker(
                  //                   markerId: null, position: element));
                  //             });
                  //             return lst;
                  //           },
                  //     initialCameraPosition:
                  //         CameraPosition(target: LatLng(22.4, 22.1))),
                  ),
            ),
            // floatingActionButton: FloatingActionButton(
            //   child: Icon(
            //     Icons.gps_fixed,
            //     color: settingsColor,
            //   ),
            //   backgroundColor: Colors.white,
            //   onPressed: () {},
            // ),
            bottomNavigationBar: Container(
                width: Get.size.width,
                height: kToolbarHeight,
                color: hotPropertiesThemeColor,
                child: _bottomAppBar(controller.drawStatus.value, context))),
      ),
    );
  }
}
