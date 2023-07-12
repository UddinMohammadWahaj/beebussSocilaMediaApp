import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AudiencePopup extends StatefulWidget {
  @override
  _AudiencePopupState createState() => _AudiencePopupState();
}

class _AudiencePopupState extends State<AudiencePopup> {
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.0.h),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(
                    "Edit Audience",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(
                          "Make sure that you save your edits once you've finished.",
                        ),
                        style: greyNormal,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Text(
                          AppLocalizations.of(
                            'Name',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 14),
                        ),
                      ),
                      Container(
                        height: 5.0.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.0.h),
                          child: Container(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: TextFormField(
                                onTap: () {
                                  setState(() {});
                                },
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                style: Theme.of(context).textTheme.bodyText1,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: primaryBlueColor, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    hintText: AppLocalizations.of(
                                      'Name',
                                    ),
                                    contentPadding: EdgeInsets.only(left: 1.0.h)

                                    // 48 -> icon width
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Text(
                          AppLocalizations.of(
                            'Gender',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 14),
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        side: BorderSide(color: Colors.grey))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(0.0),
                            //     side: BorderSide(color: Colors.grey)),
                            onPressed: () {},
                            // color: Colors.white,
                            child: Text(
                              AppLocalizations.of(
                                "All",
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        side: BorderSide(color: Colors.grey))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(
                                "Men",
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        side: BorderSide(color: Colors.grey))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(0.0),
                            //     side: BorderSide(color: Colors.grey)),
                            onPressed: () {},
                            // color: Colors.white,
                            child: Text(
                              AppLocalizations.of(
                                "Women",
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Text(
                          AppLocalizations.of(
                            'Age',
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
