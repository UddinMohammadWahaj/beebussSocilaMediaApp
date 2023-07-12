import 'package:bizbultest/services/Properbuz/report_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Language/appLocalization.dart';
import 'common_header.dart';

class ReportItemSheet extends GetView<ReportController> {
  final String? uniqueID;
  final String? type;
  const ReportItemSheet({Key? key, this.uniqueID, this.type}) : super(key: key);

  Widget _customReportRow(String title, int val) {
    return ListTile(
      onTap: () {
        controller.reportCode.value = val;
        controller.onTapReport(type!, uniqueID!);
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        AppLocalizations.of(title),
        style: TextStyle(color: Colors.grey.shade700),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey.shade700,
        size: 22,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ReportController(), permanent: true);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReportCommonHeader(title: AppLocalizations.of("Report")),
          _customReportRow(
              AppLocalizations.of("I think it's inappropriate for Properbuz"),
              1),
          _customReportRow(
              AppLocalizations.of(
                  "I think it's spam, a scam or a fake account"),
              2),
          _customReportRow(
              AppLocalizations.of("I think this account may have been hacked"),
              3),
          _customReportRow(
              AppLocalizations.of("I think it's something else"), 4),
        ],
      ),
    );
  }
}
