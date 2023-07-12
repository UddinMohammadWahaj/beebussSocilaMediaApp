import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  Future<String?> getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langName = "";
    var loginUserId = prefs.getString('langName');
    if (loginUserId != '') {
      langName = loginUserId;
      return langName;
    } else {
      return langName;
    }
  }

  void setSelectedLanguage(String langName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('langName', langName);
  }

  Future<String?> getPin2f() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pin = "";
    var pin2f = prefs.getString('2fpin');
    if (pin2f != '') {
      pin = pin2f;
      return pin;
    } else {
      return pin;
    }
  }

  void set2fPin(String pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('2fpin', pin);
  }

  Future<String?> getEmail2f() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = "";
    var email2f = prefs.getString('2femail');
    if (email2f != '') {
      email = email2f;
      return email;
    } else {
      return email;
    }
  }

  void set2fEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('2femail', email);
  }

  Future<String?> getBGImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imageName = "";
    var image = prefs.getString('imageName');
    if (image != '') {
      imageName = image;
      return imageName;
    } else {
      return imageName;
    }
  }

  void setBGImage(String imageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('imageName', imageName);
  }
}
