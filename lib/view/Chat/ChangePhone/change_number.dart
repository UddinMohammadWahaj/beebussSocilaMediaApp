import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'change_phone_number.dart';

class ChangeNumberPage extends StatefulWidget {
  const ChangeNumberPage({Key? key}) : super(key: key);

  @override
  _ChangeNumberPageState createState() => _ChangeNumberPageState();
}

class _ChangeNumberPageState extends State<ChangeNumberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text('Change number'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0, bottom: 28.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/changenumber.png',
                        height: 100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Text(
                          'Changing your phone number will migrate your account info, groups & settings.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Before proceeding, please confirm that you are able to receive SMS or calls at your bew number.',
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'If you have both a new phone & a new number, first change your number on your old phone.',
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondaryColor)),
              child: Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePhoneNumber()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
