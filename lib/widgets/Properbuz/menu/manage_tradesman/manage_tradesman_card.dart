import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/add_tradesman_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_solo_tradesmen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../view/Properbuz/menu/premium_package_view.dart';

class ManageTradesmanCard extends GetView<AddTradesmenController> {
  AddTradesmenController ctr = Get.put(AddTradesmenController());
  ManageTradesmanCard({
    Key? key,
    required this.index,
    required this.id,
    this.fullName,
    this.email,
    this.mobile,
    this.experience,
    this.profileImage,
    this.createdAt,
    this.companyId,
    this.passData,
    this.setstate,
  }) : super(key: key);
  final int index;
  final String id;
  final String? fullName;
  final String? email;
  final String? mobile;
  final String? experience;
  final String? profileImage;
  final String? createdAt;
  final companyId;
  List? passData = [];
  StateSetter? setstate;

  Widget imageCard() {
    return Container(
      height: 60,
      width: 60,
      child: CircleAvatar(
        backgroundColor: settingsColor,
        child: ClipOval(
          child: profileImage == ""
              ? Image.asset(
                  "assets/images/profile-picture.webp",
                  fit: BoxFit.fill,
                )
              : Image.network(
                  profileImage!,
                  fit: BoxFit.fill,
                  height: 60,
                  width: 60,
                ),
        ),
      ),
    );
  }

  Widget _customText(String title, String value) {
    return Text(
      AppLocalizations.of("$title" + value),
      style:
          TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _customTextButton(
      String value, Color textColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 40,
          width: 47.5.w,
          color: bgColor,
          child: Center(
              child: Text(
            value,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w500, fontSize: 15),
          ))),
    );
  }

  Widget _actionRow(context) {
    return Row(
      children: [
        _customTextButton(
            AppLocalizations.of(
              "Upgrade",
            ),
            Colors.white,
            settingsColor, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PremiumPackageView()));
        }),
        _customTextButton(
            AppLocalizations.of(
              "Edit",
            ),
            settingsColor,
            Colors.grey.shade200, () {
          print("object... ${ctr.companyId}");
          setstate!(
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SoloTradesmenView(
                            "solo",
                            ctr.companyId,
                            passData!,
                          ))).then((value) {
                setstate!(
                  () {
                    passData = [];
                    setstate!(
                      () {},
                    );
                    setstate!(
                      () async {
                        await ctr.fetchTradesmenList(
                            companyId: int.parse(companyId),
                            setsate: setstate!);
                      },
                    );
                  },
                );
              });
            },
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AddTradesmenController());
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        // child: Padding(
        // padding: EdgeInsets.symmetric(vertical: 10),
        //
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: imageCard(),
              title: Text(
                AppLocalizations.of("Name") + " : $fullName",
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _customText(
                    AppLocalizations.of(AppLocalizations.of("Email") + " : "),
                    "$email",
                  ),
                  _customText(
                    AppLocalizations.of(AppLocalizations.of("Contact") +
                        " " +
                        AppLocalizations.of("number") +
                        " : "),
                    "$mobile",
                  ),
                  _customText(
                    AppLocalizations.of(
                        AppLocalizations.of("Experience") + " : "),
                    "$experience",
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, bottom: 5),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(AppLocalizations.of(createdAt!)),
              ),
            ),
            _actionRow(context),
          ],
        ),
      ),
    );
  }
}
