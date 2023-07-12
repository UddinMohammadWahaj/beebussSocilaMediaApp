import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlng;

class ManagePropertyMapFeatureItem extends GetView<UserPropertiesController> {
  final int val;
  final int index;
  const ManagePropertyMapFeatureItem({
    Key? key,
    required this.val,
    required this.index,
  }) : super(key: key);

  Widget mapEmpty() {
    return Container(
        child: Center(
      child: Text(
        'No map Available for this property',
        style: TextStyle(
            color: settingsColor, fontSize: 17, fontWeight: FontWeight.w500),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    print(
        "lat =${controller.value(val)[index].lat} propid=${controller.value(val)[index].propertyid}");
    return (controller.value(val)[index].lat!.isNotEmpty &&
            controller.value(val)[index].long!.isNotEmpty)
        ? FlutterMap(
            options: MapOptions(
              center: latlng.LatLng(
                  double.parse(controller.value(val)[index].lat!.isNotEmpty
                      ? controller.value(val)[index]!.lat!
                      : "19.1207404"),
                  double.parse(controller.value(val)[index].long!.isNotEmpty!
                      ? controller.value(val)[index].long!
                      : "72.8495658")),
              zoom: 18.0,
            ),
            children: [TileLayer()],
            // layers: [
            //   new TileLayerOptions(
            //       urlTemplate:
            //           "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            //       subdomains: ['a', 'b', 'c']),
            //   new MarkerLayerOptions(
            //     markers: [
            //       new Marker(
            //         width: 80.0,
            //         height: 80.0,
            //         point: latlng.LatLng(
            //             double.parse(
            //                 controller.value(val)[index].lat!.isNotEmpty!
            //                     ? controller.value(val)[index].lat!
            //                     : "19.1207404"),
            //             double.parse(
            //                 controller.value(val)[index].long!.isNotEmpty
            //                     ? controller.value(val)[index]!.long!
            //                     : "72.8495658")),
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
          )
        : mapEmpty();
  }
}
