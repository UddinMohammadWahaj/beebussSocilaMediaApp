import 'package:bizbultest/services/Properbuz/report_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Language/appLocalization.dart';
import 'common_header.dart';

class SubReportItemSheet extends GetView<ReportController> {
  final String uniqueID;
  final String type;
  final int reportType;
  const SubReportItemSheet(
      {Key? key,
      required this.uniqueID,
      required this.type,
      required this.reportType})
      : super(key: key);

  Widget _customReportRow(String title, String subtitle, int val) {
    return ListTile(
      onTap: () {
        controller.subReportCode.value = val;
        controller.openSubmitSheet(
            AppLocalizations.of("Are you sure about this?"), type, uniqueID);
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Text(
        AppLocalizations.of(title),
        style: TextStyle(color: Colors.grey.shade700),
      ),
      subtitle: Text(
        AppLocalizations.of(subtitle),
        style: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ReportController());
    return Container(
        child: reportType == 1
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReportCommonHeader(
                      title: AppLocalizations.of("Tell us a little more")),
                  _customReportRow(
                      AppLocalizations.of(
                          "I think it's a scam, phishing or malware"),
                      AppLocalizations.of(
                          "Ex: someone asks for personal information or money or posts suspicious links"),
                      1),
                  _customReportRow(
                      AppLocalizations.of("I think it's promotional or spam"),
                      AppLocalizations.of(
                          "Ex: someone creates a phony profile or impersonates another person"),
                      2),
                  _customReportRow(
                      AppLocalizations.of("I think it's a fake account"),
                      AppLocalizations.of(
                          "Ex: someone creates a phony profile or impersonates another person"),
                      3)
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReportCommonHeader(
                      title: AppLocalizations.of("Tell us a little more")),
                  _customReportRow(
                      AppLocalizations.of(
                          "I think the topic or language is offensive"),
                      AppLocalizations.of(
                          "Ex: includes profanity targeted towards individuals"),
                      1),
                  _customReportRow(
                      AppLocalizations.of(
                          "I think it's pornographic or extremely violent"),
                      AppLocalizations.of(
                          "Ex: someone displays sexual or gruesome images"),
                      2),
                  _customReportRow(
                      AppLocalizations.of(
                          "I think it's harassment or a threat"),
                      AppLocalizations.of(
                          "Ex: includes unwelcome advances or hostile language"),
                      3),
                  _customReportRow(
                      AppLocalizations.of("I think it's hate speech"),
                      AppLocalizations.of(
                          "Ex: includes racist, homophobic or sexist slurs, or inciting violence"),
                      4),
                  _customReportRow(
                      AppLocalizations.of(
                          "I'm concerned this person may be suicidal"),
                      AppLocalizations.of(
                          "Ex: someone threatens to harm themselves"),
                      5),
                  _customReportRow(
                      AppLocalizations.of("It infringes on my rights"),
                      AppLocalizations.of(
                          "Ex: includes defamation, trademark or copyright violation"),
                      6)
                ],
              ));
  }
}
