import 'dart:convert';

import 'package:bizbultest/services/current_user.dart';
import 'package:http/http.dart' as http;

Future<void> playgroundsendFcmRequest(String _title, String _message,
    String type, String otherMemberID, String token, int blocked, int muted,
    {bool isVideo = false}) async {
  print(blocked);
  print(muted.toString() + "muted");
  if (blocked == 0) {
    var headersData = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N'
    };

    var bodyData = {
      "notification": {"title": _title, "body": _message},
      "data": {
        "user_id": CurrentUser().currentUser.memberID,
        "other_user_id": otherMemberID,
        "type": type,
        "body": _message,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "category": "chat"
      },
      "priority": "high",
      "to": token
    };

    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    final res = await http
        .post(url, body: jsonEncode(bodyData), headers: headersData)
        .then((value) {
      print(value.body.toString());
      print("sent from bia");
    });
  } else {
    print("blocked");
  }
}
