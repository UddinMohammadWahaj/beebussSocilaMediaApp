import 'package:bizbultest/services/Properbuz/add_property_controller.dart';
import 'package:bizbultest/services/Properbuz/api/edit_property_controller.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:latlong2/latlong.dart' as latlng;

class AddMapFeatureView extends GetView<AddPropertyController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: appBarColor,
          elevation: 0,
          title: Text(
            'Choose Your Location',
            style: TextStyle(fontSize: 14.0.sp, color: Colors.white),
          ),
        ),
        body: AddMapFeatureItem());
  }
}

class AddMapFeatureItem extends GetView<AddPropertyController> {
  final int? val;
  final int? index;

  const AddMapFeatureItem({
    Key? key,
    this.val,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get.put(PropertiesController());

    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        center: latlng.LatLng(
            double.parse("19.1207404"), double.parse("72.8495658")),
        zoom: 18.0,
      ),
      // layers: [
      //   new TileLayerOptions(
      //       urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      //       subdomains: ['a', 'b', 'c']),
      //   new MarkerLayerOptions(
      //     markers: [
      //       new Marker(
      //         width: 80.0,
      //         height: 80.0,
      //         point: latlng.LatLng(
      //             double.parse("19.1207404"), double.parse("72.8495658")),
      //         builder: (ctx) => new Container(
      //           child: Icon(
      //             CupertinoIcons.location_solid,
      //             color: Colors.red,
      //             size: 30,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ],
    );
  }
}
