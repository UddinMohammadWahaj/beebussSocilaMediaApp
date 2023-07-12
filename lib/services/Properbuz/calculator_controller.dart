import 'dart:math' as math;
import 'package:bizbultest/utilities/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CalculatorController extends GetxController {
  double sliderValue = 50.0;
  double pigSize = 50.0;
  double homeSize = 50.0;
  GlobalKey scheduleChartHeightKey = new GlobalKey();
  double scheduleChartHeight = 0.0;

  void changeSliderValue(double index) {
    sliderValue = index;
    if (sliderValue <= 50) {
      var a = 50 - sliderValue;
      pigSize = 50 + (a * 2);
    } else {
      var a = 50 - (100 - sliderValue);
      homeSize = 50 + (a * 2);
    }
    update();
  }

  var mortgageIndex = 0.obs;
  void changeMortgageIndex(int index) {
    mortgageIndex.value = index;
    update();
  }

  TextEditingController annual_income_TextController =
      TextEditingController(text: "300000");
  TextEditingController dp_TextController =
      TextEditingController(text: "60000");
  TextEditingController down_payment_percent_TextController =
      TextEditingController(text: "20");
  TextEditingController months_pay_TextController =
      TextEditingController(text: "180");
  TextEditingController ir_TextController =
      TextEditingController(text: "4.435");
  TextEditingController property_tax_TextController =
      TextEditingController(text: "0.77");
  TextEditingController propertytax_percent_val_TextController =
      TextEditingController(text: "2310");
  TextEditingController hi_TextController = TextEditingController(text: "1260");
  TextEditingController hoa_TextController = TextEditingController(text: "0");
  List<PieChartSectionData> pieChartData = [];
  var ipmi = false;
  var iti = false;
  var months_pay = 360;
  void changeIPMI(bool? val) {
    ipmi = val!;
    new_cal_c(isChangeFrom: "ipmi");
  }

  void changeITI(bool? val) {
    iti = val!;
    new_cal_c(isChangeFrom: "iti");
  }

  var newInterest_arr = [];
  var newreduction_arr = [];
  var newPrincipal_arr = [];

  var scheduleChartData = '';
  var irPrChartData = '';
  var totalInterest = 0;
  var irPrTablearr = [];

  void new_cal_c({isChangeFrom = "home_price"}) async {
    // var annual_income = 300000; //Home Price
    // var dp = 60000.0; //Down payment
    // var numMo = 15 * 12; //Loan Program in month
    // var ir = 6; //Interest rate
    // var property_tax = 1000;
    // var months_pay = 180;
    // var propertytax_percent_val = 0.33;
    // var hi = 1260; //Home insurance
    // var hoa = 0; //HOA dues //HOMEOWNERS ASSOCIATION
    var annual_income =
        double.tryParse(annual_income_TextController.text) ?? 0.0; //Home Price
    num? dp = double.tryParse(dp_TextController.text) ?? 0.0; //Down payment
    //Loan Program in month
    var ir = double.tryParse(ir_TextController.text) ?? 0.0; //Interest rate
    var property_tax = double.tryParse(property_tax_TextController.text) ?? 0.0;

    var propertytax_percent_val =
        double.tryParse(propertytax_percent_val_TextController.text) ?? 0.0;
    var hi = double.tryParse(hi_TextController.text) ?? 0.0; //Home insurance
    var hoa = double.tryParse(hoa_TextController.text) ??
        0.0; //HOA dues //HOMEOWNERS ASSOCIATION

    // var isChangeFrom = "home_price";

    if (isChangeFrom == "home_price") {
      down_payment_percent_TextController.text = "20";

      var percent_for_dp = annual_income * 0.2;

      dp_TextController.text = percent_for_dp.toString();

      dp = percent_for_dp;
    } else if (isChangeFrom == 'dp') {
      down_payment_percent_TextController.text =
          ((dp * 100) / annual_income).round().toString();
    } else if (isChangeFrom == 'down_payment_percent') {
      dp = num.tryParse(
          down_payment_percent_TextController.text.replaceAll(r'\Dg', ''));
      100 * annual_income;
      dp_TextController.text = dp.toString();
    } else if (isChangeFrom == 'property_tax') {
      propertytax_percent_val_TextController.text =
          (annual_income * (property_tax / 100)).toString();
    } else if (isChangeFrom == 'propertytax_percent') {
      property_tax_TextController.text =
          (((propertytax_percent_val * 100) / annual_income)
              .toStringAsFixed(2));
    }

    var N = months_pay;
    var annual_income_dp = annual_income - dp!;
    var R = ir / 1200;

    var emi = (annual_income_dp *
            (R * math.pow((1 + R), N)) /
            (math.pow((1 + R), N) - 1))
        .round();
    var pmi = 0.0;

    var dpr = ((dp / annual_income) * 100).floor();

    if (dpr < 20) {
      if (ipmi) {
        var ipmi_arr = [
          "0.294",
          "0.2916",
          "0.2904",
          "0.2856",
          "0.282",
          "0.2172",
          "0.2148",
          "0.2124",
          "0.21",
          "0.2076",
          "0.1596",
          "0.1572",
          "0.156",
          "0.1536",
          "0.1524",
          "0.1128",
          "0.1104",
          "0.1092",
          "0.108",
          "0.1068"
        ];
        pmi = double.parse(ipmi_arr[dpr]);
      }
    }

    var final_pmi =
        ((((annual_income / 100) * pmi) / months_pay) * 100).round();
    property_tax = (num.parse(propertytax_percent_val_TextController.text == ''
                ? "0"
                : propertytax_percent_val_TextController.text) /
            12)
        .round()
        .toDouble();
    var home_insurence = (hi / 12).round();

    var home_include = 'yes';
    if (!iti) {
      property_tax = 0;
      home_insurence = 0;
      home_include = 'no';
    }
    if (!ipmi) {
      final_pmi = 0;
    }

    var total_val =
        (emi + property_tax + hoa + home_insurence + final_pmi).round();
    var fn_emi = ((emi * 100) / total_val).round();
    var fn_tax = ((property_tax * 100) / total_val).round();
    var fn_hoa = ((hoa * 100) / total_val).round();
    var fn_home_ins = ((home_insurence * 100) / total_val).round();
    var fn_pmi = ((final_pmi * 100) / total_val).round();

    var data_val = [];
    pieChartData.clear();
    if (fn_emi != 0) {
      var jsondata = {
        "name": "P&I \$$emi ($fn_emi%)",
        "y": fn_emi,
        "color": "$pIColor"
      };
      data_val.add(jsondata);
    }
    if (fn_tax != 0) {
      var jsondata = {
        "name": "Taxes \$$property_tax ($fn_tax%)",
        "y": fn_tax,
        "color": '$taxesColor'
      };
      data_val.add(jsondata);
    }

    if (fn_hoa != 0) {
      var jsondata = {
        "name": "HOA \$$hoa ($fn_hoa%)",
        "y": fn_hoa,
        "color": '$hoaColor'
      };
      data_val.add(jsondata);
    }

    if (fn_home_ins != 0) {
      var jsondata = {
        "name": "Insurance \$$home_insurence ($fn_home_ins%)",
        "y": fn_home_ins,
        "color": '$insuranceColor'
      };
      data_val.add(jsondata);
    }

    if (fn_pmi != 0) {
      var jsondata = {
        "name": "PMI \$$final_pmi ($fn_pmi%)",
        "y": fn_pmi,
        "color": '$pmiColor'
      };
      data_val.add(jsondata);
    }
    pieChartData.addAll(
      data_val.map(
        (e) => PieChartSectionData(
          color: HexColor(e['color']),
          value: double.parse(e['y'].toString()),
          title: e['name'],
          titlePositionPercentageOffset: 8,
          radius: 10,
          titleStyle: TextStyle(
            fontSize: 14,
            // fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade400,
            shadows: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 3,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );

    var loanamt = annual_income_dp;
    var paymnt = months_pay;
    var rate = ir;
    var pro_tx_year =
        ((propertytax_percent_val * 100) / annual_income).toStringAsFixed(2);

    show_new(loanamt, paymnt, rate);
  }

  void show_new(amt, num, rat) {
    var amount = double.parse(amt.toString());
    var numpay = int.parse(num.toString());
    var rate = double.parse(rat.toString());

    rate = rate / 100;

    var monthly = rate / 12;
    var payment = ((amount * monthly) / (1 - math.pow((1 + monthly), -numpay)));
    var total = payment * numpay;
    var interest = total - amount;

    var fn_ttl_interst = fixVal(interest, 0, 2, ' ');
    var fn_ttl_pay = fixVal(payment, 0, 2, ' ');
    var fn_mnthly_instalment = fixVal(total, 0, 2, ' ');
    var fn_num_yrs = numpay / 12;

    var newPrincipal = amount;
    var newInterest_arr = [];
    var newreduction_arr = [];
    var newPrincipal_arr = [];
    var category = [];

    var i = 1;

    while (i <= numpay) {
      var newInterest = monthly * newPrincipal;
      var reduction = payment - newInterest;
      newPrincipal = newPrincipal - reduction;

      var fn_payment = fixVal(payment, 0, 2, ' ');
      var fn_newInterest = fixVal(newInterest, 0, 2, ' ');
      var fn_reduction = fixVal(reduction, 0, 2, ' ');
      var fn_newPrincipal = fixVal(newPrincipal, 0, 2, ' ');

      var last_int;
      if (newInterest_arr.isNotEmpty) last_int = newInterest_arr.last;
      var last_reduct;
      if (newreduction_arr.isNotEmpty) last_reduct = newreduction_arr.last;

      if (last_int != null) {
        newInterest_arr.add(fn_newInterest + last_int);
      } else {
        newInterest_arr.add(fn_newInterest);
      }

      if (last_reduct != null) {
        newreduction_arr.add(fn_reduction + last_reduct);
      } else {
        newreduction_arr.add(fn_reduction);
      }

      newPrincipal_arr.add(fn_newPrincipal);
      category.add(i);
      i++;
    }
    print(newPrincipal_arr.join(", "));
    print(newInterest_arr.join(", "));
    print(newreduction_arr.join(", "));
    scheduleChartData = '''{

    xAxis: {labels: {   formatter: function () {return this.value+" mo";}} },
      
    legend: {
        layout: 'vertical',
        align: 'right',
        verticalAlign: 'middle'
    },
    
 title: {
          text: ''
        },
    

    series: [{
        name: 'Remaining',
        data: [''' +
        newPrincipal_arr.join(", ") +
        ''']
    }, {
        name: 'Interest',
        data: [''' +
        newInterest_arr.join(", ") +
        ''']
    }, {
        name: 'Principal',
        data: [''' +
        newreduction_arr.join(", ") +
        ''']
    }, ],

    responsive: {
        rules: [{
            condition: {
                maxWidth: 500
            },
            chartOptions: {
                legend: {
                    layout: 'horizontal',
                    align: 'center',
                    verticalAlign: 'bottom'
                }
            }
        }]
    }

}''';

    var P = amt;
    var r = rat / 12 / 100;
    var n = num;
    var E = (P * r * ((math.pow((1 + r), n)) / ((math.pow((1 + r), n)) - 1)))
        .round();
    print(E);
    var P2 = P;
    List<int> irList = [];
    List<int> prList = [];
    totalInterest = 0;
    irPrTablearr.clear();
    for (var i = 1; i <= n; i++) {
      var ir = (P2 * r).round();
      var pr = (E - ir).round();
      var bal = (P2 - pr);
      P2 = bal;
      totalInterest += int.parse(ir);
      irList.add(ir.round());
      prList.add(pr.round());
      irPrTablearr
          .add({"i": i, "E": E, "ir": ir, "pr": pr, "bal": bal.round()});
    }
    irPrChartData = '''{
    chart: {
        type: 'area'
    },
    title: {
        text: 'Principal vs. interest'
    },
    
    accessibility: {
        point: {
            valueDescriptionFormat: '{index}. {point.category}, {point.y:,.0f} millions, {point.percentage:.1f}%.'
        }
    },
    xAxis: {
        
        tickmarkPlacement: 'on',
        title: {
            enabled: false
        }
    },
    yAxis: {
        labels: {
            format: '{value}%'
        },
        title: {
            enabled: false
        }
    },
    tooltip: {
        pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.0f} millions)<br/>',
        split: true
    },
    plotOptions: {
        area: {
            stacking: 'percent',
            lineColor: '#ffffff',
            lineWidth: 1,
            marker: {
                lineWidth: 1,
                lineColor: '#ffffff'
            }
        }
    },
    series: [{
        name: 'Principal',
        data: [''' +
        irList.join(', ') +
        ''']
    }, {
        name: 'interest',
        data: [''' +
        prList.join(', ') +
        ''']
    }]
}''';

    update();
  }

  int fixVal(value, numberOfCharacters, numberOfDecimals, padCharacter) {
    var i, stringObject, stringLength, numberToPad; // define local variables
    value = value *
        math.pow(10,
            numberOfDecimals); // shift decimal point numberOfDecimals places
    value = (value).round(); //  to the right and round to nearest integer
    stringObject = value.toString(); // convert numeric value to a String object
    stringLength = stringObject.length; // get length of string

    while (stringLength < numberOfDecimals) {
      // pad with leading zeroes if necessary
      stringObject = "0" + stringObject; // add a leading zero
      stringLength = stringLength + 1; //  and increment stringLength variable
    }

    if (numberOfDecimals > 0) {
      // now insert a decimal point
      stringObject = stringObject.substring(
              0, stringLength - numberOfDecimals) +
          "." +
          stringObject.substring(stringLength - numberOfDecimals, stringLength);
    }
    if (stringObject.length < numberOfCharacters && numberOfCharacters > 0) {
      numberToPad = numberOfCharacters -
          stringObject.length; // number of leading characters to pad
      for (i = 0; i < numberToPad; i = i + 1) {
        stringObject = padCharacter + stringObject;
      }
    }
    return double.parse(stringObject).round(); // return the string object
  }
}
