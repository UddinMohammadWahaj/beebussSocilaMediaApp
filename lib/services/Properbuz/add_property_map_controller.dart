import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import 'api/searchbymapapi.dart';

class AddPropertyMapController extends GetxController {
  //--------------------MAP SECTION-------------------------

  // RxSet<Marker> markset = <Marker>{}.obs;
  Completer<GoogleMapController> mapcontroller = Completer();
  GoogleMapController? controller;
  // Uint8List markerIcon;
  // LatLng currentLocation;
  // var currentlat = "".obs, currentlong = "".obs;
  // var maploc = "Choose Property Location".obs;
  // var selectedMarker = Marker(
  //   markerId: MarkerId(''),
  //   visible: false,
  // ).obs;
  // void ttsaddMarker(double lat, double long) {
  //   selectedMarker.value = Marker(
  //       icon: BitmapDescriptor.defaultMarker,
  //       markerId: MarkerId('${lat}${long}'),
  //       position: LatLng(lat, long));
  //   currentlat.value = lat.toString();
  //   currentlong.value = long.toString();
  // }

  // Future<CameraPosition> positonMapToNewLocation(
  //     double lat, double long) async {
  //   print("position new loc called $lat $long");
  //   currentlat.value = lat.toString();
  //   currentlong.value = long.toString();
  //   await SearchByMapApi.getLocationName(LatLng(lat, long));
  //   return CameraPosition(
  //       bearing: 192.8334901395799,
  //       target: LatLng(lat, long),
  //       tilt: 59.440717697143555,
  //       zoom: 19.151926040649414);
  // }

  // TextEditingController searchTextLoc = TextEditingController();
  // CameraPosition positonMapToCurrentLocation() {
  //   return CameraPosition(
  //       bearing: 192.8334901395799,
  //       target: currentLocation != null
  //           ? currentLocation
  //           : LatLng(37.43296265331129, -122.08832357078792),
  //       tilt: 59.440717697143555,
  //       zoom: 19.151926040649414);
  // }

//----Map SECTION END-----------------

  @override
  void onInit() async {
    controller = await mapcontroller.future;

    super.onInit();
  }
}
