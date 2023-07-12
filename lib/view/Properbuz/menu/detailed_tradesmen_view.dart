import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Tradesmen/newfifndtradesmenlistmodel.dart';
import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/gallery_tab.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/profile_tab.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/reviews_tab.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/services_tab.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:location/location.dart' as loc;

import '../../../Language/appLocalization.dart';
import '../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../services/Properbuz/searchbymapcontroller.dart';
import '../../../utilities/custom_icons.dart';
import '../../../widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';

class DetailedTradesmenView extends StatefulWidget {
  final int? index;
  final FindTradesmenRecord objTradesmanSearchModel;
  TradesmenResultsController controller;
  DetailedTradesmenView({
    Key? key,
    this.index,
    required this.controller,
    required this.objTradesmanSearchModel,
  }) : super(key: key);

  @override
  State<DetailedTradesmenView> createState() => _DetailedTradesmenViewState();
}

class _DetailedTradesmenViewState extends State<DetailedTradesmenView>
    with TickerProviderStateMixin {
  late TradesmenResultsController controller;
  // = Get.put(TradesmenResultsController());
  SearchByMapController ctr = Get.put(SearchByMapController());

  String country = "";
  late bool reviewData;

  late GoogleMapController _controller;

  Set<Marker> _createMarker(double lat, double long) {
    return <Marker>[
      Marker(
        markerId: MarkerId("Home"),
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: "Camp",
        ),
      ),
    ].toSet();
  }

  Widget map(BuildContext context) {
    var lat = double.parse(widget.objTradesmanSearchModel.latitude!.isEmpty
        ? "0.0"
        : widget.objTradesmanSearchModel.latitude!);
    var long = double.parse(widget.objTradesmanSearchModel.longitude!.isEmpty
        ? "0.0"
        : widget.objTradesmanSearchModel.longitude!);

    return Container(
      height: 300,
      width: 100.0.w,
      child: GoogleMap(
        mapType: MapType.normal,
        markers: _createMarker(lat, long),
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, long),
          zoom: 12.4,
        ),
        onMapCreated: (GoogleMapController controller) async {
          _controller = controller;
          await controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  bearing: 200.8334901395799,
                  target: LatLng(lat, long),
                  tilt: 60.440717697143555,
                  zoom: 13.151926040649414)));
        },
      ),
    );
  }

  Widget _tab(String tabTitle) {
    return Tab(
      text: tabTitle,
    );
  }

  @override
  void initState() {
    controller = widget.controller;
    controller.managePropertiesController = new TabController(
        vsync: this, length: 4, initialIndex: controller.currentIndex.value);
    controller.currentIndex.value = 0;
    controller.managePropertiesController!
        .animateTo(controller.currentIndex.value);
    // print("object.. reviewlist ${widget.objTradesmanSearchModel.tradesmanId}");
    fetchData();

    super.initState();
  }

  fetchData() async {
    AddTradesmenController ctr = Get.put(AddTradesmenController());

    String countyid = widget.objTradesmanSearchModel.countryId.toString();

    ctr.fetchCountryList(() async {
      for (int i = 0; i <= ctr.countrylist.length; i++) {
        if (ctr.countrylist[i].countryID == countyid) {
          country = ctr.countrylist[i].country!;
        }
      }
    });

//calling review
    if (widget.objTradesmanSearchModel.companyId != null) {
      controller.getFindTradesmenCompanyDetail(
          widget.objTradesmanSearchModel.companyId);
    } else {
      print("called here");
      controller.getFindTradesmenSoloDetail(widget.objTradesmanSearchModel.id);
    }

    // await controller.fetchReviewDataList(
    //     tradesmenId: widget.objTradesmanSearchModel.id.toString(),
    //     companyId: widget.objTradesmanSearchModel.companyId.toString());

//callin review end

    // bool reviewCheck = await ApiProvider().feedbackCheck(
    //     int.parse(widget.objTradesmanSearchModel.id.toString()),
    //     int.parse(widget.objTradesmanSearchModel.companyId.toString()));
    // setState(() {
    //   reviewData = reviewCheck;
    // });

    // await controller.fetchServiceDataList(
    //     tradesmenId: widget.objTradesmanSearchModel.id.toString(),
    //     companyId: widget.objTradesmanSearchModel.companyId.toString());
    // await ctr.fetchAlubmList(
    //     comId: int.parse(widget.objTradesmanSearchModel.toString()),
    //     trdId: int.parse(widget.objTradesmanSearchModel.toString()),
    //     setsate: setState);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TradesmenResultsController ctrl = Get.put(TradesmenResultsController());
    Get.put(TradesmenResultsController());
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  bottom: false,
                  sliver: SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Colors.black,
                      opacity: 200.0,
                    ),
                    floating: true,
                    pinned: true,
                    systemOverlayStyle:
                        SystemUiOverlayStyle(statusBarColor: statusBarColor),
                    elevation: 0,
                    backgroundColor: appBarColor,
                    expandedHeight: 350,
                    flexibleSpace: FlexibleSpaceBar(
                      background: map(context),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Container(
                        color: Colors.white,
                        child: TabBar(
                          indicatorColor: settingsColor,
                          labelColor: settingsColor,
                          labelStyle: TextStyle(
                              fontSize: 10.0.sp, fontWeight: FontWeight.w500),
                          unselectedLabelColor: Colors.grey.shade600,
                          controller: controller.managePropertiesController,
                          onTap: (index) => controller.switchTabs(index),
                          tabs: [
                            _tab(AppLocalizations.of("Profile")),
                            _tab(AppLocalizations.of("Reviews")),
                            _tab(AppLocalizations.of("Gallery")),
                            _tab(AppLocalizations.of("Services")),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ];
          },
          body: Obx(
            () => ctrl.findtradesmenlist.length > 0
                ? IndexedStack(
                    index: controller.currentIndex.value,
                    children: [
                      ProfileTab(country, widget.objTradesmanSearchModel),
                      ReviewsTab(
                          widget.objTradesmanSearchModel.id.toString(),
                          widget.objTradesmanSearchModel.companyId.toString(),
                          reviewData),
                      GalleryTab(
                          iscompany:
                              widget.objTradesmanSearchModel.companyId != null
                                  ? true
                                  : false),
                      ServicesTab(
                          iscompany:
                              widget.objTradesmanSearchModel.companyId != null
                                  ? true
                                  : false),
                    ],
                  )
                : noDataView(),
          ),
        ),
      ),
    );
  }

  Widget noDataView() {
    return Center(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CustomIcons.customer,
            size: 70,
            color: settingsColor,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "No Searched tradesman's History Yet..!",
            style: TextStyle(fontSize: 20, color: settingsColor),
          ),
        ],
      )),
    );
  }
}
