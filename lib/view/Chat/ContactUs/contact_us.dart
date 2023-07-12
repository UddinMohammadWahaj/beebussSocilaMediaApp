import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/TwoFactorEnableModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUS extends StatefulWidget {
  const ContactUS({Key? key}) : super(key: key);

  @override
  _ContactUSState createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {
  late File image1;
  late File image2;
  late File image3;

  TextEditingController problemCtrl = new TextEditingController();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text(
          'Contact us',
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            fabBgColor,
          ),
        ),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      child: TextFormField(
                        controller: problemCtrl,
                        cursorHeight: 23,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          hintText: 'Describe your problem',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 50.0, horizontal: 10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 23, 0, 18),
                      child: Text("Add screenshorts (optional)"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            getMedia(true, 1);
                          },
                          child: image1 != null && image1.path != null
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.file(image1).image,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 20,
                                      child: Icon(
                                        Icons.add,
                                        color: fabBgColor,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            getMedia(true, 2);
                          },
                          child: image2 != null && image2.path != null
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.file(image2).image,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 20,
                                      child: Icon(
                                        Icons.add,
                                        color: fabBgColor,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            getMedia(true, 3);
                          },
                          child: image3 != null && image3.path != null
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.file(image3).image,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 20,
                                      child: Icon(
                                        Icons.add,
                                        color: fabBgColor,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _launchURL("https://www.bebuzee.com/contact-us");
                    },
                    child: Text(
                      'Visit our Help Center',
                      style: TextStyle(
                        color: fabBgColor,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(fabBgColor)),
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      sendData();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  TwoFactorEnableModel objTwoFactorEnableModel = new TwoFactorEnableModel();

  sendData() async {
    if (checkValidation()) {
      try {
        setState(() {
          isloading = true;
        });
        String uid = CurrentUser().currentUser.memberID!;
        objTwoFactorEnableModel = await ApiProvider().contactUs(
          uid,
          problemCtrl.text,
          image1: image1 != null && image1.path != null && image1.path != ""
              ? image1.path
              : "",
          image2: image2 != null && image2.path != null && image2.path != ""
              ? image2.path
              : "",
          image3: image3 != null && image3.path != null && image3.path != ""
              ? image3.path
              : "",
        );
        if (objTwoFactorEnableModel != null &&
            objTwoFactorEnableModel.success != null) {
          Fluttertoast.showToast(msg: "Your Problem save");
          Navigator.pop(context);
        }
      } catch (e) {
        print(e);
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  bool checkValidation() {
    if (problemCtrl.text == "" || problemCtrl.text == null) {
      Fluttertoast.showToast(msg: "Please enter Problem");
      return false;
    }
    return true;
  }

  Future getMedia(bool isgallery, int imageNumber) async {
    PickedFile? selectedFile;

    if (isgallery) {
      try {
        selectedFile = await ImagePicker().getImage(
          source: ImageSource.gallery,
        );
        setState(() {
          if (imageNumber == 1) {
            image1 = File(selectedFile!.path);
          }
          if (imageNumber == 2) {
            image2 = File(selectedFile!.path);
          }
          if (imageNumber == 3) {
            image3 = File(selectedFile!.path);
          }
        });
      } catch (e) {
        print(e);
      }
    } else {
      try {
        selectedFile = await ImagePicker().getImage(
          source: ImageSource.camera,
        );
        setState(() {
          if (imageNumber == 1) {
            image1 = File(selectedFile!.path);
          }
          if (imageNumber == 2) {
            image2 = File(selectedFile!.path);
          }
          if (imageNumber == 3) {
            image3 = File(selectedFile!.path);
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }
}
