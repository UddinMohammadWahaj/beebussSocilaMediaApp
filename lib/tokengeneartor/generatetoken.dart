import 'package:bizbultest/playground/utils/settings.dart';
import 'package:dio/dio.dart';

class GenerateToken {
  final String? memberId;
  final String? channelName;

  GenerateToken({this.memberId, this.channelName});
  Future<Map<String, dynamic>> responseAgora() async {
    Map<String, dynamic> resp = await Dio()
        .get(
            'http://www.bebuzee.com/agora/agoraRtcToken.php?user_id=${this.memberId}&appID=${APP_ID}&appCertificate=${APP_CERTIFICATE}&channelName=${this.channelName}&role=RolePublisher')
        .then((value) => value.data);
    print('bichit $resp');
    return resp;
  }
}
