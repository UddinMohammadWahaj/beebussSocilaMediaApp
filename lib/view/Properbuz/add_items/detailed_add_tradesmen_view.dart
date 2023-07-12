import 'dart:async';
import 'dart:io';

import 'package:bizbultest/models/Properbuz/SearchTextLocationModel.dart';
import 'package:bizbultest/services/Properbuz/add_tradesman_controller.dart';
import 'package:bizbultest/services/Properbuz/api/searchbymapapi.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/add_tradesman_map_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bizbultest/services/Properbuz/searchbymapcontroller.dart';
import 'package:sizer/sizer.dart';

import '../add_property_map_view.dart';
import '../searchbymaplocationlist.dart';

class DetailedAddTradesmenView extends StatefulWidget {
  final String? companyName;
  final File? logo;
  final File? C_image;
  final String? Email;
  final String? C_number;
  final String? WebSite;
  final String? countryId;
  final String? countryName;

  final String? categoryId;

  final String? location;
  final String? M_Name;
  final String? M_number;
  final String? C_details;

  const DetailedAddTradesmenView({
    Key? key,
    this.companyName,
    this.logo,
    this.C_image,
    this.Email,
    this.C_number,
    this.WebSite,
    this.countryId,
    this.countryName,
    this.categoryId,
    this.location,
    this.M_Name,
    this.M_number,
    this.C_details,
  }) : super(key: key);

  @override
  State<DetailedAddTradesmenView> createState() =>
      _DetailedAddTradesmenViewState();
}

class _DetailedAddTradesmenViewState extends State<DetailedAddTradesmenView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController street1 = TextEditingController();
  TextEditingController street2 = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController manager = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController additional = TextEditingController();
  TextEditingController describe = TextEditingController();
  TextEditingController yourEmail = TextEditingController();
  AddTradesmenController ctr = Get.put(AddTradesmenController());
  // SearchByMapController controller = Get.put(SearchByMapController());

  GoogleMapController? mapController;
  // TextEditingController searchTextLoc = TextEditingController();

  final LatLng _center = const LatLng(28.535517, 77.391029);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget _mapCard(bool isMarkerUpdated) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 200,
          width: 100.0.w - 20,
          child: GoogleMap(
            // liteModeEnabled: true,
            // mapToolbarEnabled: true,
            // buildingsEnabled: true,
            mapToolbarEnabled: true,
            scrollGesturesEnabled: true,
            compassEnabled: true,

            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            onMapCreated: (gmapController) async {
              await loc.Location.instance.getLocation().then((value) {
                ctr.currentLocation = LatLng(value.latitude!, value.longitude!);
                print("current location=${ctr.currentLocation}");
              });
              ctr.mapcontroller.complete(gmapController);
              await gmapController.animateCamera(CameraUpdate.newCameraPosition(
                  ctr.positonMapToCurrentLocation()));
            },
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
            //onMapCreated: _onMapCreated,
            markers: ctr.customMarker.toSet(),
            initialCameraPosition: CameraPosition(
              target: (ctr.currentLocation != null)
                  ? ctr.currentLocation
                  : LatLng(20.5937, 78.9629),
            ),
            // initialCameraPosition: CameraPosition(
            //target: _center,
            //   zoom: 1.0,
            // ),
            onTap: (LatLng) {
              ctr.addMarker(LatLng);
            },
          ),
        ),
        // Container(
        //   height: 50,
        //   width: 100.0.w - 20,
        //   padding: EdgeInsets.symmetric(
        //     horizontal: 10,
        //   ),
        //   margin: EdgeInsets.symmetric(
        //     horizontal: 10,
        //   ),
        //   decoration: new BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(5)),
        //     shape: BoxShape.rectangle,
        //     border: new Border.all(
        //       color: settingsColor,
        //       width: 0.6,
        //     ),
        //   ),
        //   // child: TextFormField(
        //   //   // readOnly: true,
        //   //   maxLines: null,
        //   //   cursorColor: Colors.grey.shade500,
        //   //   keyboardType: TextInputType.text,
        //   //   textCapitalization: TextCapitalization.sentences,
        //   //   style: TextStyle(color: Colors.black, fontSize: 16),
        //   //   decoration: InputDecoration(
        //   //     suffix: RaisedButton(
        //   //       child: Text("Select Map"),
        //   //       onPressed: () {},
        //   //     ),
        //   //     border: InputBorder.none,
        //   //     suffixIconConstraints: BoxConstraints(),
        //   //     focusedBorder: InputBorder.none,
        //   //     enabledBorder: InputBorder.none,
        //   //     errorBorder: InputBorder.none,
        //   //     disabledBorder: InputBorder.none,
        //   //     hintText: "searched here loctions",
        //   //     hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        //   //   ),
        //   // ),
        // ),
      ],
    );
  }

  bool validation() {
    if (nameController.text.length < 1 == "") {
      Fluttertoast.showToast(msg: "Enter name");
      return false;
    } else if (street1.text.length < 1) {
      Fluttertoast.showToast(msg: "enter street");
      return false;
    }
    // else if (street2.text.length < 1) {
    //   Fluttertoast.showToast(msg: "enter street 2");
    //   return false;
    // }
    else if (zip.text.length < 1) {
      Fluttertoast.showToast(msg: "enter zip");
      return false;
    } else if (manager.text.length < 1) {
      Fluttertoast.showToast(msg: "enter manager name");
      return false;
    } else if (contact.text.length < 1) {
      Fluttertoast.showToast(msg: "enter contact number");
      return false;
    } else if (email.text.length < 1) {
      Fluttertoast.showToast(msg: "enter email");
      return false;
    }
    //  else if (additional.text.length < 1) {
    //   Fluttertoast.showToast(msg: "enter additional contact");
    //   return false;
    //   }
    // else if (describe.text.length < 1) {
    //   Fluttertoast.showToast(msg: "enter description");
    //   return false;
    // }
    else if (yourEmail.text.length < 1) {
      Fluttertoast.showToast(msg: "enter your email");
      return false;
    } else if (ctr.customMarker.length < 1) {
      Fluttertoast.showToast(msg: "Please select location on map");
      return false;
    }
    return true;
  }

  Widget _headerCard(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header,
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
  }

  // Widget _customSelectButton(String val, VoidCallback onTap) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       decoration: new BoxDecoration(
  //         color: HexColor("#f5f7f6"),
  //         borderRadius: BorderRadius.all(Radius.circular(5)),
  //         shape: BoxShape.rectangle,
  //       ),
  //       padding: EdgeInsets.symmetric(
  //         horizontal: 10,
  //       ),
  //       margin: EdgeInsets.symmetric(
  //         horizontal: 10,
  //       ),
  //       height: 50,
  //       width: 100.0.w - 20,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             val,
  //             style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
  //           ),
  //           Icon(
  //             Icons.arrow_drop_down,
  //             color: Colors.grey.shade600,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _customTextField(
    TextEditingController controller,
    String hintText,
    double ht,
  ) {
    return Container(
      height: ht,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: settingsColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  Widget _customTextField2(String hintText, double ht) {
    return Container(
      height: ht,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: settingsColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        readOnly: true,
        maxLines: null,
        cursorColor: Colors.grey.shade500,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          // suffix: RaisedButton(
          //   child: Text("Select Map"),
          //   onPressed: () {},
          // ),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  Widget _customYesNoCard(String value, bool selected, function, bool pass) {
    return Container(
      width: 50.0.w - 30,
      child: Row(
        children: [
          IconButton(
            onPressed: () => function(pass),
            icon: Icon(
              selected ? CupertinoIcons.circle_fill : CupertinoIcons.circle,
              color: settingsColor,
            ),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _customCheckBox(String text, bool val, bool typeOfWork) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: Colors.transparent,
      width: 100.0.w - 40,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (typeOfWork) {
                ctr.updateServiceCategories(text, !val);
              } else {
                ctr.updateTypeOfWork(text, !val);
              }
            },
            icon: Icon(
              val ? CupertinoIcons.checkmark_square : CupertinoIcons.square,
              color: settingsColor,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customCheckBox1(String text, bool val) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: Colors.transparent,
      width: 100.0.w - 40,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              ctr.updateServiceCategories(text, !val);
            },
            icon: Icon(
              val ? CupertinoIcons.checkmark_square : CupertinoIcons.square,
              color: settingsColor,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customListBuilder(Map<String, dynamic> map, bool typeOfWork) {
    List keys = map.keys.toList();
    List values = map.values.toList();
    return Container(
        width: 100.0.w - 20,
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: keys.length,
            itemBuilder: (context, index) {
              return _customCheckBox(keys[index], map[keys[index]], typeOfWork);
            }));
  }

  Widget _customListBuilder1(Map<String, dynamic> map) {
    List keys = map.keys.toList();
    List values = map.values.toList();
    return Container(
        width: 100.0.w - 20,
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: keys.length,
            itemBuilder: (context, index) {
              return _customCheckBox1(keys[index], map[keys[index]]);
            }));
  }

  Widget _customYesNoRow(String header, bool selected, function) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerCard(header),
        Container(
          height: 50,
          decoration: new BoxDecoration(
            color: HexColor("#f5f7f6"),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              _customYesNoCard("Yes", selected, function, true),
              _customYesNoCard("No", !selected, function, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: () {
        if (validation()) {
          ctr.saveTradesmenData(
              widget.countryId!,
              widget.countryName!,
              widget.companyName!,
              widget.location!,
              street1.text,
              street2.text,
              zip.text,
              widget.categoryId!,
              nameController.text,
              manager.text,
              contact.text,
              email.text,
              additional.text,
              describe.text,
              yourEmail.text,
              widget.logo!);

          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      child: Container(
        height: 50,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            color: settingsColor),
        margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
        child: Center(
          child: Text(
            "Save",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _customSelectButtonmap(String val, VoidCallback onTap, RxBool isLoad) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: 50,
        width: 100.0.w - 20,
        child: Flexible(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 320,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      val,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
                (isLoad.value == false)
                    ? Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey.shade600,
                      )
                    : CircularProgressIndicator(
                        color: settingsColor,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: appBarColor,
        brightness: Brightness.dark,
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
        title: Text(
          "Add more details",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //   _headerCard("Country"),
              //   _customSelectButton("United Kingdom", () { }),
              //   _headerCard("Location"),
              //   _customTextField(textEditingController, "London", 50),
              _headerCard("House Name/Number"),
              _customTextField(nameController, "Enter House Name/Number", 50),
              _headerCard("Street Line 1"),
              _customTextField(street1, "Enter Street Line 1", 50),
              _headerCard("Street Line 2"),
              _customTextField(street2, "Enter Street Line 2 (optional)*", 50),
              _headerCard("Postal/Zip Code"),
              _customTextField(zip, "Enter Postal/Zip Code", 50),
              _headerCard("Map"),
              Obx(
                () => _customSelectButtonmap('${ctr.maploc1.value}', () async {
                  print("Tapped on map");
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddTradesmanMap(),
                  ));
                  if (ctr.mapcontroller == null) {
                    ctr.mapcontroller = Completer();
                    ctr.controller = await ctr.mapcontroller.future;
                  }
                }, false.obs),
              ),

              //       _headerCard("Map"),
              //       //_customTextField2("Map", 50),

              // TypeAheadFormField(
              //         textFieldConfiguration: TextFieldConfiguration(
              //           controller: ctr.searchTextLoc,
              //           decoration: InputDecoration(
              //             fillColor: Colors.grey[350],
              //             contentPadding: EdgeInsets.all(10),
              //             prefixIcon: Icon(
              //               Icons.location_city,
              //               color: settingsColor,
              //             ),

              //             hintText: "Enter Address",

              //             hintStyle: TextStyle(
              //               fontSize: 20,
              //             ),

              //             border: InputBorder.none,

              //             focusedBorder: InputBorder.none,
              //             enabledBorder: InputBorder.none,
              //             errorBorder: InputBorder.none,
              //             disabledBorder: InputBorder.none,
              //             // 48 -> icon width
              //           ),
              //         ),
              //         onSuggestionSelected: (Result suggestion) async {
              //           ctr.searchTextLoc.text =
              //               suggestion.formattedAddress.toString();
              //           //controller.currentMapSearchType.value = this.maptype;

              //           // if (0 == 1) {
              //           //   Navigator.of(Get.context).push(MaterialPageRoute(
              //           //     builder: (context) => SearchByMapLocationList(),
              //           //   ));

              //           //   controller.getSearchByName(suggestion.geometry.location.lat,
              //           //       suggestion.geometry.location.lng);
              //           //} else
              //           ctr.controller.animateCamera(CameraUpdate.newCameraPosition(
              //               ctr.positonMapToNewLocation(
              //                   suggestion.geometry.location.lat,
              //                   suggestion.geometry.location.lng)));
              //         },
              //         itemBuilder: (context, Result suggestion) {
              //           print("sugesstion aya ${suggestion.name}");

              //           return ListTile(
              //             leading: Icon(Icons.location_city),
              //             title: Text(suggestion.isBlank
              //                 ? 'No Location Found'
              //                 : suggestion.formattedAddress),
              //             subtitle:
              //                 Text(suggestion.isBlank ? '' : '${suggestion.name}'),
              //           );
              //         },
              //         suggestionsCallback: (pattern) async {
              //           print(pattern);
              //           return await SearchByMapApi.getLocDetails(pattern);
              //         },
              //       ),
              //      Obx(() => _mapCard(ctr.mapLocationAdded.value)),

              _headerCard("Manager's name"),
              _customTextField(manager, "Manager's/Owner's Name", 50),
              _headerCard("Contact number"),
              _customTextField(contact, "Primary contact", 50),
              _headerCard("Email"),
              _customTextField(email, "Company Email", 50),
              _headerCard("Additional Contact"),
              _customTextField(
                  additional, "Additional Contact Info (optional)*", 50),
              // _headerCard("Work Locations"),
              // _customSelectButton("Select Work Locations", () {}),
              _headerCard("Type of Work"),
              Obx(() => _customListBuilder(ctr.typeOfWorkList, false)),
              Obx(() => _customYesNoRow("24 Hour Call-Out", ctr.availabel.value,
                  ctr.updateAvailabel)),
              Obx(() => _customYesNoRow("Public Liability Insurance",
                  ctr.publiclibelity.value, ctr.publiclibelity)),
              Obx(() => _customYesNoRow("Insurance work undertaken",
                  ctr.workUndertaking.value, ctr.updateWorkUnderTaking)),
              // _headerCard("Service Categories"),
              // Obx(() => _customListBuilder1(ctr.serviceCategories.value)),
              // _headerCard("Service Description"),
              // _customTextField(describe, "Describe your Service", 125),
              _headerCard(
                  "Recommended: Let users send Enquiry with their Properbuz profile and notify me by email"),
              _customTextField(yourEmail, "Your Email Address", 50),
              _saveButton()
            ],
          ),
        ),
      ),
    );
  }
}
