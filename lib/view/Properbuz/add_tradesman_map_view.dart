import 'package:bizbultest/models/Properbuz/SearchTextLocationModel.dart';
import 'package:bizbultest/services/Properbuz/add_property_controller.dart';

import 'package:bizbultest/services/Properbuz/add_tradesman_controller.dart';
import 'package:bizbultest/services/Properbuz/api/searchbymapapi.dart';

import 'package:bizbultest/utilities/colors.dart';

import 'package:flutter/material.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'dart:ui' as ui;

class AddTradesmanMap extends GetView<AddTradesmenController> {
  // AddTradesmenController ctr = Get.put(AddTradesmenController());
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
                style: TextStyle(fontSize: 15, color: Colors.black),
              )),
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller.searchTextLoc,
              decoration: InputDecoration(
                fillColor: Colors.grey[350],
                contentPadding: EdgeInsets.all(10),
                prefixIcon: Icon(
                  Icons.location_city,
                  color: settingsColor,
                ),

                hintText: "Enter Address",

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
              // ctr.currentMapSearchType.value = this.maptype;
              print(
                  "selected suggestion=${suggestion.geometry!.location!.lat!},${suggestion.geometry!.location!.lng}");
              controller.controller.animateCamera(
                CameraUpdate.newCameraPosition(
                    await controller.positonMapToNewLocation(
                        suggestion.geometry!.location!.lat!,
                        suggestion.geometry!.location!.lng!)),
              );

              controller.ttsaddMarker(suggestion.geometry!.location!.lat!,
                  suggestion.geometry!.location!.lng!);
              print(
                  "selected lat=${suggestion.geometry!.location!.lat} selected long=${suggestion.geometry!.location!.lng}");
              controller.currentlat.value =
                  suggestion.geometry!.location!.lat.toString();
              controller.currentlong.value =
                  suggestion.geometry!.location!.lng.toString();
            },
            loadingBuilder: (ctx) => Center(child: CircularProgressIndicator()),
            itemBuilder: (context, Result suggestion) {
              print("sugesstion aya ${suggestion.name}");

              return ListTile(
                leading: Icon(Icons.location_city),
                title: Text(suggestion.isBlank!
                    ? 'No Location Found'
                    : suggestion.formattedAddress!),
                subtitle: Text(suggestion.isBlank! ? '' : '${suggestion.name}'),
              );
            },
            suggestionsCallback: (pattern) async {
              print(pattern);
              if (pattern == '') return <Result>[];
              return await SearchByMapApi.getLocDetails(pattern);
            },
          )
        ],
      ),
    );
  }

  Widget mapBody() {
    return GoogleMap(
        onMapCreated: (gmapController) async {
          print("am here");

          await loc.Location.instance.getLocation().then((value) {
            controller.currentLocation =
                LatLng(value.latitude!, value.longitude!);
            controller.currentlat.value =
                controller.currentLocation.latitude.toString();
            controller.currentlong.value =
                controller.currentLocation.longitude.toString();
            print("cam urrent location=${controller.currentLocation}");
          });
          try {
            controller.mapcontroller.complete(gmapController);
          } catch (e) {
            print("am here 2 $e");
          }
          print("am here 2");
          await gmapController.animateCamera(CameraUpdate.newCameraPosition(
              controller.positonMapToCurrentLocation()));
        },
        onTap: (argument) async {
          controller.addMarker(argument);
          var lat = argument.latitude, long = argument.longitude;
          print("tapped $lat $long");
          // if (ctr.drawStatus.value == 1)
          try {
            await controller.controller.animateCamera(
                CameraUpdate.newCameraPosition(CameraPosition(
                    target: LatLng(lat, long), zoom: 15.151926040649414)));
          } catch (e) {
            print("tapped exception $e");
          }
          controller.ttsaddMarker(lat, long);
        },
        markers: {controller.selectedMarker.value},
        myLocationEnabled: true,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
            target: (controller.currentLocation != null)
                ? controller.currentLocation
                : LatLng(20.5937, 78.9629)));
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(AddPropertyMapController());
    // ctr.mapcontroller = Completer();

    return Obx(() => Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: BackButton(
              color: Colors.black,
              onPressed: () {
                // Get.delete<AddPropertyMapController>();
                // controller.mapcontroller = null;
                controller.selectedMarker.value = Marker(
                  markerId: MarkerId(''),
                  visible: false,
                );

                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.transparent,
            toolbarHeight: kToolbarHeight * 1.2,
            title: _customTextField(TextEditingController(), '')),
        body: mapBody(),
        bottomNavigationBar: Container(
            width: Get.size.width,
            height: kToolbarHeight,
            child: controller.selectedMarker.value.visible
                ? _customButton('Confirm', Colors.red, () async {
                    Navigator.of(context).pop();
                    controller.mapcontroller == null;

                    controller.maploc1.value =
                        await SearchByMapApi.getLocationName(LatLng(
                            double.parse(controller.currentlat.value),
                            double.parse(controller.currentlong.value)));
                    controller.propertyLat.text =
                        controller.currentlat.toString();
                    controller.propertyLong.text =
                        controller.currentlong.toString();
                    controller.selectedMarker.value = Marker(
                      markerId: MarkerId(''),
                      visible: false,
                    );
                    print("data == .. # ${controller.maploc1.value}");
                    controller.controller.dispose();
                  })
                : _customMessage(
                    'Type the address to select your desired location or Tap on the map',
                    color: settingsColor,
                    titleColor: Colors.white))));
  }
}
