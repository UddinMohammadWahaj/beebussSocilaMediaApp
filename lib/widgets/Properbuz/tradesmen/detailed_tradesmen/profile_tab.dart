import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/services/Properbuz/write_review_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../Language/appLocalization.dart';
import '../../../../models/Tradesmen/newfifndtradesmenlistmodel.dart';

class ProfileTab extends GetView<TradesmenResultsController> {
  final String country;
  final FindTradesmenRecord objTradesmanSearchModel;
  ProfileTab(this.country, this.objTradesmanSearchModel);
  TextEditingController workLoctionController = TextEditingController();

  Widget _titleCard(String title) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          AppLocalizations.of(title),
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700),
        ));
  }

  Widget _customTextCard(String value) {
    return Container(
        padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: Text(
          "- " + AppLocalizations.of(value),
          style: TextStyle(fontSize: 15, color: settingsColor),
        ));
  }

  Widget _customTextInfoCard(String value, IconData icon, double bottom) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: settingsColor,
          ),
          SizedBox(
            width: 12,
          ),
          Container(
            padding: EdgeInsets.only(bottom: bottom),
            child: Text(
              AppLocalizations.of(value),
              style: TextStyle(
                  fontSize: 15,
                  color: settingsColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _companyColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleCard(AppLocalizations.of(
            objTradesmanSearchModel.companyId == null ? 'Solo' : 'Company')),
        // _imageview(),
      ],
    );
  }

  Widget _imageCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Image.network(
        objTradesmanSearchModel.profile,
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
                  // width: 4,
                ),
              ),
              width: 150,
              // width: 100.0.w - 90,
              height: 150,
              child: CircleAvatar(
                maxRadius: 50,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(
                    objTradesmanSearchModel.profile,
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

  Widget _userInfoColumn(country) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _titleCard(AppLocalizations.of("Information")),
        _customTextInfoCard(
            AppLocalizations.of(
                "${objTradesmanSearchModel.location}, $country"),
            Icons.home,
            15),
        _customTextInfoCard(
            AppLocalizations.of(objTradesmanSearchModel.fullName!),
            Icons.person,
            15),
        _customTextInfoCard(
            AppLocalizations.of(objTradesmanSearchModel.mobile!),
            Icons.call,
            15),
        _customTextInfoCard(AppLocalizations.of(objTradesmanSearchModel.email!),
            Icons.email, 15),
      ],
    );
  }

  Widget _descriptionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleCard(AppLocalizations.of("Description")),
        _customTextCard(
            AppLocalizations.of(objTradesmanSearchModel.description!)),
      ],
    );
  }

  Widget _basedInCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleCard(
            AppLocalizations.of("Based") + " " + AppLocalizations.of("in")),
        _customTextCard(objTradesmanSearchModel.location!),
      ],
    );
  }

  Widget _worksInCard(list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 10, top: 15),
            child: Text(
              AppLocalizations.of("Works") + " " + AppLocalizations.of("in"),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700),
            )),
        _workAreaList(list),
      ],
    );
  }

  static Widget customButton(String value, VoidCallback ontap) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: ontap,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              color: appBarColor,
              width: 100.0.w,
              height: 50,
              child: Center(
                  child: Text(
                AppLocalizations.of(value),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ))),
        ),
      ),
    );
  }

  Widget _customTextFieldNumber(
      String hintText, TextEditingController controller) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: new BoxDecoration(
        // color: Colors.grey.shade100,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: settingsColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        textAlign: TextAlign.justify,
        maxLines: 1,
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(hintText),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _customTextFieldNew(
      String hintText, TextEditingController controller) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 100.0.w - 20,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: new Border.all(
          color: settingsColor,
          width: 0.6,
        ),
      ),
      child: TextFormField(
        textAlign: TextAlign.justify,
        maxLines: 1,
        onTap: (() {}),
        cursorColor: Colors.grey.shade500,
        controller: controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(hintText),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }

  void errorView(msg) {
    Get.showSnackbar(GetBar(
      messageText: Text(AppLocalizations.of(msg),
          style: TextStyle(color: Colors.white, fontSize: 20)),
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.error,
        color: Colors.red,
      ),
    ));
  }

  bool validation() {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (nameController.text.length < 1) {
      errorView(
          AppLocalizations.of("Enter") + " " + AppLocalizations.of("Name"));
      return false;
    } else if (contactController.text.length < 1) {
      errorView(AppLocalizations.of("Enter") +
          " " +
          AppLocalizations.of("Contact") +
          " " +
          AppLocalizations.of("Number"));
      return false;
    } else if (!regExp.hasMatch(contactController.text)) {
      errorView(AppLocalizations.of("Enter") +
          " " +
          AppLocalizations.of("Valid") +
          " " +
          AppLocalizations.of("Contact") +
          " " +
          AppLocalizations.of("Number"));
    }
    return true;
  }

  Future showSuccess(context, msg) async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        AppLocalizations.of(msg),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      icon: Icon(
        Icons.done_all_rounded,
        color: Colors.green,
      ),
      duration: Duration(seconds: 3),
    ));

    nameController.clear();
    contactController.clear();
  }

  void dialog1(BuildContext context, StateSetter setstate) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setSta) {
              return setupAlertDialoadContainer(context, setstate);
            }),
          );
        });
  }

  Widget setupAlertDialoadContainer(context, StateSetter setState) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        height: 40,
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of('Request') +
                ' ' +
                AppLocalizations.of('Callback'),
            style: TextStyle(
                color: settingsColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      _customTextFieldNew(
          AppLocalizations.of("Enter") + " " + AppLocalizations.of("Name"),
          nameController),
      _customTextFieldNumber(
          AppLocalizations.of("Enter") +
              " " +
              AppLocalizations.of("Contact") +
              " " +
              AppLocalizations.of("Number"),
          contactController),
      SizedBox(
        height: 7,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                      color: settingsColor,
                    ),
                    Text(AppLocalizations.of("Back"),
                        style: TextStyle(color: settingsColor, fontSize: 15)),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(settingsColor)),
              // color: settingsColor,
              onPressed: () {
                setState(() async {
                  if (validation()) {
                    String mssg = await ctr.AddRequestCallback(
                        nameController.text,
                        contactController.text,
                        objTradesmanSearchModel.id.toString(),
                        objTradesmanSearchModel.companyId.toString());
                    print("object.. msg = $mssg");
                    if (mssg == "false") {
                      Navigator.pop(context);
                      return errorView(AppLocalizations.of(
                          "There is Some Issue please try again!"));
                    } else {
                      setState(
                        () {
                          Navigator.pop(context, true);

                          showSuccess(context, mssg);
                          return setState(
                            () {},
                          );
                        },
                      );
                    }
                  }
                });
              },
              child: Text(AppLocalizations.of("Done"),
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _workAreaList(list) {
    return StatefulBuilder(
      builder: (context, setState) => ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext ctx, index) {
            return _customTextCard(list[index]);
          }),
    );
  }

  TradesmenResultsController controller = Get.put(TradesmenResultsController());
  WriteReviewController ctr = Get.put(WriteReviewController());
  TextEditingController contactController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController workArea = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(TradesmenResultsController());

    workArea.text = objTradesmanSearchModel.location!;
    var ab = workArea.text.split(',');
    List webArea = ab;

    return StatefulBuilder(
      builder: (context, setState) => Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(bottom: 50),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  objTradesmanSearchModel.companyId != null
                      ? _companyColumn()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _titleCard(AppLocalizations.of('Solo')),
                            _imageCard(),
                          ],
                        ),
                  _userInfoColumn(country),
                  _descriptionCard(),
                  _basedInCard(),
                  _worksInCard(webArea),
                ],
              ),
            ),
          ),
          customButton(AppLocalizations.of("Request Callback"), () {
            dialog1(context, setState);
          })
        ],
      ),
    );
  }
}
