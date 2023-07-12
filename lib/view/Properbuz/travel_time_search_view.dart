import 'dart:async';
import 'dart:typed_data';
import 'package:bizbultest/models/Properbuz/SearchTextLocationModel.dart';
import 'package:bizbultest/services/Properbuz/api/searchbymapapi.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/searchbymaplocationlist.dart';
import 'package:bizbultest/widgets/Properbuz/GoogleMap/searchbymaplocationsearch.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class TravelTimeSearchView extends GetView<SearchByMapController> {
  String from = "";

  TravelTimeSearchView({this.from = ''});
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

  Widget _customMessage() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              AppLocalizations.of('Drag and draw an area to search'),
              style: TextStyle(color: controller.textColor),
            ),
          ),
          // ButtonBar(
          //   alignment: MainAxisAlignment.center,
          //   children: [
          //     _customButton('Reset', settingsColor, () {
          //       controller.selectedLatLong.clear();
          //     }),
          //     _customButton('Confirm', settingsColor, () {
          //       controller.drawStatus.value = 0;
          //       controller.selectedLatLong.clear();
          //     }),
          //   ],
          // )
        ],
      ),
    );
  }

  Widget _bottomAppBar(int drawStatus) {
    switch (drawStatus) {
      case 0:
        return _customButton(
            AppLocalizations.of('CHOOSE A POINT ON MAP'), Colors.white, () {});
      case 1:
        return _customMessage();
      case 2:
        return _customButton(
            AppLocalizations.of('Search').toUpperCase(), Colors.red, () {
          controller.fetchPropertyDetails();
          Navigator.of(Get.context!).push(MaterialPageRoute(
              builder: (context) => SearchByMapLocationList(from: "metro")));
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
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 45,
            decoration: new BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(5)),
              shape: BoxShape.rectangle,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(Get.context!).push(MaterialPageRoute(
                  builder: (context) => LocationSearchPageMap(),
                ));
              },
              child: (controller.drawStatus.value != 2)
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
                        controller.searchTextLoc.text =
                            suggestion.formattedAddress.toString();

                        controller.controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                                controller.positonMapToNewLocation(
                                    suggestion.geometry!.location!.lat!,
                                    suggestion.geometry!.location!.lng!)));
                      },
                      itemBuilder: (context, Result suggestion) {
                        print("sugesstion aya ${suggestion.name}");

                        return ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text(suggestion.isBlank!
                              ? AppLocalizations.of('No Location Found')
                              : AppLocalizations.of(
                                  suggestion.formattedAddress!)),
                          subtitle: Text(suggestion.isBlank!
                              ? ''
                              : AppLocalizations.of('${suggestion.name}')),
                        );
                      },
                      suggestionsCallback: (pattern) async {
                        print(pattern);
                        return await SearchByMapApi.getLocDetails(pattern);
                      },
                    )

                  //  TextFormField(
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
                  : _customButton(
                      AppLocalizations.of('Reset'), hotPropertiesThemeColor,
                      () {
                      controller.mapEnabled.value = true;
                      controller.lstoffset.value = [];
                      controller.selectedLatLong.value = [];
                      controller.drawStatus.value = 1;
                    }),
            ),
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
    Get.put(SearchByMapController());
    // TODO: implement build
    // final Polyline polyline = Polyline(
    //   polylineId: PolylineId('s'),
    //   consumeTapEvents: true,
    //   color: settingsColor,
    //   width: 5,
    //   points: createPoints(),
    // );
    goBack() {
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

    IconData? getIcon(int value) {
      switch (value) {
        case 0:
          return Icons.drive_eta;

        case 1:
          return Icons.pedal_bike;
        case 2:
          return Icons.directions_walk;
        case 3:
          return Icons.circle_sharp;
        default:
          return null;
      }
    }

    Widget _tabCard(int value, var index) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Icon(
            getIcon(value),
            size: 30,
          ));
    }

    return WillPopScope(
      onWillPop: () async {
        goBack();
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
                goBack();
              },
            ),
            backgroundColor: Colors.transparent,
            toolbarHeight: kToolbarHeight * 1.2,
            title: _customTextField(TextEditingController(), ''),
            actions: [],
          ),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Obx(
                () => GestureDetector(
                    onTap: () {
                      print("tapped");
                    },
                    onPanUpdate: (loc) {
                      print("updatee called");
                      if (controller.drawStatus.value == 1) {
                        final box = context.findRenderObject() as RenderBox;
                        final point = box.globalToLocal(loc.globalPosition);

                        print(
                            "${loc.localPosition.dx.toInt()} ${loc.localPosition.dy.toInt()}");

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
                    child: GoogleMap(
                      // zoomControlsEnabled:
                      //     (controller.drawStatus.value >= 1) ? false : true,
                      // zoomGesturesEnabled:
                      //     (controller.drawStatus.value >= 1) ? false : true,
                      // scrollGesturesEnabled:
                      //     (controller.drawStatus.value == 1) ? false : true,
                      onTap: (argument) async {
                        var lat = argument.latitude, long = argument.longitude;
                        print("hua bvoss");
                        await controller.controller.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(lat, long),
                                zoom: 15.151926040649414)));
                        if (controller.drawStatus.value == 0) {
                          controller.ttsaddMarker(lat, long);
                          controller.setCircle(lat, long);
                        }
                      },
                      mapToolbarEnabled: true,
                      gestureRecognizers: (controller.drawStatus.value! >= 1)
                          ? <Factory<OneSequenceGestureRecognizer>>[].toSet()
                          : <Factory<OneSequenceGestureRecognizer>>[
                              new Factory<OneSequenceGestureRecognizer>(
                                () => new EagerGestureRecognizer(),
                              ),
                            ].toSet(),
                      circles: {controller.circle.value},
                      markers: {controller.selectedMarker.value},
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
                        controller.mapcontroller.complete(gmapController);
                        await loc.Location.instance.getLocation().then((value) {
                          controller.currentLocation =
                              LatLng(value.latitude!, value.longitude!);
                          print(
                              "current location=${controller.currentLocation}");
                        });
                        await gmapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                                controller.positonMapToCurrentLocation()));
                      },
                      initialCameraPosition: CameraPosition(
                          target: (controller.currentLocation != null)
                              ? controller.currentLocation
                              : LatLng(22.4, 22.1)),
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
              Positioned(
                  child: Container(
                      color: Colors.white,
                      height: kToolbarHeight * 2.5,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                            width: Get.size.width,
                            padding: EdgeInsets.only(bottom: 15),
                            child: MaterialSegmentedControl(
                              horizontalPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              children: {
                                0: _tabCard(0, 0),
                                1: _tabCard(1, 1),
                                2: _tabCard(2, 2),
                                3: _tabCard(3, 3),
                              },
                              selectionIndex:
                                  controller.travelTimeContentIndex.value,
                              borderColor: Colors.grey.shade800,
                              selectedColor: hotPropertiesThemeColor,
                              unselectedColor: Colors.white,
                              borderRadius: 5.0,
                              onSegmentChosen: (ind) async {
                                controller
                                    .changeTravelTimeContentIndex(ind! as int);

                                controller.currrentTravelTimeSearchType.value =
                                    controller
                                        .gettravelTimeSearchType(ind! as int);

                                controller.changeSliderValue();
                                // if (controller
                                //         .currrentTravelTimeSearchType.value ==

                                //     TravelTimeSearchType.searchByRadius)
                                //   controller.radius.value = 250.0;
                                // else
                                //   controller.radius.value = 5.0;

                                // controller.radius.value =
                                //     controller.;
                                // controller.fetchDetails(controller.lstofpopularrealestatemodel
                                //     .value[this.index].propertyId);
                                print("index changed");
                              },
                            ),
                          ),
                          Obx(() => Container(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Slider(
                                        activeColor: hotPropertiesThemeColor,
                                        value: controller.slidervalue.value,
                                        max: (controller
                                                    .currrentTravelTimeSearchType
                                                    .value !=
                                                TravelTimeSearchType
                                                    .searchByRadius)
                                            ? 45
                                            : 100,
                                        min: 0,
                                        onChanged: (v) async {
                                          // print(
                                          //     "radius=${controller.radius.value}");
                                          // print(
                                          //     "slider value=${controller.slidervalue.value}");

                                          // controller.startsliderfunction(v);

                                          controller.slidervalue.value = v;
                                          controller.radius.value = v;
                                          if (controller.circle.value.visible &&
                                              controller
                                                      .currrentTravelTimeSearchType
                                                      .value ==
                                                  TravelTimeSearchType
                                                      .searchByRadius) {
                                            if (v <
                                                controller.slidervalue.value) {
                                              await controller.controller
                                                  .animateCamera(
                                                      CameraUpdate.zoomOut());
                                            } else {
                                              // await controller.controller
                                              //     .animateCamera(
                                              //         CameraUpdate.zoomIn());
                                            }
                                            controller.slidervalue.value = v;

                                            controller.radius.value =
                                                250.0 + v * 100.0;

                                            controller.setCircle(
                                                controller.circle.value.center
                                                    .latitude,
                                                controller.circle.value.center
                                                    .longitude);
                                          } else {
                                            controller.slidervalue.value = v;
                                            controller.radialdistance.value =
                                                (5 +
                                                        controller.slidervalue
                                                            .value) *
                                                    265.0;
                                            controller.radius.value =
                                                controller.radialdistance.value;
                                            print(v);
                                            // controller.radius.value =
                                            //     250.0 + v * 100.0;
                                            controller.setCircle(
                                                controller.circle.value.center
                                                    .latitude,
                                                controller.circle.value.center
                                                    .longitude);
                                          }
                                        }),
                                  ),
                                  Obx(() => Text(
                                      '${(controller.currrentTravelTimeSearchType == TravelTimeSearchType.searchByRadius) ? controller.radius.value.toInt() : 5 + controller.slidervalue.value.toInt()}${controller.currrentTravelTimeSearchType.value != TravelTimeSearchType.searchByRadius ? 'min' : 'm'}'))
                                ],
                              ))),
                        ],
                      )))
            ],
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
              child: (!controller.circle.value.visible)
                  ? Center(
                      child: Text(
                      AppLocalizations.of('Choose a point on map '),
                      style: TextStyle(color: Colors.grey, fontSize: 17),
                    ))
                  : Expanded(
                      child: _customButton(
                          AppLocalizations.of('Search').toUpperCase(),
                          Colors.red, () {
                        print(
                            "selected lat long tts=${controller.circle.value.center.latitude},${controller.circle.value.center.longitude} radius=${controller.radius}");
                        controller.selectedLatLong.clear();
                        controller.selectedLatLong
                            .add(controller.circle.value.center);

                        print(
                            "selected lat long tts 11 = ${controller.selectedLatLong}");
                        controller.fetchPropertyDetails();
                        Navigator.of(Get.context!).push(MaterialPageRoute(
                            builder: (context) =>
                                SearchByMapLocationList(from: "metro")));
                      }),
                    )

              //  _bottomAppBar(controller.drawStatus.value)

              ),
        ),
      ),
    );
  }
}
