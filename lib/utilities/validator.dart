bool validateEmail(String value) {
  Pattern? pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = new RegExp(pattern.toString());
  if (!regex.hasMatch(value) || value == null)
    return false;
  else
    return true;
}

bool validateName(String value) {
  if (value.length < 3)
    return false;
  else
    return true;
}

bool validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

bool validatePassword(String value) {
  if (value.length <= 6) {
    return true;
  } else {
    return false;
  }
}
