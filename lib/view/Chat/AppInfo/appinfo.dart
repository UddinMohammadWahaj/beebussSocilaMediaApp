import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppInfoScreen extends StatefulWidget {
  const AppInfoScreen({Key? key}) : super(key: key);

  @override
  _AppInfoScreenState createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {
  PackageInfo? packageInfo;
  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  getAppVersion() async {
    packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo!.appName;
    String packageName = packageInfo!.packageName;
    String version = packageInfo!.version;
    String buildNuember = packageInfo!.buildNumber;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          gradientContainer(null),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Text(
                "Bebuzee Messenger",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Version ${packageInfo!.version}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Image.asset(
                "assets/images/launcher_main.png",
                height: 100,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copyright, size: 10, color: Colors.white),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "2012-2021 Bebuzee Inc.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
