import 'package:bizbultest/services/Properbuz/comments_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Properbuz/report/report_item_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsMenuSheet extends GetView<CommentsController> {
  final int index;
  final int? feedIndex;
  final int? val;
  const CommentsMenuSheet( {Key? key, required this.index,this.feedIndex, this.val}) : super(key: key);

  Widget _customTile (String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      leading: Icon(icon,color: Colors.grey.shade700,),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CommentsController());
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CurrentUser().currentUser.memberID == controller.commentsList[index].memberId ?
          _customTile("Edit comment", Icons.edit, () => controller.editComment(index,context)) : Container(),
          CurrentUser().currentUser.memberID == controller.commentsList[index].memberId ?
          _customTile("Delete comment", CupertinoIcons.delete_solid, () => controller.deleteComment(index,feedIndex!,val!)) : Container(),
          CurrentUser().currentUser.memberID == controller.commentsList[index].memberId ? Container () :
          _customTile("Report comment", Icons.report_rounded, () {
            Get.back();
            Get.bottomSheet(ReportItemSheet(type: "comment",uniqueID: controller.commentsList[index].commentID,), backgroundColor: Colors.white);
          }),
        ],
      ),
    );
  }
}
