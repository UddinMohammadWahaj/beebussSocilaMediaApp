import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Properbuz/report/sub_report_item_sheet.dart';
import 'package:bizbultest/widgets/Properbuz/utils/custom_bottom_sheets.dart';
import 'package:bizbultest/widgets/Properbuz/utils/properbuz_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../api/ApiRepo.dart' as ApiRepo;
import '../../Language/appLocalization.dart';

class ReportController extends GetxController {
  var reportCode = 0.obs;
  var subReportCode = 0.obs;

  Future<void> reportItem(
      String uniqueID, String type, int reportCode, int subReportCode) async {
//      var url = Uri.parse("https://www.bebuzee.com/webservices/properbuzz_dont_see.php?user_id=${CurrentUser().currentUser
//          .memberID}&unique_id=$uniqueID&type=$type&report_code=$reportCode&sub_report_code=$subReportCode");
//   print(url);
//  var response = await http.get(url);
    var response = await ApiRepo.postWithToken("api/properbuzz_dont_see.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "unique_id": uniqueID,
      "type": type,
      "report_code": reportCode,
      "sub_report_code": subReportCode
    });

    if (response!.success == 1) {
      print(response!.data);
    } else {
      print("error");
    }
  }

  void openSubmitSheet(
    String title,
    String type,
    String uniqueID,
  ) {
    Get.back();
    Get.bottomSheet(
        CustomYesNoSheet(
          header: AppLocalizations.of("Confirm your report"),
          title: title,
          yesButton: AppLocalizations.of("Submit"),
          noButton: AppLocalizations.of("Cancel"),
          onNo: () => Get.back(),
          onYes: () {
            Get.back();
            Get.showSnackbar(properbuzSnackBar(
                AppLocalizations.of("Report captured successfully")));
            reportItem(uniqueID, type, reportCode.value, subReportCode.value);
          },
        ),
        backgroundColor: Colors.white);
  }

  void openSubReportSheet(String type, String uniqueID, int reportType) {
    Get.back();
    Get.bottomSheet(
        SubReportItemSheet(
          type: type,
          uniqueID: uniqueID,
          reportType: reportType,
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true);
  }

  void onTapReport(
    String type,
    String uniqueID,
  ) {
    switch (reportCode.value) {
      case 1:
        return openSubmitSheet(
            "You're reporting that this is inappropriate for Properbuz.",
            type,
            uniqueID);
        break;
      case 2:
        return openSubReportSheet(type, uniqueID, 1);
        break;
      case 3:
        return openSubmitSheet(
            "You're reporting that this account may have been hacked.",
            type,
            uniqueID);
        break;
      case 4:
        return openSubReportSheet(type, uniqueID, 2);
        break;
    }
  }
}
