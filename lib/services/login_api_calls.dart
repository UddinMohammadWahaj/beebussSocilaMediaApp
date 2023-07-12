import 'dart:convert';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/utilities/values.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/ApiRepo.dart' as ApiRepo;
import 'country_name.dart';

class LoginApiCalls {
  static final String _baseUrl = "https://www.bebuzee.com/app_devlope.php";

  static Future<String> getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("country", locationX["country"]);
    return locationX["country"];
  }

  static Future<String> getCountryLogo(String countryName) async {
    String logo = "";
    var sendData = {"country": countryName};
    var response = await ApiRepo.post("api/country/logoList", sendData);


    if (response.status == 1) {
      logo = response.data["image_url"];

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("logo", logo);
    }
    return logo;
  }

  static Future<String> checkEmail(String email) async {
    String emailMatchRes = "";

    // var url = Uri.parse("$_baseUrl?action=email_check_exist&email=$email");

    // var response = await http.get(url);

    var sendData = {"email": email};
    var response = await ApiRepo.post("api/auth/emailCheck", sendData);

    emailMatchRes = response!.success == 1 ? 'success' : '';

    // if (response!.statusCode == 200 && response!.body != null && response!.body != "") {
    //   print(response!.body);
    //   emailMatchRes = jsonDecode(response!.body)['response'];
    // }

    return emailMatchRes;
  }

  static Future<String> checkPassword(String email, String password) async {
    String passRes = "";

    // var url = Uri.parse("$_baseUrl?action=password_check&email=$email&password=$password");

    // var response = await http.get(url);

    // if (response!.statusCode == 200 && response!.body != null && response!.body != "") {
    //   passRes = jsonDecode(response!.body)['response'];
    // }

    var sendData = {"email": email, "password": password};
    var url = 'https://www.bebuzee.com/api/auth/passwordCheck';
    var response = await ApiProvider().fireApiWithParamsPost(url, params: {
      "email": email,
      "password": password,
    });
    // var response = await ApiRepo.post("api/password_check.php", sendData);

    passRes = response!.data['status'] == 1 ? 'success' : '';

    return passRes;
  }

  static Future<List<String>> getCurrentMember(String memberID) async {
    String name = "";
    String shortcode = "";
    String image = "";
    String email = "";
    String memberType = "";
    var countrycode;
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("after members token=${pref.getString('token')}");

    print('called current');
    var sendData = {"user_id": memberID};

// var response=await

    var response =
        await ApiRepo.newpostWithToken("api/user/userDetails", sendData);
    if (response!.data['status'] == 1) {
      print(response.data);
      var res = response.data['data'];
      name = res['name'];
      shortcode = res['shortcode'];
      image = res['image'];
      email = res['email'];
      countrycode = res['country_code'];
      memberType = res['type'] == 'merchant'
          ? '2'
          : res['type'] == 'user'
              ? '0'
              : res['type'] == 'real_estate_agent'
                  ? '1'
                  : '3';

      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("image", image);
        pref.setString("shortcode", shortcode);
        pref.setString("name", name);
        pref.setString("email", email);
        pref.setString("member_type", memberType);
      } catch (e) {}
    }
    return [name, shortcode, image, memberType, countrycode.toString()];
  }

  static Future<List<String>> checkLogin(String email, String password) async {
    String loginRes = "";
    String memberID = "";
    var Tokn = '';

    var url = 'https://www.bebuzee.com/api/auth/login';
    var response = await ApiProvider().fireApiWithParamsPost(url,
        from: 'login',
        params: {
          "email": email,
          "password": password,
          "firebase_token": Tokn
        }).then((value) => value);
    print("response login=${response.data}");
    if (response.data['status'] == 1) {
      loginRes = "success";

      memberID = response.data["user"]['id'].toString();
      print("user_id=${memberID}");
      // SharedPreferences.setMockInitialValues({});
      SharedPreferences sp = await SharedPreferences.getInstance();

      try {
        await sp.setString("memberID", memberID.toString());
        await sp.setString('email', email);
        await sp.setString('password', password);
        await sp.setString("token", response.data["access_token"]);

        print("Shared pref set contains=${sp.containsKey('memberID')} ${sp.getString('token')}");
      } catch (e) {
        print('Shared pref set fail$e');
      }

      print('acceess token=${response.data["access_token"]}');
    } else {
      loginRes = response.data;

      return [loginRes];
    }
    print("check login ${[loginRes, memberID]}");
    return [loginRes, memberID];
    // if (response!.statusCode == 200 && response!.body != null && response!.body != "") {
    //   if (jsonDecode(response!.body)['status'] == "1") {
    //     loginRes = jsonDecode(response!.body)['response'];
    //     memberID = jsonDecode(response!.body)['user_id'];
    //     SharedPreferences pref = await SharedPreferences.getInstance();
    //     pref.setString("memberID", memberID);
    //   } else {
    //     loginRes = jsonDecode(response!.body)['response'];
    //     return [loginRes];
    //   }
    // }
    // return [loginRes, memberID];
  }

  static Future<void> insertCountry(String memberID, String countryName) async {
    var url =
        "https://www.bebuzee.com/api/user/userCountryInsert?action=insert_member_country&user_id=$memberID&country_name=$countryName";
    var response = await ApiProvider().fireApi(url);
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data != "") {
      print("country inserted api called  ${response.data}");
      print(response.data);
    }
  }
}
