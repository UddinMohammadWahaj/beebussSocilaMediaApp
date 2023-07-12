import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Widget loadingIndicator() {
  return Container(
      height: 55,
      child: Center(
          child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.grey.shade400))));
}

CustomHeader customHeader() {
  return CustomHeader(
    builder: (context, mode) {
      return Container(
        child: Center(child: loadingIndicator()),
      );
    },
  );
}

CustomFooter customFooter() {
  return CustomFooter(
    builder: (BuildContext context, LoadStatus? mode) {
      Widget body;

      if (mode == LoadStatus.idle) {
        body = Text("");
      } else if (mode == LoadStatus.loading) {
        body = loadingIndicator();
      } else if (mode == LoadStatus.failed) {
        body = Text("");
      } else if (mode == LoadStatus.canLoading) {
        body = Text("");
      } else {
        body = Text("");
      }
      return Center(child: body);
    },
  );
}
