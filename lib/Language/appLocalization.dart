import 'package:bizbultest/constance/constance.dart' as constance;

class AppLocalizations {
  static String of(String text, {String ignoreLanguageCode: 'en'}) {
    String myLocale = constance.locale;

    if (constance.allTextData != null &&
        constance.allTextData!.allText!.length > 0) {
      var newText = '';
      int index = constance.allTextData!.allText!
          .indexWhere((note) => note.textId == text);
      if (index != -1) {
        if (myLocale == 'fr') {
          newText = constance.allTextData!.allText![index].fr;
        } else if (myLocale == 'de') {
          newText = constance.allTextData!.allText![index].de;
        } else if (myLocale == 'en') {
          newText = constance.allTextData!.allText![index].en;
        } else if (myLocale == 'es') {
          newText = constance.allTextData!.allText![index].es;
        } else if (myLocale == 'it') {
          newText = constance.allTextData!.allText![index].it;
        } else if (myLocale == 'pt') {
          newText = constance.allTextData!.allText![index].pt;
        } else if (myLocale == 'af') {
          newText = constance.allTextData!.allText![index].af;
        } else if (myLocale == 'ar') {
          newText = constance.allTextData!.allText![index].ar;
        } else if (myLocale == 'bg') {
          newText = constance.allTextData!.allText![index].bg;
        } else if (myLocale == 'cs') {
          newText = constance.allTextData!.allText![index].cs;
        } else if (myLocale == 'da') {
          newText = constance.allTextData!.allText![index].da;
        } else if (myLocale == 'el') {
          newText = constance.allTextData!.allText![index].el;
        } else if (myLocale == 'nl') {
          newText = constance.allTextData!.allText![index].nl;
        } else if (myLocale == 'no') {
          newText = constance.allTextData!.allText![index].no;
        } else if (myLocale == 'pl') {
          newText = constance.allTextData!.allText![index].pl;
        } else if (myLocale == 'ro') {
          newText = constance.allTextData!.allText![index].ro;
        } else if (myLocale == 'sk') {
          newText = constance.allTextData!.allText![index].sk;
        } else if (myLocale == 'fi') {
          newText = constance.allTextData!.allText![index].fi;
        } else if (myLocale == 'sv') {
          newText = constance.allTextData!.allText![index].sv;
        } else if (myLocale == 'vi') {
          newText = constance.allTextData!.allText![index].vi;
        } else if (myLocale == 'tr') {
          newText = constance.allTextData!.allText![index].tr;
        } else if (myLocale == 'ru') {
          newText = constance.allTextData!.allText![index].ru;
        } else if (myLocale == 'uk') {
          newText = constance.allTextData!.allText![index].uk;
        } else if (myLocale == 'sr') {
          newText = constance.allTextData!.allText![index].sr;
        } else if (myLocale == 'he') {
          newText = constance.allTextData!.allText![index].he;
        } else if (myLocale == 'hi') {
          newText = constance.allTextData!.allText![index].hi;
        } else if (myLocale == 'th') {
          newText = constance.allTextData!.allText![index].th;
        } else if (myLocale == 'zh') {
          newText = constance.allTextData!.allText![index].zh;
        } else if (myLocale == 'ja') {
          newText = constance.allTextData!.allText![index].ja;
        } else if (myLocale == 'ko') {
          newText = constance.allTextData!.allText![index].ko;
        } else if (myLocale == 'id') {
          newText = constance.allTextData!.allText![index].id;
        } else if (myLocale == 'fil') {
          newText = constance.allTextData!.allText![index].fil;
        } else if (myLocale == 'hr') {
          newText = constance.allTextData!.allText![index].hr;
        } else if (myLocale == 'hu') {
          newText = constance.allTextData!.allText![index].hu;
        } else if (myLocale == 'ms') {
          newText = constance.allTextData!.allText![index].ms;
        } else if (myLocale == 'fa') {
          newText = constance.allTextData!.allText![index].fa;
        }
        if (newText != '') {
          return newText;
        } else {
          return text;
        }
      } else {
        return text;
      }
    } else {
      return text;
    }
  }
}
