import 'package:bizbultest/models/country_code_model.dart';
import 'package:bizbultest/services/networking.dart';
import 'package:bizbultest/utilities/values.dart';

class CountryCode {
  // String _url = 'https://www.bebuzee.com/app_devlope.php?';
  Future getCountryCode() async {
    NetworkHelper networkHelper = NetworkHelper(
        // url: '${_url}action=country_code_registration',
        );
    try {
      var response = await networkHelper.getResponseData();
      response.forEach((element) {
        CountryCodeModel countryCodeModel = CountryCodeModel.fromJson(element);
        countryCodeList.add(countryCodeModel);
      });
    } catch (e) {
      print(e);
    }
  }
}
