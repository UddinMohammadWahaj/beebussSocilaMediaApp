import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/view/Chat/ChangePhone/change_number_from.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({Key? key}) : super(key: key);

  @override
  _ChangePhoneNumberState createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text(
          'Change number',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Flexible(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter your old phone number with coutry code:',
                            style: TextStyle(
                              fontSize: 16.0,
                              height: 1.1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 5, 25),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: firstCountryCtrl,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3)
                                    ],
                                    decoration: InputDecoration(
                                      prefixIconConstraints:
                                          BoxConstraints(minWidth: 0),
                                      prefixIcon: Icon(
                                        Icons.add,
                                        size: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    controller: firstPhoneCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(17)
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'phone number',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Enter your new phone number with coutry code:',
                            style: TextStyle(
                              fontSize: 16.0,
                              height: 1.1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 5, 25),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: secondCountryCtrl,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3)
                                    ],
                                    decoration: InputDecoration(
                                      prefixIconConstraints:
                                          BoxConstraints(minWidth: 0),
                                      prefixIcon: Icon(
                                        Icons.add,
                                        size: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    controller: secondPhoneCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(17)
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'phone number',
                                    ),
                                  ),
                                ),
                              ],
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
                  if (checkValidation()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNumberFrom(
                          fromPhone:
                              "+" + firstCountryCtrl.text + firstPhoneCtrl.text,
                          toPhone: "+" +
                              secondCountryCtrl.text +
                              secondPhoneCtrl.text,
                          countryCode: secondCountryCtrl.text,
                          onlyToPhoneNumber: secondPhoneCtrl.text,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController firstPhoneCtrl = new TextEditingController();
  TextEditingController secondPhoneCtrl = new TextEditingController();
  TextEditingController firstCountryCtrl = new TextEditingController();
  TextEditingController secondCountryCtrl = new TextEditingController();

  bool checkValidation() {
    if (firstPhoneCtrl.text == "" || firstPhoneCtrl.text == null) {
      Fluttertoast.showToast(msg: "Please enter your phone number.");
      return false;
    } else if (secondPhoneCtrl.text == "" || secondPhoneCtrl.text == null) {
      Fluttertoast.showToast(msg: "Please enter your phone number.");
      return false;
    }
    return true;
  }
}
