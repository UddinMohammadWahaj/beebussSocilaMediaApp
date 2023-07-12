import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as style;

class RequestAccountInfo extends StatefulWidget {
  const RequestAccountInfo({Key? key}) : super(key: key);

  @override
  _RequestAccountInfoState createState() => _RequestAccountInfoState();
}

class _RequestAccountInfoState extends State<RequestAccountInfo> {
  bool isRequestRepotGeneare = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text(
          'Request account info',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          top: 14,
        ),
        children: [
          CircleAvatar(
            backgroundColor: secondaryColor,
            radius: 60,
            child:
                Icon(Icons.description_outlined, size: 70, color: Colors.white),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a report of your Bebuzee account ',
                  style: style.TextStyle(
                    fontSize: 16.0,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'information and settings, which you can accsess ',
                  style: style.TextStyle(
                    fontSize: 16.0,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'or port to another app. This report does not ',
                  style: style.TextStyle(
                    fontSize: 16.0,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      'include your messages.',
                      style: style.TextStyle(
                        fontSize: 16.0,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        ' Learn more',
                        textAlign: TextAlign.center,
                        style: style.TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16.0,
                          height: 1.1,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: !isRequestRepotGeneare
                ? InkWell(
                    onTap: () {
                      setState(() {
                        isRequestRepotGeneare = true;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: secondaryColor,
                        ),
                        Text(
                          "   " + 'Request report',
                          style: style.TextStyle(
                            fontSize: 16.0,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: secondaryColor,
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Request sent",
                                style: style.TextStyle(
                                  fontSize: 16.0,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "Ready by October 4, 2021",
                                style: style.TextStyle(
                                    fontSize: 16.0,
                                    height: 1.1,
                                    color: Colors.grey),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Your report will be ready in about 3 days. You'll have a few weeks to download your report after it's avilable",
                        style: style.TextStyle(
                          fontSize: 16.0,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Your request will be canceled if you make changes to your account such as changing your number or deleting your account.",
                        style: style.TextStyle(
                          fontSize: 16.0,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
