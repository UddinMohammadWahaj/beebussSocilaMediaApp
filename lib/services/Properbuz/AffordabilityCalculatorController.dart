import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utilities/colors.dart';

class AffordabilityCalculatorController extends GetxController {
  var mortgageIndex = 0.obs;
  void changeMortgageIndex(int index) {
    mortgageIndex.value = index;
    update();
  }

  AffordabilityCalculatorController() {
    calc_amt();
  }

  double sliderValue = 36.0;
  double pigSize = 50.0;
  double homeSize = 50.0;
  void changeSliderValue(double index) {
    sliderValue = index;
    var hitrval_disp = ((sliderValue - 0) / (43 - 0));
    var bitrval_disp = (1 - hitrval_disp);
    if (hitrval_disp < 0.2) {
      hitrval_disp = 0.2;
    }
    if (bitrval_disp < 0.2) {
      bitrval_disp = 0.2;
    }
    pigSize = (150 * bitrval_disp);
    homeSize = (150 * hitrval_disp);
    // if (sliderValue <= 21) {
    //   var a = 50 - sliderValue;
    //   pigSize = 50 + (a * 2);
    // } else {
    //   var a = 50 - (100 - sliderValue);
    //   homeSize = 50 + (a * 2);
    // }
    update();
  }

  void changeIti(bool? val) {
    iti = val!;
    calc_amt();
  }

  void changeIpmi(bool? val) {
    ipmi = val!;
    calc_amt();
  }

  TextEditingController annual_income_TextController =
      TextEditingController(text: "70000");

  TextEditingController md_TextController = TextEditingController(text: "250");
  TextEditingController max_emi_TextController =
      TextEditingController(text: "0");

  TextEditingController dp_TextController =
      TextEditingController(text: "20000");

  TextEditingController dti_TextController = TextEditingController(text: "36");

  TextEditingController ir_TextController =
      TextEditingController(text: "4.217");

  TextEditingController lt_TextController = TextEditingController(text: "360");

  bool iti = true;

  TextEditingController pt_TextController = TextEditingController(text: "1.2");

  TextEditingController hi_TextController = TextEditingController(text: "800");

  bool ipmi = true;

  TextEditingController hoa_TextController = TextEditingController(text: "0");

  var myValueLink = 0.0;
  var max_emi = 0.0;
  num house_cost = 0.0;
  List<PieChartSectionData> pieChartData = [];
  List<PieChartSectionData> pieChartDataMonth = [];
  List<PieChartSectionData> pieChartDataBreakDown = [];
  num mortgageInsurance = 0.0;
  num emi = 0.0;
  var monthly_income;
  num propertyTax = 0.0;

  var scheduleChartData = '';
  var irPrChartData = '';
  var totalInterest = 0;
  var irPrTablearr = [];

  void calc_amt() {
    num final_cost = 100000000.0;

    var pmi = 0.0;
    var annual_income =
        double.tryParse(annual_income_TextController.text) ?? 0.0;
    monthly_income = (annual_income / 12).round();
    var md = double.tryParse(md_TextController.text) ?? 0.0;
    var dti = double.tryParse(dti_TextController.text) ?? 0.0;
    emi = ((monthly_income / 100) * dti).round() - md;
    var dti_cal = dti;
    while (emi < 0) {
      dti_cal++;
      emi = ((monthly_income / 100) * dti_cal).round() - md;
    }
    myValueLink = emi.toDouble();
    max_emi = emi.toDouble();
    max_emi_TextController.text = emi.toString();
    var ir = double.tryParse(ir_TextController.text) ?? 0.0;
    var irm = (ir / 1200).toStringAsFixed(3);
    var lt = double.tryParse(lt_TextController.text) ?? 0.0;
    var pt = double.tryParse(pt_TextController.text) ?? 0.0;
    var ptr = (pt / 100);
    var hi = double.tryParse(hi_TextController.text) ?? 0.0;
    var him = (hi / 12);
    var hoa = double.tryParse(hoa_TextController.text) ?? 0.0;

    var dp = double.tryParse(dp_TextController.text) ?? 0.0;

    if (!iti) {
      pt = 0;
      ptr = 0;
      hi = 0;
      him = 0;
      hoa = 0;
      pmi = 0.0;
    }
    var monthlyPayment = emi;
    var downPayment = dp;
    var loanTerm = lt;
    var interestRate = ((ir / 100) / 12);
    var propertyTaxes = (pt / 100);
    var hoaDues = hoa;
    var homeownersInsurance = (him).round();
    var mortgageInsurances = pmi;

    //Determine home price
    var homePrice = 0.0;
    var loanAmount = 0.0;
    var homeValueHigh = 1000000.0;
    var homeValueLow = 0.0;
    var payment = 0.0;

    mortgageInsurance = 0.0;
    while (homeValueHigh > (homeValueLow + 1)) {
      pmi = 0.0;
      var homeValueMid = (homeValueHigh + homeValueLow) / 2;
      var loanAmountNeeded = homeValueMid - downPayment;

      var dpr = ((downPayment / homeValueMid) * 100).floor();
      if (dpr < 20) {
        if ((ipmi) && (iti)) {
          var ipmi_arr = [
            "0.978",
            "0.927",
            "0.878",
            "0.832",
            "0.788",
            "0.746",
            "0.707",
            "0.67",
            "0.635",
            "0.601",
            "0.569",
            "0.539",
            "0.511",
            "0.484",
            "0.459",
            "0.435",
            "0.412",
            "0.39",
            "0.369",
            "0.35"
          ];
          pmi = double.parse(ipmi_arr[dpr]);
        }
      }

      propertyTax = ((homeValueMid * propertyTaxes) / 12).round();
      mortgageInsurance = (((homeValueMid / 100) * pmi) / 12).round();
      payment = monthlyPayment -
          hoaDues -
          homeownersInsurance -
          mortgageInsurance -
          propertyTax;
      var loanAmountGuess =
          ((payment * (1 - (math.pow(1 + interestRate, -loanTerm)))) /
                  interestRate)
              .round();

      if (loanAmountGuess < loanAmountNeeded) {
        homeValueHigh = homeValueMid;
      } else {
        homeValueLow = homeValueMid;
      }

      homePrice = loanAmountGuess + downPayment;
      loanAmount = loanAmountGuess.toDouble();
    }
    house_cost = (homePrice).round();
    final_cost = (loanAmount).round();
    sliderValue = dti;
    var hitrval_disp = ((sliderValue - 0) / (43 - 0));
    var bitrval_disp = (1 - hitrval_disp);
    if (hitrval_disp < 0.2) {
      hitrval_disp = 0.2;
    }
    if (bitrval_disp < 0.2) {
      bitrval_disp = 0.2;
    }
    pigSize = (150 * bitrval_disp);
    homeSize = (150 * hitrval_disp);
    // modify_icons();
    var data_val = [];
    // var pIColor = '#f00a0a';
    // var pmiColor = '#fa6666';
    // var taxesColor = '#f78383';
    // var hoaColor = '#fa4343';
    // var insuranceColor = '#e8c5c5';

    if (emi != 0) {
      var jsondata = {
        "name": "P&I \$" + payment.toString(),
        "y": ((payment * 100) / emi).round(),
        "color": "$pIColor"
      };
      data_val.add(jsondata);
    }

    if (pt != 0) {
      var jsondata = {
        //name: "Taxes $"+currency_con_calc(property_tax,0),
        "name": "Taxes \$" + propertyTax.toString(),
        "y": ((propertyTax * 100) / emi).round(),
        "color": '$taxesColor'
      };
      data_val.add(jsondata);
    }

    if (hoa != 0) {
      var jsondata = {
        "name": "HOA \$" + hoaDues.toString(),
        "y": ((hoaDues * 100) / emi).round(),
        "color": '$hoaColor'
      };
      data_val.add(jsondata);
    }
    if (him != 0) {
      var jsondata = {
        "name": "Insurance \$" + homeownersInsurance.toString(),
        "y": ((homeownersInsurance * 100) / emi).round(),
        "color": '$insuranceColor'
      };
      data_val.add(jsondata);
    }
    if (pmi != 0) {
      var jsondata = {
        "name": "PMI \$" + mortgageInsurance.toString(),
        "y": ((mortgageInsurance * 100) / emi).round(),
        "color": '$pmiColor'
      };
      data_val.add(jsondata);
    }
    pieChartData.clear();
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
            color: chartTextColor,
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

    // var pie_chart_data = '''
    //   {
    //     chart: {
    //         renderTo: 'container',
    //         type: 'pie',
    //         // height: 450,
    //         // width: 450
    //     },
    //     credits: {
    //         enabled: false
    //     },
    //     plotOptions: {
    //         pie: {
    //             size: 155,
    //             borderWidth: 0,
    //             borderColor: null,
    //             dataLabels: {
    //                 connectorWidth: 1,
    //                 //distance: 10
    //             }
    //         },
    //         series: {
    //             states: {
    //                 hover: {
    //                     enabled: false
    //                 }
    //             }
    //         }
    //     },
    //     tooltip: { enabled: false },
    //     title: {
    //         verticalAlign: 'middle',
    //         floating: true,
    //         text: 'Your Payment<br/>\$' + '''+ emi.toString() +'''
    //     },
    //     series: [{
    //         innerSize: '87%',
    //         data: '''+
    //       json.encode(data_val)
    //     +'''
    //
    //
    //     }]
    // }
    // ''';
    full_report_cal();
    show_final(dti, house_cost);
  }

  var score_msg_start = "Based on your income, a house at this price should ";
  var score_msg_color = "fit comfortably ";
  var score_msg_end = "within your budget";
  Color score_msg_text_color = HexColor("#f16905");

  void show_final(dti, amt) {
    var dti_percent = (dti).round();
    if (dti_percent < 37) {
      score_msg_start = 'Based on your income, a house at this price should ';
      score_msg_color = 'fit comfortably ';
      score_msg_end = 'within your budget';
      score_msg_text_color = HexColor("#0ce10b");
    } else {
      score_msg_start = 'Based on your income, a house at this price may ';
      score_msg_color = 'stretch your budget ';
      score_msg_end = 'too thin.';
      score_msg_text_color = HexColor("#f16905");
    }
    update();
  }

  full_report_cal() {
    var total_pay = emi.round();
    var monthly_debts = double.parse(md_TextController.text);
    var left_over = monthly_income - monthly_debts - total_pay;
    var data_month = [];

    if (total_pay != 0) {
      var jsondata = {
        "name": "Payment \$" + total_pay.toString(),
        "y": ((total_pay * 100) / monthly_income).round(),
        "color": "#f00a0a"
      };
      data_month.add(jsondata);
    }

    if (monthly_debts != 0) {
      var jsondata = {
        "name": "Debts \$" + monthly_debts.toString(),
        "y": ((monthly_debts * 100) / monthly_income).round(),
        "color": "#fa7373"
      };
      data_month.add(jsondata);
    }

    if (left_over != 0) {
      var jsondata = {
        "name": "Left over \$" + left_over.toString(),
        "y": ((left_over * 100) / monthly_income).round(),
        "color": '#e8c5c5'
      };
      data_month.add(jsondata);
    }

    pieChartDataMonth.clear();
    pieChartDataMonth.addAll(
      data_month.map(
        (e) => PieChartSectionData(
          color: HexColor(e['color']),
          value: double.parse(e['y'].toString()),
          title: e['name'],
          titlePositionPercentageOffset: 3,
          radius: 10,
          titleStyle: TextStyle(
            fontSize: 14,
            // fontWeight: FontWeight.bold,
            color: chartTextColor,
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

    var hoa = double.parse(hoa_TextController.text);
    var home_insurence = (double.parse(hi_TextController.text) / 12).round();

    var propertytax_percent_val = propertyTax * 12;
    var property_tax = (propertytax_percent_val / 12).round();
    var total_val = (num.parse(emi.toString()) +
            num.parse(property_tax.toString()) +
            num.parse(hoa.toString()) +
            num.parse(home_insurence.toString()) +
            num.parse(mortgageInsurance.toString()))
        .round();
    var fn_emi = ((emi * 100) / total_val).round();
    var fn_tax = ((property_tax * 100) / total_val).round();
    var fn_hoa = ((hoa * 100) / total_val).round();
    var fn_home_ins = ((home_insurence * 100) / total_val).round();
    var fn_pmi = ((mortgageInsurance * 100) / total_val).round();

    var data_val = [];

    if (fn_emi != 0) {
      var jsondata = {
        "name": "P&I \$" + emi.toString(),
        "y": fn_emi,
        "color": "#0066ff"
      };
      data_val.add(jsondata);
    }

    if (fn_tax != 0) {
      var jsondata = {
        "name": "Taxes \$" + property_tax.toString(),
        "y": fn_tax,
        "color": '#66a3ff'
      };
      data_val.add(jsondata);
    }

    if (fn_hoa != 0) {
      var jsondata = {
        "name": "HOA \$" + hoa.toString(),
        "y": fn_hoa,
        "color": '#3385ff'
      };
      data_val.add(jsondata);
    }

    if (fn_home_ins != 0) {
      var jsondata = {
        "name": "Insurance \$" + home_insurence.toString(),
        "y": fn_home_ins,
        "color": '#b3d1ff'
      };
      data_val.add(jsondata);
    }

    if (fn_pmi != 0) {
      var jsondata = {
        "name": "PMI \$" + mortgageInsurance.toString(),
        "y": fn_pmi,
        "color": '#4da6ff'
      };
      data_val.add(jsondata);
    }

    pieChartDataBreakDown.clear();
    pieChartDataBreakDown.addAll(
      data_month.map(
        (e) => PieChartSectionData(
          color: HexColor(e['color']),
          value: double.parse(e['y'].toString()),
          title: e['name'],
          titlePositionPercentageOffset: 3,
          radius: 10,
          titleStyle: TextStyle(
            fontSize: 14,
            // fontWeight: FontWeight.bold,
            color: chartTextColor,
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

    var loanamt = house_cost - double.parse(dp_TextController.text);
    var paymnt = double.parse(lt_TextController.text);
    var rate = double.parse(ir_TextController.text);
    show_new(loanamt, paymnt, rate);
  }

  void show_new(amt, num, rat) {
    var amount = double.parse(amt.toString());
    var numpay = double.parse(num.toString()).toInt();
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
      totalInterest += ir as int;
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
