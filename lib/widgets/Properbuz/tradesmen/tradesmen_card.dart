import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/menu/detailed_tradesmen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../Language/appLocalization.dart';
import '../../../models/Tradesmen/newfifndtradesmenlistmodel.dart';
import 'detailed_tradesmen/review_model.dart';

class TradesmenCard extends GetView<TradesmenResultsController> {
  final int index;
  // final searchTradesmenData objTradesmanSearchModel;
  FindTradesmenRecord objTradesmanSearchModel;

  TradesmenCard({
    Key? key,
    required this.index,
    required this.objTradesmanSearchModel,
  }) : super(key: key);
  var dummyImage =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png';
  Widget _imageCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Image.network(
        objTradesmanSearchModel.profile == null
            ? dummyImage
            : controller.tradesmanpicurl + objTradesmanSearchModel.profile,
        fit: BoxFit.cover,
        width: 100.0.w - 20,
        height: 200,
      ),
    );
  }

  Widget _imageview() {
    return Container(
      height: 270,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Image.network(
              controller.tradesmanpicurl +
                  objTradesmanSearchModel.companyCoverPhoto!,
              fit: BoxFit.cover,
              width: 100.0.w - 20,
              height: 200,
            ),
          ),
          Positioned(
            width: 100.0.w,
            bottom: 0,
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.white,
                ),
              ),
              width: 150,
              height: 150,
              child: CircleAvatar(
                maxRadius: 50,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(
                    controller.tradesmanpicurl +
                        objTradesmanSearchModel.companyLogo!,
                    fit: BoxFit.cover,
                    height: 140,
                    width: 140,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _nameCard() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 0),
      child: Text(
        AppLocalizations.of(objTradesmanSearchModel.companyId == null
            ? objTradesmanSearchModel.fullName!
            : objTradesmanSearchModel.companyName!),
        style: TextStyle(
            fontSize: 22, color: settingsColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _iconTextCard(String value, IconData icon) {
    return Container(
      padding: EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: settingsColor,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            AppLocalizations.of(value),
            style: TextStyle(fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TradesmenResultsController());
    return objTradesmanSearchModel == []
        ? Text("objTradesmanSearchModel")
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedTradesmenView(
                    objTradesmanSearchModel: objTradesmanSearchModel,
                    index: index,
                    controller: controller,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: EdgeInsets.only(top: 10),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                shape: BoxShape.rectangle,
                border: new Border.all(
                  color: settingsColor,
                  width: 0.6,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objTradesmanSearchModel.companyId == null
                      ? _imageCard()
                      : _imageview(),
                  Container(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, bottom: 15, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _nameCard(),
                        _iconTextCard(
                            AppLocalizations.of(
                                objTradesmanSearchModel.companyId == null
                                    ? objTradesmanSearchModel.location!
                                    : objTradesmanSearchModel.companyLocation!),
                            Icons.location_on_rounded),
                        objTradesmanSearchModel.companyId == null
                            ? _iconTextCard(
                                AppLocalizations.of("Experience") +
                                    " : ${objTradesmanSearchModel.experience}",
                                Icons.account_box)
                            : Container(),
                        _iconTextCard(
                            AppLocalizations.of("Work Area") +
                                " : ${objTradesmanSearchModel.location}",
                            Icons.feedback),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 0),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: 100.0.w - 20,
                      height: 45,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        shape: BoxShape.rectangle,
                        color: settingsColor,
                        border: new Border.all(
                          color: settingsColor,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            objTradesmanSearchModel.companyId == null
                                ? AppLocalizations.of("Solo")
                                : AppLocalizations.of("Company"),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            AppLocalizations.of("See") +
                                " " +
                                AppLocalizations.of("More"),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );
  }
}
