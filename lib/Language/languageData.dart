class AllTextData {
  List<AllText>? allText;

  AllTextData({this.allText});

  AllTextData.fromJson(Map<String, dynamic> json) {
    if (json['allText'] != null) {
      // ignore: deprecated_member_use
      allText = <AllText>[];
      json['allText'].forEach((v) {
        allText!.add(new AllText.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allText != null) {
      data['allText'] = this.allText!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllText {
  String textId = '';
  String it = '';
  String pt = '';
  String en = '';
  String es = '';
  String fr = '';
  String de = '';
  String af = '';
  String ar = '';
  String bg = '';
  String cs = '';
  String da = '';
  String el = '';
  String nl = '';
  String no = '';
  String pl = '';
  String ro = '';
  String sk = '';
  String fi = '';
  String sv = '';
  String vi = '';
  String tr = '';
  String ru = '';
  String uk = '';
  String sr = '';
  String he = '';
  String hi = '';
  String th = '';
  String zh = '';
  String ja = '';
  String ko = '';

  String id = '';
  String ms = '';
  String fil = '';
  String hr = '';
  String hu = '';
  String fa = '';

  AllText({
    this.textId = '',
    this.it = '',
    this.en = "",
    this.pt = '',
    this.es = '',
    this.fr = '',
    this.de = "",
    this.af = "",
    this.ar = "",
    this.bg = "",
    this.cs = "",
    this.da = "",
    this.el = "",
    this.nl = "",
    this.no = "",
    this.pl = "",
    this.ro = "",
    this.sk = "",
    this.fi = "",
    this.sv = "",
    this.vi = "",
    this.tr = "",
    this.ru = "",
    this.uk = "",
    this.sr = "",
    this.he = "",
    this.hi = "",
    this.th = "",
    this.zh = "",
    this.ja = "",
    this.ko = "",
    this.id = "",
    this.ms = "",
    this.fil = "",
    this.hr = "",
    this.hu = "",
    this.fa = "",
  });

  AllText.fromJson(Map<String, dynamic> json) {
    textId = json['textId'] ?? '';
    if (json['languageTextList'] != null) {
      json['languageTextList'].forEach((text) {
        if (text["id"] != null) {
          id = text["id"] ?? textId;
        }
        if (text["ms"] != null) {
          ms = text["ms"] ?? textId;
        }
        if (text["fil"] != null) {
          fil = text["fil"] ?? textId;
        }
        if (text["hr"] != null) {
          hr = text["hr"] ?? textId;
        }
        if (text["hu"] != null) {
          hu = text["hu"] ?? textId;
        }
        if (text["fa"] != null) {
          fa = text["fa"] ?? textId;
        }

        if (text["it"] != null) {
          it = text["it"] ?? textId;
        }
        if (text["pt"] != null) {
          pt = text["pt"] ?? textId;
        }
        if (text["en"] != null) {
          en = text["en"] ?? textId;
        }
        if (text["es"] != null) {
          es = text["es"] ?? textId;
        }
        if (text["fr"] != null) {
          fr = text["fr"] ?? textId;
        }
        if (text["de"] != null) {
          de = text["de"] ?? textId;
        }
        if (text["af"] != null) {
          af = text["af"] ?? textId;
        }
        if (text["ar"] != null) {
          ar = text["ar"] ?? textId;
        }
        if (text["bg"] != null) {
          bg = text["bg"] ?? textId;
        }
        if (text["cs"] != null) {
          cs = text["cs"] ?? textId;
        }
        if (text["da"] != null) {
          da = text["da"] ?? textId;
        }
        if (text["el"] != null) {
          el = text["el"] ?? textId;
        }
        if (text["nl"] != null) {
          nl = text["nl"] ?? textId;
        }
        if (text["no"] != null) {
          no = text["no"] ?? textId;
        }
        if (text["pl"] != null) {
          pl = text["pl"] ?? textId;
        }
        if (text["ro"] != null) {
          ro = text["ro"] ?? textId;
        }
        if (text["sk"] != null) {
          sk = text["sk"] ?? textId;
        }
        if (text["fi"] != null) {
          fi = text["fi"] ?? textId;
        }
        if (text["sv"] != null) {
          sv = text["sv"] ?? textId;
        }
        if (text["vi"] != null) {
          vi = text["vi"] ?? textId;
        }
        if (text["tr"] != null) {
          tr = text["tr"] ?? textId;
        }
        if (text["ru"] != null) {
          ru = text["ru"] ?? textId;
        }
        if (text["uk"] != null) {
          uk = text["uk"] ?? textId;
        }
        if (text["sr"] != null) {
          sr = text["sr"] ?? textId;
        }
        if (text["he"] != null) {
          he = text["he"] ?? textId;
        }
        if (text["hi"] != null) {
          hi = text["hi"] ?? textId;
        }
        if (text["th"] != null) {
          th = text["th"] ?? textId;
        }
        if (text["zh"] != null) {
          zh = text["zh"] ?? textId;
        }
        if (text["ja"] != null) {
          ja = text["ja"] ?? textId;
        }
        if (text["ko"] != null) {
          ko = text["ko"] ?? textId;
        }
      });

      if (id == '') {
        id = textId;
      }
      if (ms == '') {
        ms = textId;
      }
      if (fil == '') {
        fil = textId;
      }
      if (hr == '') {
        hr = textId;
      }
      if (hu == '') {
        hu = textId;
      }
      if (fa == '') {
        fa = textId;
      }

      if (it == '') {
        it = textId;
      }
      if (pt == '') {
        pt = textId;
      }
      if (fr == '') {
        fr = textId;
      }
      if (es == '') {
        es = textId;
      }
      if (de == '') {
        de = textId;
      }
      if (en == '') {
        en = textId;
      }

      if (af == '') {
        af = textId;
      }
      if (ar == '') {
        ar = textId;
      }
      if (bg == '') {
        bg = textId;
      }
      if (cs == '') {
        cs = textId;
      }
      if (da == '') {
        da = textId;
      }
      if (el == '') {
        el = textId;
      }
      if (nl == '') {
        nl = textId;
      }
      if (no == '') {
        no = textId;
      }
      if (pl == '') {
        pl = textId;
      }
      if (ro == '') {
        ro = textId;
      }
      if (sk == '') {
        sk = textId;
      }
      if (fi == '') {
        fi = textId;
      }
      if (sv == '') {
        sv = textId;
      }
      if (vi == '') {
        vi = textId;
      }
      if (tr == '') {
        tr = textId;
      }
      if (ru == '') {
        ru = textId;
      }
      if (uk == '') {
        uk = textId;
      }
      if (sr == '') {
        sr = textId;
      }
      if (he == '') {
        he = textId;
      }
      if (hi == '') {
        hi = textId;
      }
      if (th == '') {
        th = textId;
      }
      if (zh == '') {
        zh = textId;
      }
      if (ja == '') {
        ja = textId;
      }
      if (ko == '') {
        ko = textId;
      }
    } else {
      id = textId;
      ms = textId;
      fil = textId;
      hr = textId;
      hu = textId;
      fa = textId;

      fr = textId;
      en = textId;
      it = textId;
      pt = textId;
      es = textId;
      de = textId;
      af = textId;
      ar = textId;
      bg = textId;
      cs = textId;
      da = textId;
      el = textId;
      nl = textId;
      no = textId;
      pl = textId;
      ro = textId;
      sk = textId;
      fi = textId;
      sv = textId;
      vi = textId;
      tr = textId;
      ru = textId;
      uk = textId;
      sr = textId;
      he = textId;
      hi = textId;
      th = textId;
      zh = textId;
      ja = textId;
      ko = textId;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['textId'] = this.textId;
    data['id'] = this.id;
    data['fil'] = this.fil;
    data['hr'] = this.hr;
    data['hu'] = this.hu;
    data['ms'] = this.ms;
    data['fa'] = this.fa;

    data['fr'] = this.fr;
    data['en'] = this.en;
    data['it'] = this.it;
    data['pt'] = this.pt;
    data['es'] = this.es;
    data['de'] = this.de;
    data['af'] = this.af;
    data['ar'] = this.ar;
    data['bg'] = this.bg;
    data['cs'] = this.cs;
    data['da'] = this.da;
    data['el'] = this.el;
    data['nl'] = this.nl;
    data['no'] = this.no;
    data['pl'] = this.pl;
    data['ro'] = this.ro;
    data['sk'] = this.sk;
    data['fi'] = this.fi;
    data['sv'] = this.sv;
    data['vi'] = this.vi;
    data['tr'] = this.tr;
    data['ru'] = this.ru;
    data['uk'] = this.uk;
    data['sr'] = this.sr;
    data['he'] = this.he;
    data['hi'] = this.hi;
    data['th'] = this.th;
    data['zh'] = this.zh;
    data['ja'] = this.ja;
    data['ko'] = this.ko;

    return data;
  }
}
