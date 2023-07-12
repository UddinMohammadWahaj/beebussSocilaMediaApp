import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:get/get.dart' as gett;

import 'dart:async';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:bizbultest/models/address_search_model.dart';
import 'package:bizbultest/models/audience_model.dart';
import 'dart:io' as i;
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../api/api.dart';
import 'audience_card.dart';
import 'banner_ad_payment_webview.dart';
import 'banner_upload_card.dart';
import 'ad_cards.dart';
import 'new_audience.dart';
import '../../../api/ApiRepo.dart' as ApiRepo;

class CreateBannerAd extends StatefulWidget {
  final GlobalKey<ScaffoldState>? sKey;

  CreateBannerAd({Key? key, this.sKey}) : super(key: key);

  @override
  _CreateBannerAdState createState() => _CreateBannerAdState();
}

class _CreateBannerAdState extends State<CreateBannerAd> {
  int? value;
  List buttonList = [];
  var buttonString;
  var selectedButton;
  int _value = 6;
  int days = 4;
  bool showLocationList = false;

  bool isLoading = false;
  TextEditingController _buttonLinkController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _couponController = TextEditingController();

  String minReach = "75";
  late String maxReach;
  String walletBalance = '';
  bool dataLoaded = false;
  bool showProfileButton = false;

  var urlDomain;
  var urlTitle;
  var urlDescription;
  late String paymentUrl;

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
    var response = await ApiRepo.postWithToken("api/get_all_audience_user.php",
        {"user_id": CurrentUser().currentUser.memberID!});

    if (response!.data['success'] == 1) {
      print("audience=${response!.data}");
      Audiences audienceData = Audiences.fromJson(response.data['data']);
      setState(() {
        audienceList = audienceData;
        hasAudience = true;
      });
      // return audienceData.audiences;
    }
  }

  Future<void> boostPost() async {
    setState(() {
      isLoading = true;
    });

    var url = "https://www.bebuzee.com/api/save_boosted_data_banner_ad.php";

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
      "image1": image1,
      "image2": image2,
      "image3": image3,
      "image4": image4,
      "image5": image5,
    });
    print("banner ad ${response.data}");
    // print("banner ad upload response= " + response.data);

    if (response.statusCode == 200) {
      print("payment method=${response.data['payment_method']}");
      if (response.data['payment_method'] == 'wallet') {
        Navigator.of(context).pop();
        gett.Get.showSnackbar(gett.GetSnackBar(
          title: 'Success Payment',
          message: 'Successful payment',
          duration: Duration(seconds: 1),
          // titleText: Text('Success Payment!'),
          icon: Icon(Icons.money, color: Colors.green),
        ));
        return;
      }
      print("banner ad webview");
      if (mounted) {
        setState(() {
          paymentUrl = response.data['url_data_paypal'];
          totalBudget = response.data['total_budget'].toString();
          adBudget = response.data['ad_budget'].toString();
          dataID = response.data['data_id'].toString();
          isLoading = false;
          print("banner ad webview done");
        });
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BannerAdWebView(
                  url: paymentUrl,
                  from: "banner",
                  heading: "Payment",
                  memberID: CurrentUser().currentUser.memberID!,
                  adBudget: adBudget,
                  totalBudget: totalBudget,
                  dataID: dataID,
                  postID: postID)));
    }
  }

  late i.File _image1;
  late i.File _image2;
  late i.File _image3;
  late i.File _image4;
  late i.File _image5;

  bool isVideoPicked = false;
  bool imagePicked = false;
  bool isVideoUploaded = false;
  int uploadProgress1 = 0;
  int uploadProgress2 = 0;
  int uploadProgress3 = 0;
  int uploadProgress4 = 0;
  int uploadProgress5 = 0;

  bool correctDimension1 = true;
  bool correctDimension2 = true;
  bool correctDimension3 = true;
  bool correctDimension4 = true;
  bool correctDimension5 = true;

  Future<void> checkImage(
      String action, bool check, i.File file, int h, int w, int index) async {
    // final imageBytes = i.File(file.path).readAsBytesSync();
    // final newImage = img.decodeImage(imageBytes);
    // final height = newImage.height;
    // final width = newImage.width;
    // if (h != height && w != width) {
    //   print(" not correct");
    //   if (mounted) {
    //     setState(() {
    //       if (index == 1) {
    //         setState(() {
    //           correctDimension1 = false;
    //         });
    //         print(correctDimension1.toString() + " oneeee");
    //       } else if (index == 2) {
    //         correctDimension2 = false;
    //       } else if (index == 3) {
    //         correctDimension3 = false;
    //       } else if (index == 4) {
    //         correctDimension4 = false;
    //       } else if (index == 5) {
    //         correctDimension5 = false;
    //       } else {
    //         print("hereeeee");
    //       }
    //     });
    //   }
    // } else {
    //   if (mounted) {
    //     setState(() {
    //       if (index == 1) {
    //         correctDimension1 = true;
    //         uploadImage(action, file, index, check);
    //       } else if (index == 2) {
    //         correctDimension2 = true;
    //         uploadImage(action, file, index, check);
    //       } else if (index == 3) {
    //         correctDimension3 = true;
    //         uploadImage(action, file, index, check);
    //       } else if (index == 4) {
    //         correctDimension4 = true;
    //         uploadImage(action, file, index, check);
    //       } else if (index == 5) {
    //         correctDimension5 = true;
    //         uploadImage(action, file, index, check);
    //       } else {
    //         print("hereeeee");
    //       }
    //     });
    //   }
    // }

    if (mounted) {
      setState(() {
        if (index == 1) {
          correctDimension1 = true;
          uploadImage(action, file, index, check);
        } else if (index == 2) {
          correctDimension2 = true;
          uploadImage(action, file, index, check);
        } else if (index == 3) {
          correctDimension3 = true;
          uploadImage(action, file, index, check);
        } else if (index == 4) {
          correctDimension4 = true;
          uploadImage(action, file, index, check);
        } else if (index == 5) {
          correctDimension5 = true;
          uploadImage(action, file, index, check);
        } else {
          print("hereeeee");
        }
      });
    }
  }

  _imageFromGallery(
      String action, i.File file, int index, int h, int w, bool check) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      file = i.File(result.files.single.path!);

      checkImage(action, check, file, h, w, index);
    } else {}
  }

  String videoUrl = "";
  String image1 = "";
  String image2 = "";
  String image3 = "";
  String image4 = "";
  String image5 = "";

  bool initialized = false;
  Future<String?> getToken() async {
    return await ApiProvider()
        .refreshToken(CurrentUser().currentUser.memberID!);
  }

  void uploadImage(String action, i.File file, int index, bool check) async {
    print("upload banner $index called");
    print(check.toString() + " checkkkkk");
    print(correctDimension1);
    var url =
        'https://www.bebuzee.com/api/banner_ad_image_url.php?action=$action&user_id=${CurrentUser().currentUser.memberID!}&file1';
    print("upload banner url=$url");
    var client = Dio();
    var formdata = FormData();

    formdata.files
        .addAll([MapEntry("file1", await MultipartFile.fromFile(file.path))]);
    // var request = mp.MultipartRequest();
    // request.setUrl(
    //     "https://www.bebuzee.com/api/banner_ad_image_url.php?action=$action&user_id=${CurrentUser().currentUser.memberID!}&file1");
    // request.addFile("file1", file.path);
    // mp.Response response = request.send();
    // response.onError = () {
    //   print("Error");
    // };
    print("upload banner $index before");
    var response;
    try {
      response = await client.post(url,
          // options: Options(headers: {
          //   'Content-Type': 'application/json',
          //   'Accept': 'application/json',
          //   'Authorization': 'Bearer $token',
          // }),
          data: formdata, onSendProgress: (sent, total) {
        final progress = sent / total;

        setState(() {
          if (index == 1) {
            uploadProgress1 = (progress * 100).toInt();
            print("upload banner $index on ${uploadProgress1}");
          } else if (index == 2) {
            uploadProgress2 = (progress * 100).toInt();
          } else if (index == 3) {
            uploadProgress3 = (progress * 100).toInt();
          } else if (index == 4) {
            uploadProgress4 = (progress * 100).toInt();
          } else if (index == 5) {
            uploadProgress5 = (progress * 100).toInt();
          } else {
            print("progress out of bond");
          }
        });

        // print("progress from response object image " + p.toString());
      }).then((value) {
        print("upload banner $index after ${value.data}");
        return value;
      });
    } catch (e) {
      print("upload banner error $e");
    }

    print("upload banner image response=${response.data}");

    if (response.data['success'] == 1) {
      if (mounted) {
        setState(() {
          if (index == 1) {
            print("index 1=${response.data['image']}");
            image1 = response.data['image'];
          } else if (index == 2) {
            image2 = response.data['image'];
          } else if (index == 3) {
            image3 = response.data['image'];
          } else if (index == 4) {
            image4 = response.data['image'];
          } else if (index == 5) {
            image5 = response.data['image'];
          } else {
            print("out of bonds");
          }
        });
      }
    }
    // response.onComplete = (response) {
    //   print(response);
    //   if (mounted) {
    //     setState(() {
    //       if (index == 1) {
    //         image1 = jsonDecode(response)['image'];
    //       } else if (index == 2) {
    //         image2 = jsonDecode(response)['image'];
    //       } else if (index == 3) {
    //         image3 = jsonDecode(response)['image'];
    //       } else if (index == 4) {
    //         image4 = jsonDecode(response)['image'];
    //       } else if (index == 5) {
    //         image5 = jsonDecode(response)['image'];
    //       } else {
    //         print("out of bonds");
    //       }
    //     });
    //   }
    // };

    // response.progress.listen((int progress) {
    //   if (mounted) {
    //     setState(() {
    //       if (index == 1) {
    //         uploadProgress1 = progress;
    //       } else if (index == 2) {
    //         uploadProgress2 = progress;
    //       } else if (index == 3) {
    //         uploadProgress3 = progress;
    //       } else if (index == 4) {
    //         uploadProgress4 = progress;
    //       } else if (index == 5) {
    //         uploadProgress5 = progress;
    //       } else {
    //         print("progress out of bond");
    //       }
    //     });
    //   }
    //   print("progress from response object " + progress.toString());
    // });
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
    String? token = await getToken();
    // var response = await ApiRepo.postWithToken('api/wallet_balance_data.php', {
    //   "user_id": CurrentUser().currentUser.memberID!
    // }).then((value) => value);
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

    if (response.data['success'] == 1) {
      print('wallet balnce=${response.data}');
      setState(() {
        walletBalance = response.data['balance'];
      });
    }
  }

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
    print("banner initState called");
    setState(() {
      _daysController.text = days.toString();
    });
    try {
      getButton();

      getWalletBalance();
      getAudienceData();
    } catch (e) {
      print("initstate error $e");
    }
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
              UploadBannerCard(
                errorText: AppLocalizations.of(
                  "Please select banner with proper dimensions(Width 300px and Height 600px)",
                ),
                correctDimension: correctDimension1,
                uploadProgress: uploadProgress1,
                onTap: () {
                  print("clicked banner");
                  _imageFromGallery(
                      "upload_image1", _image1, 1, 600, 300, correctDimension1);
                },
                text: AppLocalizations.of(
                  "Select Image for HALF PAGE 300X600",
                ),
                image: image1,
              ),
              UploadBannerCard(
                errorText: AppLocalizations.of(
                  "Please select banner with proper dimensions(Width 970px and Height 250px)",
                ),
                correctDimension: correctDimension2,
                uploadProgress: uploadProgress2,
                onTap: () {
                  _imageFromGallery(
                      "upload_image2", _image2, 2, 970, 250, correctDimension2);
                },
                text: AppLocalizations.of(
                  "Select Image for BILLBOARD 970 x 250",
                ),
                image: image2,
              ),
              UploadBannerCard(
                errorText: AppLocalizations.of(
                  "Please select banner with proper dimensions(Width 321px and Height 481px)",
                ),
                correctDimension: correctDimension3,
                uploadProgress: uploadProgress3,
                onTap: () {
                  _imageFromGallery(
                      "upload_image2", _image3, 3, 481, 321, correctDimension3);
                },
                text: AppLocalizations.of(
                  "Select Image for DIGITAL FULL PAGE MOBILE 321 x 481",
                ),
                image: image3,
              ),
              UploadBannerCard(
                errorText:
                    "Please select banner with proper dimensions(Width 980px and Height 600px)",
                correctDimension: correctDimension4,
                uploadProgress: uploadProgress4,
                onTap: () {
                  _imageFromGallery(
                      "upload_image4", _image4, 4, 600, 980, correctDimension4);
                },
                text: AppLocalizations.of(
                  "Select Image for MEGA PARADE 980 x 600",
                ),
                image: image4,
              ),
              UploadBannerCard(
                errorText:
                    "Please select banner with proper dimensions(Width 693px and Height 600px)",
                correctDimension: correctDimension5,
                uploadProgress: uploadProgress5,
                onTap: () {
                  _imageFromGallery(
                      "upload_image5", _image5, 5, 600, 693, correctDimension5);
                },
                text: AppLocalizations.of(
                  "Select Image for MEGA FULL PAGE MOBILE 693 x 600",
                ),
                image: image5,
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
                                                showProfileButton == true
                                                    ? "bebuzee.com"
                                                    : urlDomain,
                                                style: blackBoldShaded,
                                              ),
                                              Container(
                                                width: 58.0.w,
                                                child: Text(
                                                  showProfileButton == true
                                                      ? CurrentUser()
                                                          .currentUser
                                                          .fullName
                                                      : urlTitle,
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
                            return AudienceCard(
                              audience: audienceList.audiences[index],
                              value: value,
                              index: index,
                              onTap: () {
                                Timer(Duration(seconds: 2), () {
                                  getAudienceData();
                                });
                              },
                              onChanged: (ind) {
                                setState(() {
                                  value = ind;
                                  selectedAudienceId =
                                      audienceList.audiences[index].audienceId!;
                                  print(selectedAudienceId);
                                });
                              },
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
                            Timer(Duration(seconds: 2), () {
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
              IncreaseDurationCard(),
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
                              onTap: () {},
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
                                        ((_value.toInt() * 50) / days)
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
                    EndDateCard(
                      selectedDate: selectedDate,
                      onTap: () {
                        _selectDate(context);
                      },
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
                        ((_value.toInt() * 50) / days).toStringAsFixed(0);
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
                        "Available balancel",
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
                              if (image1 == "" &&
                                  image2 == "" &&
                                  image3 == "" &&
                                  image4 == "" &&
                                  image5 == "") {
                                print(image1);
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                  AppLocalizations.of(
                                      'Please upload atleast one photo'),
                                ));
                              } else if (selectedButton == null ||
                                  selectedButton == "") {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                  AppLocalizations.of('Please add a button'),
                                ));
                              } else if (_buttonLinkController.text.isEmpty) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                  AppLocalizations.of(
                                      'Please add a link for the button'),
                                ));
                              } else if (audienceList.audiences.isEmpty) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                  AppLocalizations.of(
                                      'Please create an audience'),
                                ));
                              } else if (selectedAudienceId == "" ||
                                  selectedAudienceId == null) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                  AppLocalizations.of(
                                      'Please select atleast audience from your audiences'),
                                ));
                              } else if (_daysController.text.isEmpty) {
                                ScaffoldMessenger.of(
                                        widget.sKey!.currentState!.context)
                                    .showSnackBar(showSnackBar(
                                  AppLocalizations.of(
                                      'Please select a duration'),
                                ));
                              } else {
                                boostPost();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryBlueColor),
                            ),
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
