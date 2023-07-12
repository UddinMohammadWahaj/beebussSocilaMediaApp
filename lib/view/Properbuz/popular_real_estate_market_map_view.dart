import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

class PopularMapFeatureItem extends GetView<PopularRealEstateMarketController> {
  final int? val;
  final int? index;
  const PopularMapFeatureItem({
    Key? key,
    this.val,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        "lat =${controller.lstofpopularrealestatemodel[index!].lat} propid=${controller.lstofpopularrealestatemodel[index!].propertyId}");
    return FlutterMap(
      options: MapOptions(
        center: latlng.LatLng(
            double.parse(controller.lstofpopularrealestatemodel[index!].lat ??
                "19.1207404"),
            double.parse(controller.lstofpopularrealestatemodel[index!].long ??
                "72.8495658")),
        zoom: 18.0,
      ),
      children: [],
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
      //             double.parse(
      //                 controller.lstofpopularrealestatemodel[index!].lat ??
      //                     "19.1207404"),
      //             double.parse(
      //                 controller.lstofpopularrealestatemodel[index!].long ??
      //                     "72.8495658")),
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
