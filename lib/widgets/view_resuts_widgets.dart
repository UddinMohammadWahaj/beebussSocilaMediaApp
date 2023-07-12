import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LinkClicks extends StatefulWidget {
  final String title;
  final String value;

  const LinkClicks({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  _LinkClicksState createState() => _LinkClicksState();
}

class _LinkClicksState extends State<LinkClicks> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      height: 20.0.h,
      width: 45.0.w,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.value,
              style: blackBold.copyWith(fontSize: 40),
            )
          ],
        ),
      ),
    );
  }
}

class Reach extends StatefulWidget {
  final String reachTitle;
  final String reachValue;
  final String clickTitle;
  final String clickValue;

  Reach(
      {Key? key,
      required this.reachTitle,
      required this.reachValue,
      required this.clickTitle,
      required this.clickValue})
      : super(key: key);

  @override
  _ReachState createState() => _ReachState();
}

class _ReachState extends State<Reach> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      height: 20.0.h,
      width: 45.0.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.reachTitle,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  widget.reachValue,
                  style: blackBold.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.clickTitle,
                  style: TextStyle(fontSize: 16),
                ),
                Text(widget.clickValue,
                    style: blackBold.copyWith(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Details extends StatefulWidget {
  final String title;
  final String value;
  final bool divider;

  Details(
      {Key? key,
      required this.title,
      required this.value,
      required this.divider})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title, style: blackBoldShaded),
              Text(
                widget.value,
                style: TextStyle(
                    color: widget.title == "Status"
                        ? Colors.green.shade700
                        : Colors.black),
              ),
            ],
          ),
          widget.divider == true
              ? Divider(
                  thickness: 1,
                )
              : Container()
        ],
      ),
    );
  }
}
