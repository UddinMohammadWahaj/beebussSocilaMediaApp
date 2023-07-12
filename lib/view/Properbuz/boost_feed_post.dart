import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/boost_post_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/boost/audiences_list_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class BoostFeedPost extends GetView<BootPostController> {
  final String? postID;

  const BoostFeedPost({Key? key, this.postID}) : super(key: key);

  Widget _userRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
                CachedNetworkImageProvider(CurrentUser().currentUser.image!),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CurrentUser().currentUser.fullName!,
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
              ),
              Text(
                AppLocalizations.of(CurrentUser().currentUser.category!) ?? "",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of("Promoted") + " • ",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.public,
                    color: hotPropertiesThemeColor,
                    size: 17,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 65,
      color: Colors.grey.shade200,
      width: 100.0.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_linkInfo(), _buttonCard()],
      ),
    );
  }

  Widget _buttonCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          shape: BoxShape.rectangle,
          color: hotPropertiesThemeColor),
      height: 45,
      constraints: BoxConstraints(maxWidth: 150),
      child: Center(
          child: Obx(
        () => Text(
          AppLocalizations.of(controller.selectedButton.value),
          style: TextStyle(color: Colors.white),
        ),
      )),
    );
  }

  Widget _buttonSelectionSheet() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: controller.buttonsList
            .map((e) => ListTile(
                  onTap: () => controller.selectButton(e.toString()),
                  title: Text(AppLocalizations.of(e).toString()),
                  trailing: controller.selectedButton.value == e.toString()
                      ? Icon(
                          Icons.check,
                          color: hotPropertiesThemeColor,
                          size: 25,
                        )
                      : null,
                ))
            .toList(),
      ),
    );
  }

  Widget _buttonSelectorCard() {
    print("cool");
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(_buttonSelectionSheet(), backgroundColor: Colors.white);
      },
      child: Container(
        height: 50,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            color: Colors.grey.shade200),
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                controller.selectedButton.value,
                style: TextStyle(
                    fontSize: 15,
                    color: hotPropertiesThemeColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_outlined,
              color: hotPropertiesThemeColor,
              size: 22,
            )
          ],
        ),
      ),
    );
  }

  Widget _linkInfo() {
    print("rebuild");
    return Container(
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.urlMetadata.value.domain!,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 100.0.w - 170),
              child: Text(
                controller.urlMetadata.value.title!,
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.grey.shade700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customHeader(String title) {
    return Container(
        width: 100.0.w,
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        color: hotPropertiesThemeColor,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ));
  }

  Widget _customSubHeader(String subTitle) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(
          subTitle,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ));
  }

  Widget _linkTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: 80),
          width: 100.0.w,
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            color: Colors.grey.shade200,
          ),
          child: TextFormField(
            focusNode: controller.focusNode,
            onChanged: (val) {
              controller.url.value = val;
            },
            maxLines: null,
            cursorColor: Colors.grey.shade500,
            controller: controller.linkController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(fontSize: 15, color: hotPropertiesThemeColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIconConstraints: BoxConstraints(),
              prefixIconConstraints: BoxConstraints(),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: AppLocalizations.of(
                "Enter URL here...",
              ),
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Choose the website address you'd like to send people to.",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ))
      ],
    );
  }

  Widget _durationInfoCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: new Border(
          top: BorderSide(color: Colors.grey, width: 1),
          bottom: BorderSide(color: Colors.grey, width: 1),
          left: BorderSide(color: Colors.yellow.shade700, width: 3),
          right: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CustomIcons.warning,
              color: Colors.yellow.shade700,
              size: 18,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(
                    "Increase the duration",
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Container(
                    width: 70.0.w,
                    child: Text(
                      AppLocalizations.of(
                        "Ads that run for at least 4 days tend to get better results.",
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _durationRow() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
          color: Colors.grey.shade200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_daysCard(), _dateCard()],
      ),
    );
  }

  Widget _customDurationHeader(String value) {
    return Text(
      value,
      style:
          TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
    );
  }

  Widget _daysTextField() {
    return Container(
      width: 75,
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        shape: BoxShape.rectangle,
        color: Colors.white,
        border: new Border.all(
          color: Colors.grey.shade700,
          width: 0.5,
        ),
      ),
      child: TextFormField(
        onChanged: (val) => controller.changeDate(val),
        maxLines: 1,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.grey.shade700,
        controller: controller.daysController,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(fontSize: 20, color: hotPropertiesThemeColor),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _dateItem() {
    return Container(
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          shape: BoxShape.rectangle,
          color: Colors.white,
          border: new Border.all(
            color: Colors.grey.shade700,
            width: 0.5,
          ),
        ),
        child: Center(
            child: Obx(() => Text(
                  DateFormat("dd-MM-yyyy")
                      .format(controller.dateTime.value)
                      .toString(),
                  style:
                      TextStyle(fontSize: 20, color: hotPropertiesThemeColor),
                ))));
  }

  Widget _daysCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _customDurationHeader(AppLocalizations.of("Days") + ": "),
          SizedBox(
            height: 10,
          ),
          _daysTextField()
        ],
      ),
    );
  }

  Widget _dateCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _customDurationHeader(AppLocalizations.of("End Date") + ": "),
          SizedBox(
            height: 10,
          ),
          _dateItem()
        ],
      ),
    );
  }

  Widget _budgetSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "\$ " + controller.boostData.value.budget.toString() + ".00",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
                fontSize: 25),
          ),
        ),
        Container(
          child: Obx(
            () => Slider(
                inactiveColor: Colors.grey,
                activeColor: hotPropertiesThemeColor,
                min: 0,
                divisions: controller.divisions.value,
                max: 1000,
                value: controller.boostData.value.budget!.value.toDouble(),
                onChanged: (value) => controller.onChangeSlider(value)),
          ),
        ),
      ],
    );
  }

  Widget _reachCard() {
    return Container(
      alignment: Alignment.centerLeft,
      width: 100.0.w - 20,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          shape: BoxShape.rectangle,
          color: Colors.grey.shade200),
      child: Text(
        controller.boostData.value.minReach!.value +
            "-" +
            controller.boostData.value.maxReach!.value +
            " " +
            AppLocalizations.of(
              "people per day",
            ),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: hotPropertiesThemeColor,
            fontSize: 15),
      ),
    );
  }

  Widget _walletCard() {
    return Container(
      width: 100.0.w - 20,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          shape: BoxShape.rectangle,
          color: Colors.grey.shade200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of("PayPal"),
            style: TextStyle(
                color: hotPropertiesThemeColor,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          Text(
            AppLocalizations.of("Available Balance") +
                "(\$${controller.boostData.value.walletBalance} USD)}",
            style: TextStyle(
                color: hotPropertiesThemeColor,
                fontWeight: FontWeight.normal,
                fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _paymentButton(BuildContext context) {
    return Container(
        height: 50,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            shape: BoxShape.rectangle,
            color: Colors.transparent),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Get.delete<BootPostController>();
              },
              child: Container(
                height: 50,
                color: Colors.grey.shade200,
                width: 50.0.w,
                child: Center(
                  child: Text(
                    AppLocalizations.of("Go back"),
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => controller.proceedToPay(context, postID!),
              child: Container(
                height: 50,
                color: hotPropertiesThemeColor,
                width: 50.0.w,
                child: Center(
                  child: Obx(
                    () => Container(
                      child: !controller.isPaying.value
                          ? Text(
                              AppLocalizations.of("Proceed to pay"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )
                          : SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                  child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.5,
                              ))),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BootPostController());
    controller.getBoostPostDetails(postID!);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<BootPostController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.close,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              Get.delete<BootPostController>();
            },
          ),
          title: Text(
            AppLocalizations.of("Boost Post"),
            style: TextStyle(
                fontSize: 15.0.sp,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
        body: Obx(
          () => Container(
              child: !controller.isDataLoading.value
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _userRow(),
                          _buttonRow(),
                          _customHeader(AppLocalizations.of("Post Button") +
                              " (" +
                              AppLocalizations.of("Optional") +
                              ")"),
                          _customSubHeader(
                              AppLocalizations.of("Add a button to your post")),
                          _buttonSelectorCard(),
                          _customSubHeader(AppLocalizations.of(
                              "Choose a link for this button")),
                          _linkTextField(),
                          _customHeader(AppLocalizations.of("Audience")),
                          AudiencesListItem(),
                          _customHeader(
                              AppLocalizations.of("Duration and Budget")),
                          _customSubHeader(AppLocalizations.of("Duration")),
                          _durationInfoCard(),
                          _durationRow(),
                          _customSubHeader(AppLocalizations.of("Total Budget")),
                          _budgetSlider(),
                          _customSubHeader(
                              AppLocalizations.of("Estimated people reached")),
                          _reachCard(),
                          _customHeader(AppLocalizations.of("Payment")),
                          _customSubHeader(
                              AppLocalizations.of("Payment Method")),
                          _walletCard(),
                          _paymentButton(context)
                        ],
                      ),
                    )
                  : Center(
                      child: SizedBox(
                          height: 22,
                          width: 22,
                          child: Center(
                              child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                            strokeWidth: 2.5,
                          ))),
                    )),
        ),
      ),
    );
  }
}
