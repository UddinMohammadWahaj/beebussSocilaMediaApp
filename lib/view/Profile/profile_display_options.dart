import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:bizbultest/widgets/profile_display_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

class ProfileDisplayOptions extends StatefulWidget {
  final String? category;
  final bool? contactOption;
  final bool? categoryOption;
  final Function? refresh;

  const ProfileDisplayOptions(
      {Key? key,
      this.category,
      this.contactOption,
      this.categoryOption,
      this.refresh})
      : super(key: key);
  @override
  _ProfileDisplayOptionsState createState() => _ProfileDisplayOptionsState();
}

class _ProfileDisplayOptionsState extends State<ProfileDisplayOptions> {
  bool showCategory = true;
  bool showContact = false;

  void setShowCategory(val) {
    setState(() {
      showCategory = val;
    });
  }

  void setShowContact(val) {
    setState(() {
      showContact = val;
    });
  }

  void setOptions() {
    setState(() {
      showContact = widget.contactOption!;
      showCategory = widget.categoryOption!;
    });
  }

  Future<void> hideOptions(int category, int contact) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/member_contact_category_update.php?action=update_profile_contact_display");
    print("category update category=${category} contact=${contact}");
    var response =
        await ApiRepo.postWithToken("api/member_contact_category_update.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "contact": contact,
      "category": category,
    });

    print("contact category update ${response}");
  }

  RefreshProfile refresh = new RefreshProfile();

  @override
  void initState() {
    setOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          widget.refresh!();
          refresh.updateRefresh(true);
          return true;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 1.5.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          widget.refresh!();
                          refresh.updateRefresh(true);
                        },
                        child: Icon(
                          Icons.keyboard_backspace_outlined,
                          size: 3.5.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.0.w),
                        child: Text(
                          AppLocalizations.of(
                            "Contact Options",
                          ),
                          style: blackBold.copyWith(fontSize: 15.0.sp),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          refresh.updateRefresh(true);
                          widget.refresh!();
                        },
                        child: Icon(
                          Icons.check,
                          size: 3.5.h,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 7.0.h, bottom: 5.0.h),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(
                        "Profile Display Options",
                      ),
                      style: TextStyle(fontSize: 22.0.sp),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.0.w, vertical: 1.0.h),
                      child: Text(
                        AppLocalizations.of(
                          "You can hide or show your category and contact details on your profile. You can change this anytime.",
                        ),
                        style: greyNormal.copyWith(fontSize: 10.5.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    SwitchButtons(
                      condition: AppLocalizations.of(
                        'label',
                      ),
                      setShowCategory: (val) {
                        setShowCategory(val);

                        hideOptions(showCategory ? 1 : 0, showContact ? 1 : 0);
                      },
                      initialValue: showCategory,
                      title: AppLocalizations.of(
                        "Display category label",
                      ),
                    ),
                    SwitchButtons(
                      condition: AppLocalizations.of(
                        'contact',
                      ),
                      showContact: (val) {
                        setShowContact(val);
                        hideOptions(showCategory ? 1 : 0, showContact ? 1 : 0);
                      },
                      initialValue: showContact,
                      title: AppLocalizations.of(
                        "Display contact info",
                      ),
                    ),
                  ],
                ),
              )),
              ProfileDisplayCard(
                category: widget.category,
                showCategory: showCategory,
                showContact: showContact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SwitchButtons extends StatefulWidget {
  bool? initialValue;
  final String? title;
  final String? condition;
  final Function? setShowCategory;
  final Function? showContact;

  SwitchButtons(
      {Key? key,
      this.initialValue,
      this.title,
      this.setShowCategory,
      this.showContact,
      this.condition})
      : super(key: key);

  @override
  _SwitchButtonsState createState() => _SwitchButtonsState();
}

class _SwitchButtonsState extends State<SwitchButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title!,
            style: TextStyle(fontSize: 12.0.sp),
          ),
          Switch(
            value: widget.initialValue!,
            onChanged: (value) {
              if (widget.condition == 'label') {
                widget.setShowCategory!(value);
              } else if (widget.condition == 'contact') {
                widget.showContact!(value);
              }
              setState(() {
                widget.initialValue = value;
              });
            },
            activeTrackColor: primaryBlueColor.withOpacity(0.4),
            activeColor: primaryBlueColor,
          ),
        ],
      ),
    );
  }
}
