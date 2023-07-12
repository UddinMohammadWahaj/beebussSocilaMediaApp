import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IncreaseDurationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 2.0.h),
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
    );
  }
}

class EndDateCard extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback? onTap;

  const EndDateCard({Key? key, this.selectedDate, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
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
            onTap: onTap ?? () {},
            child: Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: new Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 0.5.w),
                  child: Row(
                    children: [
                      Text(
                        selectedDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0]
                                .split("-")[2] +
                            "-" +
                            selectedDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0]
                                .split("-")[1] +
                            "-" +
                            selectedDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0]
                                .split("-")[0],
                        style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
