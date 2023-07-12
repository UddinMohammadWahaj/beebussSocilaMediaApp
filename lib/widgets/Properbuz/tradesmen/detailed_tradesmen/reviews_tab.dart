import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../../../Language/appLocalization.dart';
import '../../../../api/api.dart';
import '../../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../../services/Properbuz/write_review_controller.dart';
import '../../../../services/current_user.dart';
import '../../../../view/Properbuz/add_items/add_album_image_view.dart';

class ReviewsTab extends GetView<TradesmenResultsController> {
  final String tradasemenIdData;
  final String companyId;
  bool reviewCheck;
  ReviewsTab(this.tradasemenIdData, this.companyId, this.reviewCheck,
      {Key? key})
      : super(key: key);

  // void initState() {

  //   // super.initState();
  // }
//   var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
// var outputDate = outputFormat.format(inputDate);

  TextEditingController describeController = TextEditingController();
  // AddTradesmenController ctr = Get.put(AddTradesmenController());
  WriteReviewController ctrl = Get.put(WriteReviewController());

  var listLength;
  var reliabilityRating = 0.0;
  var tidinessRating = 0.0;
  var CourtesyRating = 0.0;
  var workmanshipRating = 0.0;

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
          AppLocalizations.of(value),
          style: TextStyle(fontSize: 15, color: settingsColor),
        ));
  }

  Widget _numberCard(String count) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          count,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
        ));
  }

  Widget _ratingsListTile1(String title, IconData icon, indexValue) {
    return ListTile(
      dense: true,
      // contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: Icon(
        icon,
        size: 28,
        color: settingsColor,
      ),
      title: Text(
        AppLocalizations.of(title),
        style: TextStyle(
            fontSize: 15, color: settingsColor, fontWeight: FontWeight.normal),
      ),
      // subtitle: Padding(
      //   padding: EdgeInsets.symmetric(vertical: (5)),
      //   child: _ratingsBuilder(),
      // ),
      trailing: _ratingsBuilder(indexValue),
    );
  }

  Widget _ratingsListTile(String title, IconData icon, value) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: Icon(
        icon,
        size: 22,
        color: settingsColor,
      ),
      title: Text(
        AppLocalizations.of(title),
        style: TextStyle(
            fontSize: 16, color: settingsColor, fontWeight: FontWeight.normal),
      ),
      trailing: Text(
        "${value != null ? value : ""}/5",
        style: TextStyle(
            fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _ratingsColumn1() {
    return Container(
        padding: EdgeInsets.only(top: 5),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: settingsColor,
            width: 0.6,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ratingsListTile1(
                AppLocalizations.of("Reliability") +
                    " & " +
                    AppLocalizations.of("timekeeping"),
                Icons.access_time_outlined,
                1),
            _ratingsListTile1(
                AppLocalizations.of("Tidiness"), Icons.cleaning_services, 2),
            _ratingsListTile1(AppLocalizations.of("Courtesy"),
                Icons.emoji_emotions_outlined, 3),
            _ratingsListTile1(
                AppLocalizations.of("Workmanship"), Icons.handyman, 4),
          ],
        ));
  }

  Widget _ratingsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleCard(AppLocalizations.of("Ratings")),
            _numberCard("2" + AppLocalizations.of("ratings"))
          ],
        ),
        _ratingsListTile(
            AppLocalizations.of("Reliability") +
                " & " +
                AppLocalizations.of("timekeeping"),
            Icons.access_time_outlined,
            controller.lstReviewDataModelData!.reviewCount!.timeRate ?? ""),
        _ratingsListTile(
            AppLocalizations.of("Tidiness"),
            Icons.cleaning_services,
            controller.lstReviewDataModelData!.reviewCount!.serviceRate ?? ""),
        _ratingsListTile(
            AppLocalizations.of("Courtesy"),
            Icons.emoji_emotions_outlined,
            controller.lstReviewDataModelData!.reviewCount!.satisfactionRate ??
                ""),
        _ratingsListTile(AppLocalizations.of("Workmanship"), Icons.handyman,
            controller.lstReviewDataModelData!.reviewCount!.workRate ?? ""),
      ],
    );
  }

  Widget _nameCard(index, BuildContext context, StateSetter setSate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(

          controller.tradesmenReviewList[index].member!.name!,

          // AppLocalizations.of(controller.lstReviewDataModelData.reviewList[index].memberName),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _nameCardSolo(index, BuildContext context, StateSetter setSate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          controller.tradesmenReviewListSolo[index].member!.name!,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _reviewDescriptionCardSolo(index) {
    bool see = false;
    return Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: ReadMoreText(
          AppLocalizations.of(
              controller.tradesmenReviewListSolo[index].description!),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade700),
          trimLines: 3,
          textAlign: TextAlign.justify,
          colorClickableText: settingsColor,
          delimiter: "",
          // trimMode: TrimMode.Line,
          trimCollapsedText: '...' +
              AppLocalizations.of('Show') +
              ' ' +
              AppLocalizations.of('more'),
          trimExpandedText: '  ' +
              AppLocalizations.of('Show') +
              ' ' +
              AppLocalizations.of('less'),
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700),
          // lessStyle: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.grey.shade700),
        ));
  }

  Widget _reviewDescriptionCard(index) {
    bool see = false;
    return Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: ReadMoreText(
          AppLocalizations.of(
              controller.tradesmenReviewList[index].description!),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade700),
          trimLines: 3,
          textAlign: TextAlign.justify,
          colorClickableText: settingsColor,
          delimiter: "",
          // trimMode: TrimMode.Line,
          trimCollapsedText: '...' +
              AppLocalizations.of('Show') +
              ' ' +
              AppLocalizations.of('more'),
          trimExpandedText: '  ' +
              AppLocalizations.of('Show') +
              ' ' +
              AppLocalizations.of('less'),
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700),
          // lessStyle: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.grey.shade700),
        ));
  }

  Widget _ratingsIconCard(IconData icon, rate) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: settingsColor,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            rate,
            style: TextStyle(color: settingsColor),
          )
        ],
      ),
    );
  }

  Widget _ratingsIconRowSolo(index) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          _ratingsIconCard(Icons.access_time_outlined,
              "${controller.tradesmenReviewListSolo[index].reliability}/5"),
          _ratingsIconCard(Icons.cleaning_services,
              "${controller.tradesmenReviewListSolo[index].tidiness}/5"),
          _ratingsIconCard(Icons.emoji_emotions_outlined,
              "${controller.tradesmenReviewListSolo[index].courtesy}/5"),
          _ratingsIconCard(Icons.handyman,
              "${controller.tradesmenReviewListSolo[index].workmanship}/5"),
        ],
      ),
    );
  }

  Widget _ratingsIconRow(index) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          _ratingsIconCard(Icons.access_time_outlined,
              "${controller.tradesmenReviewList[index].reliability}/5"),
          _ratingsIconCard(Icons.cleaning_services,
              "${controller.tradesmenReviewList[index].tidiness}/5"),
          _ratingsIconCard(Icons.emoji_emotions_outlined,
              "${controller.tradesmenReviewList[index].courtesy}/5"),
          _ratingsIconCard(Icons.handyman,
              "${controller.tradesmenReviewList[index].workmanship}/5"),
        ],
      ),
    );
  }

  Widget _customerCard(index) {
    DateTime dt = controller.tradesmenReviewList[index].createdAt!;
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(top: 10),
        child: Text(
          DateFormat('dd-MMM,yy hh:mm a').format(dt),
          style: TextStyle(color: Colors.grey.shade600),
        ));
  }

  Widget _customerCardSolo(index) {
    DateTime dt = controller.tradesmenReviewListSolo[index].createdAt!;
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(top: 10),
        child: Text(
          DateFormat('dd-MMM,yy hh:mm a').format(dt),
          style: TextStyle(color: Colors.grey.shade600),
        ));
  }

  Widget _separator() {
    return Divider(
      thickness: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _reviewsListBuilder(BuildContext context, StateSetter setSate) {
    return StatefulBuilder(
      builder: (context, setState) => MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.separated(
            separatorBuilder: (context, index) => _separator(),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.tradesmenReviewList.length,
            itemBuilder: (context, index) {
              // return ReviewCard(controller.lstReviewData, index);
              return Container(
                  // color: Colors.yellow,
                  padding:
                      EdgeInsets.only(left: 10, bottom: 15, right: 10, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _nameCard(index, context, setSate),
                      _reviewDescriptionCard(index),
                      _ratingsIconRow(index),
                      _customerCard(index),
                    ],
                  ));
            }),
      ),
    );
  }

  Widget _reviewsListBuilderSolo(BuildContext context, StateSetter setSate) {
    return StatefulBuilder(
      builder: (context, setState) => MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.separated(
            separatorBuilder: (context, index) => _separator(),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.tradesmenReviewListSolo.length,
            itemBuilder: (context, index) {
              // return ReviewCard(controller.lstReviewData, index);
              return Container(
                  // color: Colors.yellow,
                  padding:
                      EdgeInsets.only(left: 10, bottom: 15, right: 10, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _nameCardSolo(index, context, setSate),
                      _reviewDescriptionCardSolo(index),
                      _ratingsIconRowSolo(index),
                      _customerCardSolo(index),
                    ],
                  ));
            }),
      ),
    );
  }

  Widget _appointmentColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleCard(AppLocalizations.of("Appointment history")),
        _customTextCard(
            AppLocalizations.of("Appointments reported as missed (1 Year) 0"))
      ],
    );
  }

  Widget _reviewsColumn(BuildContext context, StateSetter setSate) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleCard(AppLocalizations.of("Reviews")),
            _numberCard("${controller.tradesmenReviewList.length} " +
                AppLocalizations.of("Reviews"))
          ],
        ),
        _reviewsListBuilder(context, setSate)
      ],
    );
  }

  Widget _reviewsColumnSolo(BuildContext context, StateSetter setSate) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleCard(AppLocalizations.of("Reviews")),
            _numberCard("${controller.tradesmenReviewListSolo.length} " +
                AppLocalizations.of("Reviews"))
          ],
        ),
        _reviewsListBuilderSolo(context, setSate)
      ],
    );
  }

  Widget _ratingItemStar() {
    return Icon(
      Icons.star,
      color: settingsColor,
      size: 10,
    );
  }

  Widget _ratingsBuilder(indexValue) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: RatingBar.builder(
        itemSize: 16,
        initialRating: 0,
        minRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        // itemPadding: EdgeInsets.only(right: 0),
        itemBuilder: (context, index) => _ratingItemStar(),
        onRatingUpdate: (rating) {
          // print("11-- ratings == " + rating.toString() + "-- ");
          if (indexValue == 1) {
            reliabilityRating = rating;
            // print("11-- reliabilityRating-- $reliabilityRating");
          } else if (indexValue == 2) {
            tidinessRating = rating;
            // print("11-- tidinessRating-- $tidinessRating");
          } else if (indexValue == 3) {
            CourtesyRating = rating;
            // print("11-- CourtesyRating-- $CourtesyRating");
          } else if (indexValue == 4) {
            workmanshipRating = rating;
            // print("11-- workmanshipRating-- $workmanshipRating");
          }
        },
        glowRadius: 0,
      ),
    );
  }

  Future showSuccess(context, msg) async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        // "Feedback added Successfully..",
        AppLocalizations.of(msg),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      icon: Icon(
        Icons.done_all_rounded,
        color: Colors.green,
      ),
      duration: Duration(seconds: 3),
    ));

    reliabilityRating = 0.0;
    tidinessRating = 0.0;
    CourtesyRating = 0.0;
    workmanshipRating = 0.0;
    describeController.clear();
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
    if (reliabilityRating == 0.0) {
      errorView("Give Rating to Raliability & timekeeping");
      return false;
    } else if (tidinessRating == 0.0) {
      errorView("Give Rating to TidinessRating");
      return false;
    } else if (CourtesyRating == 0.0) {
      errorView("Give Rating to CourtesyRating");
      return false;
    } else if (workmanshipRating == 0.0) {
      errorView("Give Rating to WorkmanshipRating");
      return false;
    } else if (describeController.text.length < 1) {
      errorView("Please Describe your Review");
      return false;
    }

    return true;
  }

  void dialog1(BuildContext context, setSate) {
    showDialog(
        // barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return setupAlertDialoadContainer(context, setSate);
            }),
          );
        });
  }

  Widget setupAlertDialoadContainer(context, setSate) {
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        height: 40,
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of('Feedback'),
            style: TextStyle(
                color: settingsColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          // color: settingsColor,
        ),
      ),
      _ratingsColumn1(),
      Align(
        alignment: Alignment.centerLeft,
        child: _titleCard(AppLocalizations.of("Review") +
            " " +
            AppLocalizations.of("Description")),
      ),
      _customTextFieldservice(
          describeController,
          AppLocalizations.of("Describe") +
              " " +
              AppLocalizations.of("your") +
              " " +
              AppLocalizations.of("Review"),
          125),
      SizedBox(
        height: 7,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                // color: settingsColor,
                onPressed: () {
                  Navigator.pop(context);
                  reliabilityRating = 0.0;
                  tidinessRating = 0.0;
                  CourtesyRating = 0.0;
                  workmanshipRating = 0.0;
                  describeController.clear();
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
              style: ElevatedButton.styleFrom(
                primary: settingsColor,
                // fixedSize: Size.fromWidth(100),
                padding: EdgeInsets.all(10),
              ),
              // color: settingsColor,
              onPressed: () async {
                setSate(() async {
                  if (validation()) {
                    print("object... mssg..");
                    var printdata = {
                      'companyId': companyId,
                      "courtesy": CourtesyRating,
                      "description": describeController.text,
                      "relaibility": reliabilityRating,
                      "tidiness": tidinessRating,
                      "tradesmenId": tradasemenIdData,
                      "workmanship": workmanshipRating,
                      'user_id': CurrentUser().currentUser.memberID
                    };
                    print('review=${printdata}');
                    String mssg = await ctrl.AddFeedback(
                        companyId: companyId.toString(),
                        courtesy: CourtesyRating.toString(),
                        description: describeController.text.toString(),
                        relaibility: reliabilityRating.toString(),
                        tidiness: tidinessRating.toString(),
                        tradesmenId: tradasemenIdData.toString(),
                        workmanship: workmanshipRating.toString());
                    print("object.. msg = $mssg");
                    if (mssg == "false") {
                      Navigator.pop(context);
                      return errorView(AppLocalizations.of(
                          "There is Some Issue please try again!"));
                    } else {
                      setSate(
                        () async {
                          Navigator.pop(context, true);
                          bool reviewCheck1 = await ApiProvider().feedbackCheck(
                              int.parse(tradasemenIdData),
                              int.parse(companyId));
                          reviewCheck = reviewCheck1;
                          await controller.fetchReviewDataList(
                            tradesmenId: tradasemenIdData,
                            companyId: companyId,
                          );
                          showSuccess(context, mssg);
                          return setSate(
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
    ]));
  }

  Widget _headerCardservice(String header) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          AppLocalizations.of(header),
          style: TextStyle(
              fontSize: 14, color: settingsColor, fontWeight: FontWeight.w500),
        ));
  }

  Widget _customTextFieldservice(
      TextEditingController controller, String hintText, double ht) {
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
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(hintText),
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ),
    );
  }

  void deleteDialog(BuildContext context, int index, StateSetter setsate) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return view(context, setsate, index);
            }),
          );
        });
  }

  Widget view(context, StateSetter setState, index) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of('Delete'),
          style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 20,
              fontWeight: FontWeight.bold),

          // color: settingsColor,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Align(
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of('Are you sure, You want to delete this Review ?'),
          style: TextStyle(
              color: settingsColor, fontSize: 16, fontWeight: FontWeight.bold),

          // color: settingsColor,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                // color: settingsColor,
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
                  if (controller.lstReviewDataModelData!.reviewList![index]
                          .memberId ==
                      CurrentUser().currentUser.memberID) {
                    String? mssg = await ctrl.deleteFeedback(
                      controller
                          .lstReviewDataModelData!.reviewList![index].memberId!,
                      controller
                          .lstReviewDataModelData!.reviewList![index].reviewId!,
                    );
                    print(
                        "object.. id = ${controller.lstReviewDataModelData!.reviewList![index].reviewId}");
                    if (mssg == "false") {
                      // Navigator.pop(context);
                      return errorView(AppLocalizations.of(
                          "There is Some Issue please try again!"));
                    } else {
                      setState(
                        () async {
                          Navigator.pop(context);

                          await controller.fetchReviewDataList(
                            tradesmenId: tradasemenIdData,
                          );
                          bool reviewCheck1 = await ApiProvider().feedbackCheck(
                              int.parse(tradasemenIdData),
                              int.parse(companyId));
                          setState(
                            () => reviewCheck = reviewCheck1,
                          );

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

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: MediaQuery.of(context).size.height,
        // color: Colors.pink,
        child: Stack(
          children: [
            Container(
              alignment: controller.tradesmenReviewList.length != 0
                  ? Alignment.center
                  : Alignment.topCenter,
              // color: Colors.blue,
              padding: reviewCheck == true
                  ? EdgeInsets.only(bottom: 50)
                  : EdgeInsets.only(bottom: 0),
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: this.companyId == "null" &&
                        controller.tradesmenReviewListSolo.length != 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // _ratingsColumn(),
                          _reviewsColumnSolo(context, setState)
                        ],
                      )
                    : controller.tradesmenReviewList.length != 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // _ratingsColumn(),
                              _reviewsColumn(context, setState)
                            ],
                          )
                        : Center(
                            child: Text(
                                AppLocalizations.of("No Review Added Yet..!"))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ProfileTab.customButton(AppLocalizations.of("Feedback"), () {
              dialog1(context, setState);
            })
            // reviewCheck == true
            //     ? ProfileTab.customButton(AppLocalizations.of("Feedback"), () {
            //         dialog1(context, setState);
            //       })
            //     : Container(),
          ],
        ),
      ),
    );
  }
}
