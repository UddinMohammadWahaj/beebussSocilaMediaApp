import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as gett;
import 'dart:convert';
import 'dart:async';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:bizbultest/models/address_search_model.dart';
import 'package:bizbultest/models/audience_model.dart';
import 'dart:io' as i;
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/view/create_audience.dart';
import 'package:bizbultest/view/edit_audience.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../api/api.dart';
import 'edit_audience_advert.dart';
import 'new_audience.dart';
import '../../../api/ApiRepo.dart' as ApiRepo;

class CreateVideoAdvert extends StatefulWidget {
  final GlobalKey<ScaffoldState>? sKey;
  TabController? tabController;

  CreateVideoAdvert({Key? key, this.sKey, this.tabController})
      : super(key: key);

  @override
  _CreateVideoAdvertState createState() => _CreateVideoAdvertState();
}

class _CreateVideoAdvertState extends State<CreateVideoAdvert> {
  late int value;
  List buttonList = [];
  var buttonString;
  var selectedButton;
  int _value = 6;
  int days = 4;
  bool isLoading = false;
  bool showLocationList = false;
  TextEditingController _buttonLinkController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _couponController = TextEditingController();

  String minReach = "30";
  late String maxReach;
  late String walletBalance = '';
  bool dataLoaded = false;
  bool showProfileButton = false;

  late String? urlDomain = "";
  String? urlTitle = "";
  String? urlDescription = "";
  String? paymentUrl = "";

  late String totalBudget;
  late String adBudget;
  late String postID;
  late String dataID;

  bool hasData = false;
  late int division;
  bool hasAudience = false;
  late String selectedAudienceId;

  late Addresses address;

  late Audiences audienceList;

  Future<void> getButton() async {
    var url = Uri.parse("https://www.bebuzee.com/api/video_ad_button.php");

    var response = await http.get(url);
    print("response of get button $response");
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          buttonString = jsonDecode(response.body)['button'];
          buttonList = buttonString.split("~~").toList();
          selectedButton = buttonList[2];
        });
      }
    }
  }

  Future<List> getLocationData(String search) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_all_boosted.php?action=location_sugession&keywords=$search");

    var response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      Addresses addressDataData = Addresses.fromJson(jsonDecode(response.body));
      print(addressDataData.addresses[0].name);
      setState(() {
        address = addressDataData;
        hasData = true;
      });

      if (response.body == null || response.statusCode != 200) {
        setState(() {
          hasData = false;
        });
      }
    }

    return address.addresses;
  }

  Future<void> getAudienceData() async {
    //var url = Uri.parse( "https://www.bebuzee.com/app_devlope_all_boosted.php?action=get_all_audience_user&user_id=$memberID");
    //var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/get_all_audience_user.php",
        {"user_id": CurrentUser().currentUser.memberID!});
    print("audience data valled =${response!.data}");
    if (response!.success == 1) {
      Audiences audienceData = Audiences.fromJson(response.data['data']);
      setState(() {
        audienceList = audienceData;
        hasAudience = true;
      });
      // return audienceData.audiences;
    }
  }
  // Future<void> getAudienceData() async {
  //   var url =
  //       Uri.parse("https://www.bebuzee.com/app_devlope_all_boosted.php?action=get_all_audience_user&user_id=${CurrentUser().currentUser.memberID!}");

  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       Audiences audienceData = Audiences.fromJson(jsonDecode(response.body));

  //       setState(() {
  //         audienceList = audienceData;
  //         hasAudience = true;
  //       });
  //     });
  //   }
  //   return "Success";
  // }

  Future<void> boostPost() async {
    setState(() {
      isLoading = true;
    });

    var url = "https://www.bebuzee.com/api/save_boosted_data_video_ad.php";
    final response = await ApiProvider().fireApiWithParams(url, params: {
      "user_id": CurrentUser().currentUser.memberID!,
      "ad_duration": days.toString(),
      "audience_data": selectedAudienceId.toString(),
      "ad_budget": _value.toString(),
      "ad_button": selectedButton,
      "ad_url": _buttonLinkController.text,
      "title": urlTitle,
      "ad_url_title": urlTitle,
      "domain": urlDomain,
      "coupon_code": _couponController.text,
      "description": urlDescription,
      "image": logo,
      "video": videoUrl,
    });
    // final response = await http.post(url, body: {
    //   "user_id": CurrentUser().currentUser.memberID!,
    //   "ad_duration": days.toString(),
    //   "audience_data": selectedAudienceId.toString(),
    //   "ad_budget": _value.toString(),
    //   "ad_button": selectedButton,
    //   "ad_url": _buttonLinkController.text,
    //   "title": urlTitle,
    //   "ad_url_title": urlTitle,
    //   "domain": urlDomain,
    //   "coupon_code": _couponController.text,
    //   "description": urlDescription,
    //   "image": logo,
    //   "video": videoUrl,
    //   "action": "save_boosted_data_video_ad",
    // });
    print("response of boost data=${response.data}");
    if (response.statusCode == 200) {
      print(response.data);

      if (response.data['payment_method'] == 'wallet') {
        Navigator.of(context).pop();
        gett.Get.showSnackbar(gett.GetSnackBar(
          title: 'Success Payment',
          message: 'Successful payment', duration: Duration(seconds: 1),
          // titleText: Text('Success Payment!'),
          icon: Icon(Icons.money, color: Colors.green),
        ));
        return;
      }
      setState(() {
        paymentUrl = response.data['url_data_paypal'];
        totalBudget = response.data['total_budget'];
        adBudget = response.data['ad_budget'];
        dataID = response.data['data_id'];
        isLoading = false;
      });

      print('response of payment $paymentUrl');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebsiteView(
                  url: paymentUrl,
                  from: "video",
                  heading: "Payment",
                  memberID: CurrentUser().currentUser.memberID!,
                  adBudget: adBudget,
                  totalBudget: totalBudget,
                  tabController: widget.tabController,
                  dataID: dataID,
                  postID: postID)));
    }
  }

  late i.File _image;
  late i.File _video;
  late i.File _thumbnail;

  bool isVideoPicked = false;
  bool imagePicked = false;
  bool isVideoUploaded = false;
  int uploadProgress = 0;
  int logoUploadProgress = 0;

  _imgFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _image = i.File(result.files.single.path!);
        // uploadLogo();
        uploadLogoTest();
      });
    } else {
      // User canceled the picker
    }
  }

  String videoUrl = "";
  String logo = "";
  late VideoPlayerController _controller;
  bool initialized = false;
  Future<String?> getToken() async {
    return await ApiProvider()
        .refreshToken(CurrentUser().currentUser.memberID!!);
  }

  void uploadVideoTest() async {
    var url = 'https://www.bebuzee.com/api/video_ad_video_url.php';
    var client = Dio();
    var formdata = FormData();
    var token = await getToken();

    formdata.files
        .addAll([MapEntry("file1", await MultipartFile.fromFile(_video.path))]);

    print("formdata.length =${formdata.files.length}");

    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        data: formdata, onSendProgress: (sent, total) {
      final progress = sent / total;
      if (mounted) {
        setState(() {
          uploadProgress = (progress * 100).toInt();
        });
      }
      print("progress from response object " + sent.toString());
    }).then((value) => value);
    print("video upload response= ${response.data['video']}");
    if (response.data['video'] != '') {
      print('response of video upload $response');
      setState(() {
        videoUrl = response.data['video'];
      });
      _controller = VideoPlayerController.network(response.data['video'])
        // Play the video again when it ends
        ..setLooping(true)
        // initialize the controller and notify UI when done
        ..initialize().then((_) => setState(() => initialized = true));
    }
  }

  void uploadVideo() async {
    var request = mp.MultipartRequest();
    request.setUrl("https://www.bebuzee.com/api/video_ad_video_url.php");

    request.addFile("file1", _video.path);
    mp.Response response = request.send();
    // print("response of video upload ya =${response.}");
    response.onError = () {
      print("response of video upload Error");
    };

    try {
      response.onComplete = (response) {
        print('response of video upload $response');
        setState(() {
          videoUrl = jsonDecode(response)['video'];
        });
        _controller =
            VideoPlayerController.network(jsonDecode(response)['video'])
              // Play the video again when it ends
              ..setLooping(true)
              // initialize the controller and notify UI when done
              ..initialize().then((_) => setState(() => initialized = true));
      };
    } catch (e) {
      print("response of video upload error catch=${e}");
    }
    response.progress.listen((int progress) {
      if (mounted) {
        setState(() {
          uploadProgress = progress;
        });
      }
      print("progress from response object " + progress.toString());
    });
  }

  void uploadLogoTest() async {
    var url = 'https://www.bebuzee.com/api/video_ad_image_url.php';
    var client = Dio();
    var formdata = FormData();
    var token = await getToken();

    formdata.files
        .addAll([MapEntry("file1", await MultipartFile.fromFile(_image.path))]);

    print("formdata.length =${formdata.files.length}");

    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        data: formdata, onSendProgress: (sent, total) {
      final progress = sent / total;
      // print("progress from response object image " + p.toString());
      setState(() {
        logoUploadProgress = (progress * 100).toInt();
      });
    }).then((value) => value);
    print("response of logo upload =${response.data}");
    if (response.data['image'] != '') {
      setState(() {
        logo = response.data['image'];
      });
    }
  }

  void uploadLogo() async {
    var request = mp.MultipartRequest();
    // request.setUrl(
    //     "https://www.bebuzee.com/new_files/all_apis/video_ad_api.php?action=create_custom_thumb_video_temp");

    request.setUrl('https://www.bebuzee.com/api/video_ad_image_url.php');
    request.addFile("file1", _image.path);
    mp.Response response = request.send();
    response.onError = () {
      print("Error");
    };
    response.onComplete = (response) {
      print(response);
      setState(() {
        logo = jsonDecode(response)['image'];
      });
    };

    response.progress.listen((int progress) {
      if (mounted) {
        setState(() {
          logoUploadProgress = progress;
        });
      }
      print("progress from response object " + progress.toString());
    });
  }

  _videoFromGallery() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        _video = i.File(result.files.single.path!);
      });
      print(_video.path);
      uploadVideoTest();
      // uploadVideo();
    } else {
      // User canceled the picker
    }
  }

  Future<void> getURL(String urls) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=url_meta_content&user_id=${CurrentUser().currentUser.memberID!}&url=$urls");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/other/urlMetaData?user_id=${CurrentUser().currentUser.memberID!}&url=$urls');
    print("get url url=${newurl}");

    // var response = await http.get(url);
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var response = await client
        .postUri(
          newurl,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);
    print("get url response=${response.data}");
    if (response.statusCode == 200) {
      setState(() {
        urlDomain =
            response.data['domain'] == '' ? null : response.data['domain'];
        urlTitle = response.data['title'] == '' ? null : response.data['title'];
        urlDescription = response.data['description'];
      });
    }
  }

  Future<void> getWalletBalance() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/video_ad_api.php?user_id=${CurrentUser().currentUser.memberID!}&action=wallet_balance_data");
    var newurl =
        'https://www.bebuzee.com/api/wallet_balance_data.php?user_id=${CurrentUser().currentUser.memberID!}';
    print("wallet balance url=$newurl");
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    var response = await client
        .postUri(
          Uri.parse(newurl),
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }),
        )
        .then((value) => value);
    // var response = await http.get(url);

    if (response.statusCode == 200) {
      print('wallet balnce=${response.data}');
      setState(() {
        walletBalance = response.data['balance'];
      });
    }
  }

  /* Future<void> boost(String url) async {
    var response = await http.get(
        "https://www.bebuzee.com/app_developenew.php?action=save_boosted_data&post_id=${widget.feed.postId}&user_id=${widget.memberID}&ad_duration=${days.toInt()}&audience_id=${selectedAudienceId.toString()}&audience_id=[audience id]&ad_budget=${_value.toInt()}&ad_button=${selectedButton.toString()}&ad_url=${_buttonLinkController.text}&title=${urlTitle.toString()}&domain=${urlDomain.toString()}&description=[ad url description]&coupon_code=[coupon code]&post_type=[post type]");

    if (response.statusCode == 200) {
      print(response.body);
    }
    return "Success";
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  DateTime selectedDate = DateTime.now().add(Duration(days: 4));

  Future<void> _selectDate(BuildContext context) async {
    //selectedDate = DateTime.now().add(Duration(days: int.parse(_daysController.text)));
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    setState(() {
      _daysController.text = days.toString();
    });
    getButton();
    getWalletBalance();
    getAudienceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0.h),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              uploadProgress == 0
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0.h),
                      child: Center(
                          child: InkWell(
                        onTap: () {
                          _videoFromGallery();
                        },
                        child: Container(
                          width: 90.0.w,
                          height: 25.0.h,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            shape: BoxShape.rectangle,
                            border: new Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 12.0.h,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    "Select a video file to upload",
                                  ),
                                  style: TextStyle(fontSize: 14.0.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0.w, vertical: 2.0.h),
                          child: Text(
                            uploadProgress < 100
                                ? AppLocalizations.of("Processing")
                                : AppLocalizations.of(
                                    "Processing Done!",
                                  ),
                            style: TextStyle(
                                fontSize: 12.0.sp, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.0.h,
                              left: 1.0.w,
                              right: 1.0.w,
                              bottom: 2.0.h),
                          child: new LinearPercentIndicator(
                            backgroundColor: primaryBlueColor.withOpacity(0.3),
                            //width: 90.0.w,
                            animation: false,
                            lineHeight: 2.5.h,
                            animationDuration: 2500,
                            percent: uploadProgress / 100,
                            center: Text(
                              uploadProgress.toString() + "%",
                              style: TextStyle(
                                  fontSize: 12.0.sp, color: Colors.white),
                            ),
                            linearStrokeCap: LinearStrokeCap.butt,
                            progressColor: primaryBlueColor,
                          ),
                        ),
                        initialized == true
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.0.h),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  // Use the VideoPlayer widget to display the video.
                                  child: VideoPlayer(_controller),
                                ),
                              )
                            : Container(),
                        initialized
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.0.w, vertical: 1.0.h),
                                child: InkWell(
                                  onTap: () {
                                    _videoFromGallery();
                                    setState(() {
                                      uploadProgress = 0;
                                      initialized = false;
                                      _controller.dispose();
                                    });
                                  },
                                  child: Container(
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        shape: BoxShape.rectangle,
                                        border: new Border.all(
                                          color: Colors.black,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Center(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0.5.h),
                                        child: Text(
                                          AppLocalizations.of(
                                            "Change Video",
                                          ),
                                          style: TextStyle(fontSize: 12.0.sp),
                                        ),
                                      ))),
                                ),
                              )
                            : Container()
                      ],
                    ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.5.h),
                child: Text(
                  AppLocalizations.of(
                    "POST BUTTON (Optional)",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 1.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Add a button to your post",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w),
                child: Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: DropdownButton(
                      isExpanded: true,
                      //hint: Text("Select Category "),
                      items: buttonList.map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedButton = val;

                          if (selectedButton == "Visit Bebuzee Profile") {
                            setState(() {
                              showProfileButton = true;
                              _buttonLinkController.text =
                                  "https://www.bebuzee.com/${CurrentUser().currentUser.shortcode}";
                            });
                          } else {
                            setState(() {
                              showProfileButton = false;
                              _buttonLinkController.text = "";
                            });
                          }
                        });

                        print(selectedButton);
                      },
                      value: selectedButton,
                    ),
                  ),
                ),
              ),
              logoUploadProgress == 0
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0.h),
                      child: Center(
                          child: InkWell(
                        onTap: () {
                          _imgFromGallery();
                        },
                        child: Container(
                          width: 90.0.w,
                          height: 25.0.h,
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            shape: BoxShape.rectangle,
                            border: new Border.all(
                              color: Colors.black,
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 12.0.h,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    "Select a Logo",
                                  ),
                                  style: TextStyle(fontSize: 14.0.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.0.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.0.w, vertical: 2.0.h),
                            child: Text(
                              logoUploadProgress < 100
                                  ? AppLocalizations.of("Processing Logo")
                                  : AppLocalizations.of(
                                      "Logo Processing Done!",
                                    ),
                              style: TextStyle(
                                  fontSize: 12.0.sp, color: Colors.black),
                            ),
                          ),
                          logo != ""
                              ? Container(
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      logo,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(),
                          logo != ""
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.0.w, vertical: 1.0.h),
                                  child: InkWell(
                                    onTap: () {
                                      _imgFromGallery();
                                      setState(() {
                                        logoUploadProgress = 0;
                                        logo = "";
                                      });
                                    },
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          shape: BoxShape.rectangle,
                                          border: new Border.all(
                                            color: Colors.black,
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Center(
                                            child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.5.h),
                                          child: Text(
                                            AppLocalizations.of(
                                              "Change Logo",
                                            ),
                                            style: TextStyle(fontSize: 12.0.sp),
                                          ),
                                        ))),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 1.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Choose a link for this button",
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 1.5.h, right: 2.0.w),
                child: Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextFormField(
                      onTap: () {
                        setState(() {});
                      },
                      onChanged: (val) {
                        if (val != "") {
                          getURL(val);
                        } else if (val == "") {
                          setState(() {
                            print("url domain is null");
                            urlDomain = null;
                            urlTitle = null;
                          });
                        }
                      },
                      maxLines: 2,
                      controller: _buttonLinkController,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryBlueColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: AppLocalizations.of(
                          "Add a link",
                        ),

                        // 48 -> icon width
                      ),
                    ),
                  ),
                ),
              ),
              _buttonLinkController.text.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.0.w, vertical: 1.0.h),
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 1.0.w,
                              top: 2.0.h,
                              right: 1.0.w,
                              bottom: 2.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              urlDomain != null && urlTitle != null
                                  ? Row(
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                showProfileButton! == true
                                                    ? "bebuzee.com"
                                                    : urlDomain!,
                                                style: blackBoldShaded,
                                              ),
                                              Container(
                                                width: 58.0.w,
                                                child: Text(
                                                  showProfileButton == true
                                                      ? CurrentUser()
                                                          .currentUser
                                                          .fullName!
                                                      : urlTitle!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : showProfileButton == true
                                      ? Row(
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "bebuzee.com",
                                                    style: blackBoldShaded,
                                                  ),
                                                  Container(
                                                    width: 58.0.w,
                                                    child: Text(
                                                      CurrentUser()
                                                          .currentUser
                                                          .fullName!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                              Row(
                                children: [
                                  Container(
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: new Border.all(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(1.5.w),
                                      child: Text(
                                        selectedButton,
                                        style: blackBold.copyWith(
                                            color: primaryBlueColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 1.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Choose the website address you'd like to send people to.",
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 12),
                ),
              ),
              SizedBox(
                height: 1.0.h,
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, bottom: 0),
                child: Text(
                  AppLocalizations.of(
                    "AUDIENCE",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              hasAudience == true
                  ? Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: audienceList.audiences.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                  width: 85.0.w,
                                  child: RadioListTile(
                                    dense: true,
                                    activeColor: primaryBlueColor,
                                    value: index,
                                    groupValue: value,
                                    onChanged: (dynamic ind) {
                                      setState(() {
                                        value = ind!;
                                        selectedAudienceId = audienceList
                                            .audiences[index].audienceId!;
                                        print(selectedAudienceId);
                                      });
                                    },
                                    title: Text(audienceList
                                        .audiences[index].audienceName!),
                                    subtitle: Container(
                                      width: 85.0.w,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: audienceList
                                                  .audiences[index]
                                                  .audienceAgeData,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        //isScrollControlled:true,
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return EditAudienceAdvert(
                                            refresh: () {
                                              Timer(Duration(seconds: 2), () {
                                                getAudienceData();
                                              });
                                            },

                                            audienceId: audienceList
                                                .audiences[index].audienceId,
                                            memberName: CurrentUser()
                                                .currentUser
                                                .fullName,
                                            memberImage:
                                                CurrentUser().currentUser.image,
                                            //  feed: widget.feed,
                                            logo:
                                                CurrentUser().currentUser.logo,
                                            country: CurrentUser()
                                                .currentUser
                                                .country,
                                            memberID: CurrentUser()
                                                .currentUser
                                                .memberID,
                                          );
                                        });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2.0.w),
                                      child: Text(
                                        AppLocalizations.of(
                                          "Edit",
                                        ),
                                        style:
                                            TextStyle(color: primaryBlueColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0))),
                      //isScrollControlled:true,
                      context: context,
                      builder: (BuildContext bc) {
                        return CreateAudienceAdvert(
                          refresh: () {
                            Timer(Duration(seconds: 3), () {
                              getAudienceData();
                            });
                          },

                          memberName: CurrentUser().currentUser.fullName,
                          memberImage: CurrentUser().currentUser.image,
                          //  feed: widget.feed,
                          logo: CurrentUser().currentUser.logo,
                          country: CurrentUser().currentUser.country,
                          memberID: CurrentUser().currentUser.memberID!,
                        );
                      });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 2.0.w, top: 1.0.h, right: 1.0.w),
                    child: Text(
                      AppLocalizations.of(
                        "Create new audience",
                      ),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryBlueColor,
                          fontSize: 12),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.0.h,
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 2.0.w,
                ),
                child: Text(
                  AppLocalizations.of(
                    "DURATION AND BUDGET",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 1.0.h),
                child: Text(
                  AppLocalizations.of(
                    "Duration",
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 2.0.h),
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: new Border(
                      top: BorderSide(color: Colors.grey, width: 1),
                      bottom: BorderSide(color: Colors.grey, width: 1),
                      left: BorderSide(color: Colors.yellow.shade700, width: 3),
                      right: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.0.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          CustomIcons.warning,
                          color: Colors.yellow.shade700,
                          size: 18,
                        ),
                        SizedBox(
                          width: 2.0.w,
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
                              padding: EdgeInsets.only(top: 2.0.h),
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
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(
                            "Days",
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 14),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        Container(
                          width: 12.0.w,
                          height: 2.5.h,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]')),
                              ],
                              onTap: () {
                                setState(() {});
                              },
                              onChanged: (val) {
                                if (val.length > 0 &&
                                    int.tryParse(val) != null) {
                                  setState(() {
                                    days = int.parse(val);
                                    selectedDate = DateTime.now()
                                        .add(Duration(days: int.parse(val)));

                                    String maxVal =
                                        ((_value.toInt() * 1400) / days)
                                            .toStringAsFixed(0);
                                    String newMax = "";
                                    for (int i = 0; i < maxVal.length; i++) {
                                      if ((i) % 3 == 0 && i != 0) {
                                        newMax += ",";
                                      }
                                      newMax += maxVal[maxVal.length - i - 1];
                                    }
                                    String minVal =
                                        ((_value.toInt() / 0.05) / days)
                                            .toStringAsFixed(0);
                                    String newMin = "";
                                    for (int i = 0; i < minVal.length; i++) {
                                      if ((i) % 3 == 0 && i != 0) {
                                        newMin += ",";
                                      }
                                      newMin += minVal[minVal.length - i - 1];
                                    }
                                    setState(() {
                                      minReach =
                                          newMin.split('').reversed.join();
                                      maxReach =
                                          newMax.split('').reversed.join();
                                    });
                                  });
                                }
                              },
                              maxLines: 1,
                              controller: _daysController,
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0.w),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryBlueColor, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                                //hintText: "Add a link",
                                // 48 -> icon width
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(
                            "End Date",
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 14),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        GestureDetector(
                            onTap: () {
                              print("${selectedDate.toLocal()}".split(' ')[0]);

                              _selectDate(context);
                            },
                            child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0.w, vertical: 0.5.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        selectedDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]
                                                .split("-")[2] +
                                            "-" +
                                            selectedDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]
                                                .split("-")[1] +
                                            "-" +
                                            selectedDate
                                                .toLocal()
                                                .toString()
                                                .split(' ')[0]
                                                .split("-")[0],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 1.0.w,
                                      ),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                      )
                                    ],
                                  ),
                                ))),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                child: Text(
                  AppLocalizations.of(
                    "Total Budget",
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                child: Text(
                  "\$ " + _value.toString() + ".00",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 25),
                ),
              ),
              Container(
                child: Slider(
                  inactiveColor: Colors.grey,
                  activeColor: primaryBlueColor,
                  min: 1,
                  divisions: division,
                  max: 1000,
                  value: _value.toDouble(),
                  onChanged: (value) {
                    if (value.toInt() < 10) {
                      setState(() {
                        division = 1000;
                      });
                    } else if (value.toInt() < 13) {
                      setState(() {
                        division = 500;
                      });
                    } else if (value.toInt() < 15 && value.toInt() > 13) {
                      setState(() {
                        division = 1000;
                      });
                    } else if (value.toInt() >= 15 && value.toInt() < 29) {
                      setState(() {
                        division = 200;
                      });
                    } else if (value.toInt() > 29 && value.toInt() < 79) {
                      setState(() {
                        division = 100;
                      });
                    } else if (value.toInt() > 79 && value.toInt() < 119) {
                      setState(() {
                        division = 50;
                      });
                    } else if (value.toInt() > 119 && value.toInt() < 199) {
                      setState(() {
                        division = 20;
                      });
                    } else if (value.toInt() > 199 && value.toInt() < 299) {
                      setState(() {
                        division = 10;
                      });
                    } else if (value.toInt() > 299 && value.toInt() < 499) {
                      setState(() {
                        division = 5;
                      });
                    } else if (value.toInt() > 499 && value.toInt() < 999) {
                      setState(() {
                        division = 2;
                      });
                    }

                    String maxVal =
                        ((value.toInt() * 1400) / days).toStringAsFixed(0);
                    String newMax = "";
                    for (int i = 0; i < maxVal.length; i++) {
                      if ((i) % 3 == 0 && i != 0) {
                        newMax += ",";
                      }
                      newMax += maxVal[maxVal.length - i - 1];
                    }
                    String minVal =
                        ((_value.toInt() / 0.05) / days).toStringAsFixed(0);
                    String newMin = "";
                    for (int i = 0; i < minVal.length; i++) {
                      if ((i) % 3 == 0 && i != 0) {
                        newMin += ",";
                      }
                      newMin += minVal[minVal.length - i - 1];
                    }
                    setState(() {
                      minReach = newMin.split('').reversed.join();
                      maxReach = newMax.split('').reversed.join();
                      _value = value.toInt();
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 1.0.h),
                child: Text(
                  AppLocalizations.of(
                    "Estimated people reached",
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                child: Text(
                  minReach +
                      " " +
                      AppLocalizations.of(
                        "views per day",
                      ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14),
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
                  child: Stack(
                    children: [
                      Container(
                        color: primaryBlueColor.withOpacity(0.2),
                        height: 5,
                      ),
                      Container(
                        color: primaryBlueColor,
                        height: 5,
                        width: 10.0.w,
                      ),
                    ],
                  )),
              SizedBox(
                height: 1.0.h,
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 2.0.w,
                ),
                child: Text(
                  AppLocalizations.of(
                    "Apply Coupon",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 1.0.h, right: 2.0.w),
                child: Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextFormField(
                      onTap: () {
                        setState(() {});
                      },
                      maxLines: 1,
                      controller: _couponController,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryBlueColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        hintText: AppLocalizations.of(
                          "Enter your coupon code",
                        ),
                        // 48 -> icon width
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.0.h,
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 2.0.w,
                ),
                child: Text(
                  AppLocalizations.of(
                    "Payment",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                child: Text(
                  AppLocalizations.of(
                    "Payment Method",
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, top: 1.0.h),
                child: Text(
                  AppLocalizations.of(
                        "Available balance",
                      ) +
                      " (\$${walletBalance.toString()} USD)",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 15),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 3.0.h, horizontal: 4.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /*RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0), side: BorderSide(color: Colors.grey)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 3.0.w,
                    ),*/

                    isLoading
                        ? Row(
                            children: [
                              CupertinoActivityIndicator(),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  AppLocalizations.of(
                                    "Processing",
                                  ),
                                  style: TextStyle(fontSize: 15),
                                ),
                              )
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (videoUrl == "" || videoUrl == null) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                        AppLocalizations.of(
                                            'Please upload a video')));
                              } else if (selectedButton == null ||
                                  selectedButton == "") {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                        AppLocalizations.of(
                                            'Please add a button')));
                              } else if (_buttonLinkController.text.isEmpty) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                        AppLocalizations.of(
                                            'Please add a link for the button')));
                              } else if (audienceList.audiences.isEmpty) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                        AppLocalizations.of(
                                            'Please create an audience')));
                              } else if (selectedAudienceId == "" ||
                                  selectedAudienceId == null) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(AppLocalizations.of(
                                        'Please select atleast audience from your audiences')));
                              } else if (_daysController.text.isEmpty) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                        AppLocalizations.of(
                                            'Please select a duration')));
                              } else {
                                boostPost();

                                print(paymentUrl);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryBlueColor),
                              // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(0.0),
                              //     side: BorderSide(color: Colors.grey)))
                            ),
                            // color: primaryBlueColor,
                            child: Text(
                              AppLocalizations.of(
                                "Boost",
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
