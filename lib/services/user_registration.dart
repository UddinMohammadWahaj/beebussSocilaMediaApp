import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/user.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/shared_preferences_helper.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/ApiRepo.dart' as ApiRepo;

class UserRegister {
  /// Api for email check and return username
  static Future<String> checkUserEmail(String email) async {
    // NetworkHelper networkHelper = NetworkHelper(
    //   url: '${_url}action=email_check_registration&email=$email',
    // );

    var sendData = {"email": email};

    try {
      // var response = await networkHelper.getResponseData();
      // if (response['response'] == 'success') {

      var url = 'https://www.bebuzee.com/api/auth/emailCheck';
      var response = await ApiProvider().fireApiWithParamsPost(url,
          formdata: {"email": email}).then((value) => value);

      // var response = await ApiRepo.post("api/email_check.php", sendData);
      if (response.data['status'] == 1) {
        return response.data['short_code'];
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return '';
    }
  }

  /// Api for check username is existing or not
  static Future<bool> checkUserIDExist(String username) async {
    // NetworkHelper networkHelper = NetworkHelper(
    //   url: '${_url}action=check_user_registration&user=$username',
    // );

    var sendData = {"user": username};

    try {
      var url = 'https://www.bebuzee.com/api/auth/usernameCheck';
      var response = await ApiProvider().fireApiWithParams(url,
          params: {"user": username}).then((value) => value);
      // var response = await ApiRepo.post("api/auth/usernameCheck", sendData);
      // var response = await networkHelper.getResponseData();
      if (response.data['status'] == 1) {
        // if (response.data['response'] == 'success') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Api for check phone number is existing or not
  static Future<bool> checkUserPhoneNumberExist(
      String code, String phoneNumber) async {
    // NetworkHelper networkHelper = NetworkHelper(
    //   url:
    //       '${_url}action=phone_check_registration&phone=$phoneNumber&code=$code',
    // );

    var sendData = {"phone": phoneNumber, "code": code};

    try {
      // var response = await networkHelper.getResponseData();
      // if (response['response'] == 'success') {
      var response = await ApiRepo.post("api/auth/mobileCheck", sendData);
      if (response.success == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  ///api for registeringUserFromswitch account
  static Future<String> registerUserToTheServerSwitchAccount(User user) async {
    await Firebase.initializeApp();
    var Tokn = await FirebaseMessaging.instance.getToken();
    var sendData = {
      "email": user.email,
      "fullName": user.fullName,
      "code": user.code,
      "phone": user.phone,
      "username": user.username,
      "password": user.password,
      "month_select": user.dobMonth,
      "day_select": user.dobDay,
      "year_select": user.dobYear,
      "gender_name": user.gender,
      "source": "${isIOS ? 'ios' : 'android'}",
      "member_type": user.memberType,
      "firebase_token": Tokn,
      "tradesman_type": user.tradesmanType ?? ""
    };
    print("send data=${sendData}");

    // NetworkHelper networkHelper = NetworkHelper(
    //   url:
    //       '${_url}action=signup&email=${user.email}&fullName=${user.fullName}&code=${user.code}&phone=${user.phone}&username=${user.username}&password=${user.password}&month_select=${user.dobMonth}&day_select=${user.dobDay}&year_select=${user.dobYear}&gender_name=${user.gender}&source=${isIOS ? 'ios' : 'android'}',
    // );
    try {
      // var response = await networkHelper.getResponseData();
      var responseData = "https://agora.propebuz.com";

      var response = await ApiRepo.post(
        "api/auth/register",
        sendData,
      );
      print("login resonse=${response.data} senddata=$sendData");
      if (response.success == 1) {
        if (response.data != null && response.data['user_id'] != null) {
          user.memberID = response.data['user_id'];
          // print(CurrentUser().currentUser.memberID + " is member");
          SharedPreferences pref = await SharedPreferences.getInstance();
          // await pref.setString(
          //     "newmemberID", CurrentUser().currentUser.memberID);
          // await pref.setString("newtoken", response.data["token"]);
          return '${user.memberID},${response.data["token"]}';
        } else {
          return '';
        }
      } else {
        return response.message!;
      }
      // if (response['response'] == 'success') {
      //   print(response);
      //  // CurrentUser().currentUser.image = response['user_image'];
      //   CurrentUser().currentUser.memberID = response['userid'];
      //   print(CurrentUser().currentUser.memberID + " is member");
      //   //CurrentUser().currentUser.shortcode = response['']
      //   return '';
      // } else {
      //   return response['response'];
      // }
    } catch (e) {
      print(e);
      return 'Error: please try again after sometime';
    }
  }

  /// Api for registering user to the server
  static Future<String> registerUserToTheServer(User user) async {
    var Tokn = await FirebaseMessaging.instance.getToken();
    var sendData = {
      "email": user.email,
      "name": user.fullName,
      "country_code": user.code,
      "mobile": user.phone,
      "username": user.username,
      "password": user.password,
      "birth_month": user.dobMonth,
      "birth_day": user.dobDay,
      "birth_year": user.dobYear,
      "gender": user.gender,
      "account_type":"user"
      // "source": "${isIOS ? 'ios' : 'android'}",
      // "member_type": user.memberType,
      // "firebase_token": Tokn,
      // "tradesman_type": CurrentUser().currentUser.tradesmanType ?? ""
    };

    // NetworkHelper networkHelper = NetworkHelper(
    //   url:
    //       '${_url}action=signup&email=${user.email}&fullName=${user.fullName}&code=${user.code}&phone=${user.phone}&username=${user.username}&password=${user.password}&month_select=${user.dobMonth}&day_select=${user.dobDay}&year_select=${user.dobYear}&gender_name=${user.gender}&source=${isIOS ? 'ios' : 'android'}',
    // );
    try {
      // var response = await networkHelper.getResponseData
      print('register sesnd data=${sendData}');

      var url = 'https://www.bebuzee.com/api/auth/register';

      var response = await ApiProvider()
          .fireApiWithParams(url, params: sendData)
          .then((value) => value);

      // var response = await ApiRepo.post(
      //   "api/register.php",
      //   sendData,
      // );

      print("login resonse=${response.data} senddata=$sendData");
      if (response.data['success'] == 1) {
        if (response.data != null && response.data['user_id'] != null) {
          CurrentUser().currentUser.memberID = response.data['user_id'];
          print(CurrentUser().currentUser.memberID! + " is member");
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("memberID", CurrentUser().currentUser.memberID!);
          await pref.setString("token", response.data["token"]);
          return '';
        } else {
          return '';
        }
      } else {
        return response.data;
      }
      // if (response['response'] == 'success') {
      //   print(response);
      //  // CurrentUser().currentUser.image = response['user_image'];
      //   CurrentUser().currentUser.memberID = response['userid'];
      //   print(CurrentUser().currentUser.memberID + " is member");
      //   //CurrentUser().currentUser.shortcode = response['']
      //   return '';
      // } else {
      //   return response['response'];
      // }
    } catch (e) {
      print(e);
      return 'Error: please try again after sometime';
    }
  }
}
