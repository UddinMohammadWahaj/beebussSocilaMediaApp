import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/country_codes_model.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/profile_display_options.dart';
import 'package:bizbultest/view/select_profile_category_page.dart';
import 'package:bizbultest/view/update_profile_picture.dart';
import 'package:bizbultest/widgets/Edit%20Profile%20Cards/edit_profile_cards.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:bizbultest/widgets/ProfileSettings/disable_account_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;
import 'Profile/select_country_code.dart';
import 'change_password_page.dart';
import 'contact_options_profile.dart';

class EditProfile extends StatefulWidget {
  final String? scroll;
  final Function? refresh;
  final Function? setNavbar;
  final Function? calculate;

  EditProfile(
      {Key? key, this.scroll, this.refresh, this.setNavbar, this.calculate})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String response;
  late String memberId;
  late String username;
  late String name;
  late String website;
  late String bio;
  late String email;
  late String image;
  late int confirmMail;
  String? contact;
  late String gender;
  bool isProfileLoaded = false;
  String selectedCategory = "";
  late int value;
  String contactEmail = "";
  String contactNumber = "";
  String contactString = "";
  late int isPrivateAccount;
  late int contactOptionStatus;
  late int categoryOptionStatus;
  String options = "";

  String currentValue = "";
  String currentCode = "";

  List genderList = ["Male", "Female", "Custom", "Prefer Not To Say"];
  bool isPrivateSwitched = false;
  bool isDirectSwitched = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  ScrollController scrollController = ScrollController();
//TODO:: inSheet 299
  Future<void> deletePhoto() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=remove_profile_picture&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/remove_profile_picture.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1) {
      print(response.data['data']);
    }
  }

//TODO:: inSheet 300
  Future<void> updateAccountPrivacy(int val) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=private_account_update&user_id=${CurrentUser().currentUser.memberID}&val=$val");

    // var response = await http.get(url);
    var response = await ApiRepo.postWithToken("api/member_private_status.php",
        {"user_id": CurrentUser().currentUser.memberID, "val": val});

    if (response!.success == 1) {
      print(response.data['data']);
    }
  }

//TODO :: inSheet 102
  Future<void> getProfile() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?user_id=${CurrentUser().currentUser.memberID}&action=member_data_profile_top&profile_user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_profile.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "profile_user_id": CurrentUser().currentUser.memberID
    });

    print(response!.data);
    if (response!.success == 1) {
      int isDirectOff = response.data['data']['direct_message'] ? 1 : 0;
      if (this.mounted) {
        setState(() {
          if (isDirectOff == 1) {
            isDirectSwitched = true;
          } else {
            isDirectSwitched = false;
          }
          CurrentUser().currentUser.followers =
              response.data['data']['follower_count'].toString();
          CurrentUser().currentUser.following =
              response.data['data']['following_count'].toString();
          CurrentUser().currentUser.posts =
              response.data['data']['post_total'].toString();
        });
      }
    }
  }
//TODO:: inSheet 301

  Future<void> checkAccount() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=get_profile_private_data&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_private_status_check.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1) {
      print(response.data['data']);
      if (mounted) {
        setState(() {
          isPrivateAccount =
              response.data['data']['private_account'] ?? false ? 1 : 0;
        });
      }
      if (isPrivateAccount == 1) {
        setState(() {
          isPrivateSwitched = true;
        });
      } else {
        setState(() {
          isPrivateSwitched = false;
        });
      }
    }
  }

  late Future _countryFuture;
  CountryCodes codesList = new CountryCodes([]);
//TODO:: inSheet 302
  static Future<CountryCodes> getCountryCodes() async {
    // var url = Uri.parse("https://www.bebuzee.com/new_files/all_apis/user_update_data.php");

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "action": "get_country_code_all",
    // });

    var response = await ApiRepo.postWithToken("api/member_country_list.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });

    print(response!.data['data']);
    if (response.success == 1 &&
        response.data['data'] != null &&
        response.data['data'] != "") {
      CountryCodes countryData = CountryCodes.fromJson(response.data['data']);

      return countryData;
    } else {
      return new CountryCodes([]);
    }
  }

//TODO:: inSheet 303
  Future<void> getProfileData() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=edit_profile_data&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_detail.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1) {
      if (mounted) {
        setState(() {
          memberId = response.data['data']['user_id'] ?? "";
          username = response.data['data']['username'] ?? "";
          selectedCategory = response.data['data']['category_name'] ?? "";
          _usernameController.text = response.data['data']['username'] ?? "";
          contactEmail = response.data['data']['public_email'] ?? "";
          contactNumber = response.data['data']['public_contact'] ?? "";
          name = response.data['data']['name'] ?? "";
          _nameController.text = response.data['data']['name'] ?? "";
          website = response.data['data']['website'] ?? "";
          _websiteController.text = response.data['data']['website'] ?? "";
          bio = response.data['data']['bio'] ?? "";
          _bioController.text = response.data['data']['bio'] ?? "";
          _designationController.text =
              response.data['data']['designation'] ?? "";
          email = response.data['data']['email'] ?? "";
          _emailController.text = response.data['data']['email'] ?? "";
          image = response.data['data']['image'] ?? "";
          confirmMail =
              num.parse(response.data['data']['confirm_mail'] ?? "0") as int;
          contact = response.data['data']['contact'] ?? "";
          _numberController.text = response.data['data']['contact'] ?? "";
          gender = response.data['data']['gender'] ?? "";
          isProfileLoaded = true;
        });
      }
      if (contactNumber == "" && contactEmail == "") {
        setState(() {
          contactString = "";
        });
      } else if (contactNumber == "" && contactEmail != "") {
        setState(() {
          contactString = "Email";
        });
      } else if (contactNumber != "" && contactEmail == "") {
        setState(() {
          contactString = "Phone Number";
        });
      } else {
        setState(() {
          contactString = "Email,Phone Number";
        });
      }
    }
  }

//TODO:: inSheet 304
  Future<void> disableAccount() async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope_211220.php?action=final_submit_disable&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_account_disable.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });

    print(response!.data);
    if (response.success == 1) {}
  }

//TODO:: inSheet 305
  Future<void> optionsStatus() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=get_contact_display_data&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_privacy_status.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });

    if (response!.success == 1) {
      if (this.mounted) {
        setState(() {
          contactOptionStatus =
              response!.data['data']['contact'] ?? false ? 1 : 0;
          categoryOptionStatus =
              response.data['data']['category'] ?? false ? 1 : 0;
        });

        if (contactOptionStatus == 0 && categoryOptionStatus == 1) {
          setState(() {
            options = "Contacts Hidden";
          });
        } else if (categoryOptionStatus == 0 && contactOptionStatus == 1) {
          setState(() {
            options = "Category Hidden";
          });
        } else if (contactOptionStatus == 1 && categoryOptionStatus == 1) {
          setState(() {
            options = "All Options Visible";
          });
        } else {
          setState(() {
            options = "Contact Hidden, Category Hidden";
          });
        }
      }
    }
  }

//TODO:: inSheet 306
  Future<void> updateGender(String gender, dynamic val) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=gender_update_list_data&user_id=${CurrentUser().currentUser.memberID}&name=$gender&val=$val");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_gender_update.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "name": gender,
      "val": val,
    });

    print(response!.data['data']);
    if (response.success == 1) {}
  }

  RefreshProfile refresh = new RefreshProfile();
  ContactsRefresh _contactsRefresh = ContactsRefresh();
//TODO:: inSheet 307
  Future<void> updateProfileInfo(String name, String shortcode, String email,
      dynamic phone, String bio, String website) async {
    print(currentValue);

    // var url = Uri.parse("https://www.bebuzee.com/new_files/all_apis/user_update_data.php");

    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "action": "update_all_info_user",
    //   "user_fname": name,
    //   "user_name": shortcode,
    //   "user_Email": email,
    //   "user_Phone": phone,
    //   "user_Bio": bio,
    //   "user_Website": website,
    //   "country_code": currentValue,
    //   "designation" : _designationController.text
    // });

    var data = {
      "user_id": CurrentUser().currentUser.memberID,
      "action": "update_all_info_user",
      "user_fname": name,
      "user_name": shortcode,
      "user_Email": email,
      "user_Phone": phone,
      "user_Bio": bio,
      "user_Website": website,
      "country_code": currentValue,
      "designation": _designationController.text
    };
    print('updated=$data');
    var response =
        await ApiRepo.postWithToken("api/member_details_update.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "action": "update_all_info_user",
      "user_fname": name,
      "user_name": shortcode,
      "user_Email": email,
      "user_Phone": phone,
      "user_Bio": bio,
      "user_Website": website,
      "country_code": currentValue,
      "designation": _designationController.text
    });

    if (response!.success == 1) {
      print('updated priofile ${response.data['data']}');
      refresh.updateRefresh(true);
      _contactsRefresh.updateRefresh(true);
      // widget.calculate();
    }
  }

  void _setCodes() {
    _countryFuture = getCountryCodes().then((value) {
      setState(() {
        codesList.codes = value.codes;
      });
      codesList.codes.forEach((element) {
        if (element.usersCountry == 1) {
          int val = element.name!.split(" ").length - 1;
          setState(() {
            currentValue = element.value!;
            currentCode = element.name!.split(" ")[val];
          });
        }
      });
      return value;
    });
  }

  @override
  void initState() {
    optionsStatus();
    getProfile();
    _setCodes();
    getProfileData();
    checkAccount();
    super.initState();
  }

  void setCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
      ),
      body: isProfileLoaded == true
          ? WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
                widget.refresh!();
                widget.calculate!();
                return true;
              },
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          widget.calculate!();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.keyboard_backspace_outlined,
                                  size: 3.5.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 2.0.w),
                                  child: Text(
                                    AppLocalizations.of('Edit Profile'),
                                    style:
                                        blackBold.copyWith(fontSize: 16.0.sp),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                                splashColor: Colors.grey.withOpacity(0.3),
                                onTap: () {
                                  updateProfileInfo(
                                    _nameController.text,
                                    _usernameController.text,
                                    _emailController.text,
                                    _numberController.text,
                                    _bioController.text,
                                    _websiteController.text,
                                  );
                                  ScaffoldMessenger.of(
                                          _scaffoldKey.currentState!.context)
                                      .showSnackBar(showSnackBar(
                                          AppLocalizations.of(
                                              'Profile Information Updated Successfully')));
                                  // _setCodes();
                                },
                                child: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 3.5.h,
                                ))
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.0.h, bottom: 2.0.h),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0))),
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return ChangeProfilePhoto(
                                      changePhoto: () {
                                        Navigator.pop(context);
                                        pushNewScreen(
                                          context,
                                          screen: UpdateProfilePicture(),
                                          withNavBar:
                                              false, // OPTIONAL VALUE. True by default.
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      },
                                      deletePhoto: () {
                                        deletePhoto();
                                        getProfileData();
                                        ScaffoldMessenger.of(_scaffoldKey
                                                .currentState!.context)
                                            .showSnackBar(showSnackBar(
                                                AppLocalizations.of(
                                                    'Profile photo deleted successfully')));
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 7.0.h,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        CurrentUser().currentUser.image!),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 1.0.h),
                                  child: Text(
                                    AppLocalizations.of(
                                      "Change Profile Photo",
                                    ),
                                    style: TextStyle(
                                        color: primaryBlueColor,
                                        fontSize: 12.0.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      EditProfileTextInput(
                        title: "Name",
                        controller: _nameController,
                        hintText: "Name",
                      ),
                      EditProfileTextInput(
                        title: "Username",
                        controller: _usernameController,
                        hintText: "Username",
                      ),
                      EditProfileTextInput(
                        title: "Website",
                        controller: _websiteController,
                        hintText: "Website",
                      ),
                      EditProfileTextInput(
                        title: "Bio",
                        controller: _bioController,
                        hintText: "Bio",
                      ),
                      EditProfileTextInput(
                        title: "Designation",
                        controller: _designationController,
                        hintText: "Designation",
                      ),
                      EditProfileTextInput(
                        title: AppLocalizations.of(
                          'Email',
                        ),
                        maxLines: 1,
                        controller: _emailController,
                        hintText: AppLocalizations.of(
                          'Email',
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectCountryCode(
                                            countryList: codesList.codes,
                                            currentValue: currentValue,
                                            currentCode: currentCode,
                                            setCode: (value, code) {
                                              print("value ========= > $value");
                                              print("code ========== > $code");
                                              setState(() {
                                                currentValue = value;
                                                currentCode = code;
                                              });

                                              codesList.codes
                                                  .forEach((element) {
                                                if (element.usersCountry == 1) {
                                                  setState(() {
                                                    element.usersCountry = 0;
                                                  });
                                                }
                                                if (element.value == value) {
                                                  setState(() {
                                                    element.usersCountry = 1;
                                                  });
                                                }
                                              });
                                            },
                                          )));
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 11,
                                  ),
                                  Text(
                                    AppLocalizations.of(
                                      "code",
                                    ),
                                    style:
                                        greyNormal.copyWith(fontSize: 10.0.sp),
                                  ),
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Text(
                                    currentCode,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 100.0.w - 110,
                            child: EditProfileTextInput(
                              title: "Phone Number",
                              controller: _numberController,
                              hintText: "Phone Number",
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h, bottom: 1.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(
                                "Gender",
                              ),
                              style: greyNormal.copyWith(fontSize: 10.0.sp),
                            ),
                            DropdownButton<dynamic>(
                              focusColor: primaryBlueColor,

                              isExpanded: true,
                              //hint: Text("Select Category "),
                              items: genderList.map((e) {
                                return DropdownMenuItem(
                                  child: Text((e.toString())),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  gender = val;

                                  if (gender == "Male") {
                                    setState(() {
                                      value = 1;
                                    });
                                  } else if (gender == "Female") {
                                    setState(() {
                                      value = 2;
                                    });
                                  } else if (gender == "Prefer Not To Say") {
                                    setState(() {
                                      value = 3;
                                    });
                                  } else {
                                    setState(() {
                                      value = 4;
                                    });
                                  }
                                });
                                gender = val;
                                updateGender(gender, value);
                              },
                              value: gender,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lock_open_rounded),
                                Padding(
                                  padding: EdgeInsets.only(left: 1.0.h),
                                  child: Text(
                                    AppLocalizations.of(
                                      "Private Account",
                                    ),
                                    style: TextStyle(fontSize: 13.0.sp),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Switch(
                                  value: isPrivateSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isPrivateSwitched = value;
                                    });
                                    print(isPrivateSwitched);
                                    if (value == true) {
                                      updateAccountPrivacy(1);
                                    } else {
                                      updateAccountPrivacy(0);
                                    }
                                  },
                                  activeTrackColor:
                                      primaryBlueColor.withOpacity(0.4),
                                  activeColor: primaryBlueColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CustomIcons.chat_icon),
                                Padding(
                                  padding: EdgeInsets.only(left: 1.0.h),
                                  child: Text(
                                    AppLocalizations.of(
                                      "Direct Message",
                                    ),
                                    style: TextStyle(fontSize: 13.0.sp),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Switch(
                                  value: isDirectSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isDirectSwitched = value;
                                    });
                                    print(isDirectSwitched);
                                    if (value == true) {
                                      DirectApiCalls.disableDirectChat(1);
                                    } else {
                                      DirectApiCalls.disableDirectChat(0);
                                    }
                                  },
                                  activeTrackColor:
                                      primaryBlueColor.withOpacity(0.4),
                                  activeColor: primaryBlueColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Text(
                          AppLocalizations.of(
                            "Profile Information",
                          ),
                          style: TextStyle(fontSize: 13.0.sp),
                        ),
                      ),
                      ProfileInfoCard(
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectProfileCategory(
                                        setCategory: () {
                                          getProfileData();
                                        },
                                      )));
                        },
                        title: AppLocalizations.of(
                          "Category",
                        ),
                        value: selectedCategory,
                      ),
                      ProfileInfoCard(
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactOptionsProfile(
                                        refresh: () {
                                          getProfileData();
                                        },
                                        email: contactEmail,
                                        number: contactNumber,
                                      )));
                        },
                        title: AppLocalizations.of(
                          "Contact Options",
                        ),
                        value: contactString,
                      ),
                      ProfileInfoCard(
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileDisplayOptions(
                                        contactOption: contactOptionStatus == 1
                                            ? true
                                            : false,
                                        categoryOption:
                                            categoryOptionStatus == 1
                                                ? true
                                                : false,
                                        refresh: () {
                                          optionsStatus();
                                        },
                                        category: selectedCategory,
                                      )));
                        },
                        title: AppLocalizations.of(
                          "Profile Display",
                        ),
                        value: options,
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                      InkWell(
                        splashColor: Colors.grey.withOpacity(0.3),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePasswordPage()));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.0.h),
                          child: Container(
                              width: 100.0.w,
                              color: Colors.transparent,
                              child: Text(
                                AppLocalizations.of(
                                  "Change Password",
                                ),
                                style: TextStyle(
                                    color: primaryBlueColor, fontSize: 12.0.sp),
                              )),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.grey.withOpacity(0.3),
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20.0),
                                      topRight: const Radius.circular(20.0))),
                              //isScrollControlled:true,
                              context: context,
                              builder: (BuildContext bc) {
                                return Container(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.5.h,
                                              horizontal: 2.0.w),
                                          child: Text(
                                            AppLocalizations.of(
                                              "Are you sure you want to disable your account?",
                                            ),
                                            style: TextStyle(fontSize: 14.0.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          //  widget.setNavbar(true);
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DisableAccountConfirmationPage(
                                                        setNavbar:
                                                            widget.setNavbar,
                                                      )));
                                        },
                                        title: Center(
                                            child: Text(
                                          AppLocalizations.of(
                                            "Yes",
                                          ),
                                          style: TextStyle(
                                              fontSize: 12.0.sp,
                                              color: Colors.red),
                                        )),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        title: Center(
                                            child: Text(
                                          AppLocalizations.of(
                                            "No",
                                          ),
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                          ),
                                        )),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.0.h),
                          child: Container(
                              width: 100.0.w,
                              color: Colors.transparent,
                              child: Text(
                                AppLocalizations.of(
                                  "Temporarily disable my account",
                                ),
                                style: TextStyle(
                                    color: primaryBlueColor, fontSize: 12.0.sp),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}

class ChangeProfilePhoto extends StatelessWidget {
  final VoidCallback? changePhoto;
  final VoidCallback? deletePhoto;

  ChangeProfilePhoto({Key? key, this.changePhoto, this.deletePhoto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 1.5.h, bottom: 2.0.h),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 5,
              width: 10.0.w,
            ),
          )),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'New Profile Photo',
              ),
            ),
            onTap: changePhoto ?? () async {},
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(
                'Delete Photo',
              ),
            ),
            onTap: deletePhoto ?? () async {},
          ),
        ],
      ),
    );
  }
}
