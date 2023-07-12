import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/tokengeneartor/generatetoken.dart';

class TestApiAgora extends StatefulWidget {
  const TestApiAgora({Key? key}) : super(key: key);

  @override
  _TestApiAgoraState createState() => _TestApiAgoraState();
}

class _TestApiAgoraState extends State<TestApiAgora> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text("call api"),
          onPressed: () async {
            GenerateToken token = new GenerateToken(memberId: '1796768');
            //www.bebuzee.com/agoraRtcToken.php?user_id=1796768&appID=&appCertificate=&channelName=7d72365eb983485397e3e3f9d460bdda
            await token.responseAgora();
          },
        ),
      ),
    );
  }
}
