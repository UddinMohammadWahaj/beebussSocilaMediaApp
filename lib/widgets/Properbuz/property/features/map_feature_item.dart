import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

class MapFeatureItem extends GetView<PropertiesController> {
  final int val;
  final int index;

  const MapFeatureItem({
    Key? key,
    required this.val,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());

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
