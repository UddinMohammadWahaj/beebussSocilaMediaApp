import 'dart:convert';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class RefinanceCalculatorController extends GetxController {
  var mortgageIndex = 0.obs;
  void changeMortgageIndex(int index) {
    mortgageIndex.value = index;
    update();
  }

  TextEditingController home_price_TextController =
      TextEditingController(text: "200000");
  TextEditingController months_pay_TextController =
      TextEditingController(text: "360");
  TextEditingController ir_TextController =
      TextEditingController(text: "5.222");
  TextEditingController originated_year_TextController =
      TextEditingController(text: "2010");
  TextEditingController new_loanamt_TextController =
      TextEditingController(text: "192000");
  TextEditingController new_ir_rate_TextController =
      TextEditingController(text: "4.472");
  TextEditingController new_months_pay_TextController =
      TextEditingController(text: "360");
  TextEditingController ref_fees_TextController =
      TextEditingController(text: "6000");
  TextEditingController cashout_TextController =
      TextEditingController(text: "0");
  bool roll_fees = false;
  var barChart = "".obs;
  var lineChart = "".obs;

  var scheduleChartData = ''.obs;
  var irPrChartData = ''.obs;
  var totalInterest = 0;
  var irPrTablearr = [];

  var MONTHLY_SAVINGS, NEW_PAYMENT, BREAK_EVEN, COST, LIFETIME_SAVINGS;

  void changeRollFees(bool? val) {
    roll_fees = val!;
    new_cal_c(isChangeFrom: "iti");
  }

  void new_cal_c({isChangeFrom = "home_price"}) async {
    var current_loan = double.tryParse(home_price_TextController.text) ??
        0.0; //Current loan amount
    var old_term = double.tryParse(months_pay_TextController.text) ?? 0.0;
    var ir = double.tryParse(
        (double.tryParse(ir_TextController.text) ?? 0.0).toStringAsFixed(3));
    if (ir! > 100) {
      ir_TextController.text = "100";
      ir = 100;
    } else {
      ir_TextController.text = ir.toString();
    }

    var originated_year =
        double.tryParse(originated_year_TextController.text) ?? 0.0;
    var new_loan_amt = double.tryParse(new_loanamt_TextController.text) ?? 0.0;
    var new_term = double.tryParse(new_months_pay_TextController.text) ?? 0.0;
    var refinement_fees = double.tryParse(ref_fees_TextController.text) ?? 0.0;
    var cash_out = double.tryParse(cashout_TextController.text) ?? 0.0;

    var nir = double.tryParse(
        (double.tryParse(new_ir_rate_TextController.text) ?? 0.0)
            .toStringAsFixed(3));
    if (nir! > 100) {
      new_ir_rate_TextController.text = "100";
      nir = 100;
    } else {
      // new_ir_rate_TextController.text = nir.toString();
    }

    var final_amt, amt_fr_emi, break_even;
    if (!roll_fees) {
      final_amt = refinement_fees + new_loan_amt + cash_out;
      amt_fr_emi = new_loan_amt;
    } else {
      final_amt = refinement_fees + new_loan_amt + refinement_fees + cash_out;
      break_even = 1;
      amt_fr_emi = new_loan_amt + refinement_fees;
      refinement_fees = 0;
    }

    var today = new DateTime.now();
    var past = new DateTime(originated_year.toInt(), 01, 01);

    var total_months_from_new = getAge(past, today);

    var array_a = get_array_amortization(current_loan, old_term, ir);
    var array_b = get_array_amortization(amt_fr_emi, new_term, nir);

    var i;
    var month_a_count = total_months_from_new; //TODO:check this for wrong value
    List<double> array_to_plot = [];
    var saving;
    var cost = refinement_fees;
    var cost_over;
    var fr_cost_over;
    var saving_old;
    var highest_point;
    var after_lastsaving;

    var new_extensive_point;
    var diff_arra = array_a.length - total_months_from_new;
    var cst_ovr;
    if (array_b.length > diff_arra) {
      for (i = 0; i < array_b.length; i++) {
        if ((month_a_count < array_a.length) &&
            array_a[month_a_count as int] != null) {
          if (saving != null) {
            saving_old = saving;
            saving = saving + array_a[month_a_count] - array_b[i];

            if (saving > 0 && cost_over == null) {
              cost_over = saving.toString() + "," + i.toString();
              var cst_ovr = i;
            }
          } else {
            saving = (array_a[month_a_count] - array_b[i] - cost);
          }
        } else {
          saving_old = saving;
          saving = (saving ?? "") + (0 - array_b[i]);
          if (saving_old > saving && highest_point == null) {
            highest_point = saving_old.toString() + "," + i.toString();
          }
          if (saving < 0 && after_lastsaving == null) {
            after_lastsaving = saving_old.toString() + "," + i.toString();
          }
        }
        array_to_plot.add(saving);
        month_a_count++;
      }
    } else {
      if (diff_arra > array_b.length) {
        for (i = 0; i < diff_arra; i++) {
          if ((i < array_b.length - 1) && array_b[i] != null) {
            if (saving != null) {
              saving_old = saving;
              saving = saving + array_a[i] - array_b[i];

              if (saving > 0 && cost_over == null) {
                cost_over = saving + "," + i;
                cst_ovr = i;
                //console.log(cost_over+"chk");
              }
            } else {
              saving = (array_a[i] - array_b[i] - cost);
            }
          } else {
            saving_old = saving;
            saving = saving + (array_a[i] - 0);
            if (saving_old > saving && highest_point == null) {
              //highest_point = saving_old+","+i;
            }

            if (saving > 0 && cost_over == null) {
              cost_over = saving.toString() + "," + i.toString();
              cst_ovr = i;
            }

            if (saving < 0 && after_lastsaving == null) {
              after_lastsaving = saving_old.toString() + "," + i.toString();
            }
          }

          if (saving > 0 && new_extensive_point == null) {
            //console.log('hello');
            new_extensive_point = saving.toString() + "," + i.toString();
          }
          if (i == diff_arra) {
            if (!(saving).isNaN) {
              highest_point = saving.toString() + "," + i.toString();
            }
          }
          if (cost == 0 && cost_over == null) {
            cost_over = saving.toString() + "," + i.toString();
            cst_ovr = i;
          }
          if (!(saving).isNaN) {
            array_to_plot.add(saving);
          }

          month_a_count++;
        }
      }
    }

    if (new_extensive_point != null) {
      highest_point = new_extensive_point;
    }

    plot_chart(array_to_plot, refinement_fees, cost_over, highest_point,
        after_lastsaving, new_term);

    var emi = array_b.last;
    var emi_2 = array_a.last;
    var mo_saving = emi_2 - emi;
    if (!(mo_saving > 0)) {
      mo_saving = '';
    }
    var total_saving = array_to_plot.last;
    var dt = double.tryParse(ref_fees_TextController.text) ?? 0.0;
    MONTHLY_SAVINGS = mo_saving;
    NEW_PAYMENT = emi;

    if (cst_ovr != null) {
      BREAK_EVEN = cst_ovr;
      COST = dt;
    } else {
      BREAK_EVEN = "N/A";
      COST = dt;
    }
    if (!roll_fees) {
      if (total_saving < 0) {
        total_saving = total_saving + dt;
        LIFETIME_SAVINGS = total_saving;
      } else {
        total_saving = total_saving - dt;
        LIFETIME_SAVINGS = total_saving;
      }
    } else {
      if (total_saving < 0) {
        total_saving = total_saving + dt;
        LIFETIME_SAVINGS = total_saving;
      } else {
        total_saving = total_saving - dt;
        LIFETIME_SAVINGS = total_saving;
      }
    }
    show_new(new_loan_amt, new_term, nir);
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
    scheduleChartData.value = '''{

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
      totalInterest += ir! as int;
      irList.add(ir.round());
      prList.add(pr.round());
      irPrTablearr
          .add({"i": i, "E": E, "ir": ir, "pr": pr, "bal": bal.round()});
    }
    irPrChartData.value = '''{
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

  void plot_chart(List<double> array, cost, fi, sc, thi, new_term) {
    //});
    var years = (new_term / 12).round();
    if (years > 10) {
      years = (years / 10).round();
    } else {
      // console.log(years);
    }

    var arr = array;

    var j;
    var arra_cnt = 120;
    var ini_dt = 0;
    var arr_fr_years = [];
    arr_fr_years.add(1);

    var final_num = ((arra_cnt / 12).floor() / 10).floor();
    var new_var;
    var series_dt = [];

    var data_val = [];

    var new_val_chk = 119;
    var currenct_cost = double.tryParse(ref_fees_TextController.text) ?? 0.0;
    var jsondata = {"name": "Cost", "y": currenct_cost, "color": '#ff0000'};
    data_val.add(jsondata);
    for (var l = 0; l < arr.length; l++) {
      if (l == 0) {
        var jsondata = {"name": "1yr", "y": arr[l], "color": "#47d147"};
        data_val.add(jsondata);
      }
      if (l == new_val_chk) {
        var years_val = ((l / 12).round() / 10).round().toString() + "0yrs";
        //console.log(years_val);
        var jsondata = {"name": years_val, "y": arr[l], "color": "#47d147"};
        data_val.add(jsondata);
        new_val_chk = new_val_chk + 120;
      }
    }
    //console.log(data_val);
    for (j = 0; j < arr.length; j++) {
      if (arra_cnt == j) {
        arr_fr_years.add(arr[j]);
        arra_cnt = arra_cnt + 120;
      }
    }

    for (new_var = 0; new_var < final_num; new_var++) {
      if (new_var == 0) {
        series_dt.add('1yr');
      } else {
        series_dt.add(new_var + '0yrs');
      }
    }

    // var last_one_2 = 1;
    //
    // array.sort((a, b) => a.compareTo(b));
    // var max_2 = array.last;
    var high_chrt = '''{
        chart: {
            type: 'bar'
        },
        title: {
            text: ''
        },
        credits: {
            enabled: false
        },
        xAxis: {
            type: 'category'
        },
        yAxis: {
            // min: last_one_2, max: max_2, 
            tickInterval: 5000,
            min: 0,
            title: {
                // text: 'Population (millions)',
                // align: 'high',
                // text: this.yAxisTitle,
                // align: 'low'
            },
            labels: {
                overflow: 'justify'
            }
        },
        legend: {
            enabled: false
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: false,
                    format: '{point.y:.1f}%'
                }
            }
        },
        tooltip: {
            enabled: false,
            headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
            pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
        },
        "series": [{
            "name": "Browsers",
            "colorByPoint": true,
            "data": [{
                "name": "Cost",
                "y": ''' +
        cost.toString() +
        ''',
                color: '#ff0000'
            }]
        }],
        series: [{
            data:''' +
        jsonEncode(data_val) +
        ''' 
        }]
    }''';
    barChart.value = high_chrt;

    var all_data_break_even = [];

    if (fi != null) {
      var first = fi.split(",");
      var jsondata = {"x": num.parse(first[1]), "y": num.parse(first[0])};
      all_data_break_even.add(jsondata);
    }
    if (sc != null) {
      var first = sc.split(",");
      var jsondata = {"x": num.parse(first[1]), "y": num.parse(first[0])};
      all_data_break_even.add(jsondata);
    }
    if (thi != null) {
      var first = thi.split(",");
      var jsondata = {"x": num.parse(first[1]), "y": num.parse(first[0])};
      all_data_break_even.add(jsondata);
    }

    all_data_break_even.sort((a, b) {
      return a["x"] - b["x"];
    });

    var array2 = new List.from(array);
    array2.sort((a, b) => a.compareTo(b));
    var last_one = array2.first;
    var max = array2.last;
    var new_chart = '''{
        xAxis: {
            labels: {
                formatter: function() {
                    return this.value + " mo";
                }
            }
        },
        yAxis: {
            min: ''' +
        last_one.toString() +
        ''',
            max: ''' +
        max.toString() +
        ''', //tickInterval: 20000,
            labels: {
                formatter: function() {
                    if (this.value < 0) {
                        var num = this.value *= -1;
                        return "-\$" + (num != 0)?num > 999 ? (num/1000) + 'k' : num:1;
                    } else {
                        return "\$" + (this.value != 0)?this.value > 999 ? (this.value/1000) + 'k' : this.value:1;
                    }
                },
                y: -2,
                x: 0,
                align: 'left',
            }
        },
         tooltip: {
            formatter: function() {
                var s = '<div class="new_class_chk">'; //= '<b>' + Highcharts.dateFormat('%A, %b %e, %Y', this.x) + '</b>';
                var loop_val = 0;
                if (this.y < 0) {
                    s += '<br/> Total Savings abc = -\$' + Math.abs(this.y) + ' ';
                } else {
                    s += '<br/> Total Savings = \$' + Math.abs(this.y) + ' ';
                }
                s += '<br/>          Month = ' + this.x + '</div>';
                return s;
            }
        },
    
        credits: {
            enabled: false
        },
        scrollbar: {
            enabled: false
        },
        rangeSelector: {
            enabled: false
        },
        navigator: {
            enabled: false
        },
        title: {
            text: ''
        },
        legend: {
            enabled: false,
            layout: 'vertical',
            align: 'left',
            verticalAlign: 'top',
            floating: true,
            backgroundColor: '#FFFFFF'
        },
        plotOptions: {
            series: {
                /*   marker: {
                     enabled: false
                   } */
            }
        },
        chart: {
            events: {
                redraw: function() {
                
                    \$.each(this.series, function(series) {
                        \$.each(this.series[series].data, function() {
                            //console.log(chart.series[series].data);
                            if (this.y === 0 && this.graphic) {
                                this.graphic.hide();
                            }
                        });
                    });
                }
            }
        },
        series: [{
                name: 'Total Savings',
                data:[''' +
        array.join(', ') +
        '''],
                //data:[26]
                // data: [""+newPrincipal_arr.join(', ')+""]
                color: '#33cc33'

            },
            {
                data:''' +
        jsonEncode(all_data_break_even) +
        ''' ,
                lineWidth: 0,
                color: '#33cc33',
                marker: {
                    enabled: true,
                    radius: 6,
                    fillColor: '#0033cc',
                    symbol: "circle"
                }
            }

        ]
    }
    
    
    ''';

    lineChart.value = new_chart;
    update();
  }

  num getAge(DateTime date_1, DateTime date_2) {
    var date2_UTC = new DateTime.utc(date_2.year, date_2.month, date_2.day);
    var date1_UTC = new DateTime.utc(date_1.year, date_1.month, date_1.day);
    var yAppendix, mAppendix, dAppendix;

    num days = date2_UTC.day - date1_UTC.day;
    if (days < 0) {
      date2_UTC = DateTime(date2_UTC.year, date2_UTC.month - 1, date2_UTC.day);
      days += DaysInMonth(date2_UTC);
    }
    var months = date2_UTC.month - date1_UTC.month;
    if (months < 0) {
      date2_UTC = DateTime(date2_UTC.year - 1, date2_UTC.month, date2_UTC.day);
      days += DaysInMonth(date2_UTC).toInt();
      months += 12;
    }
    var years = date2_UTC.year - date1_UTC.year;

    if (years > 1)
      yAppendix = " years";
    else
      yAppendix = " year";
    if (months > 1)
      mAppendix = " months";
    else
      mAppendix = " month";
    if (days > 1)
      dAppendix = " days";
    else
      dAppendix = " day";

    var fn_mnth = (years * 12) + months;

    return fn_mnth;
  }

  num DaysInMonth(DateTime date2_UTC) {
    var monthStart = new DateTime(date2_UTC.year, date2_UTC.month, 1);
    var monthEnd = new DateTime(date2_UTC.year, date2_UTC.month + 1, 1);
    var monthLength = (monthEnd.difference(monthStart)).inMilliseconds /
        (1000 * 60 * 60 * 24);
    return monthLength;
  }

  List get_array_amortization(amt, num, rat) {
    var amount = double.tryParse(amt.toString());
    var numpay = double.tryParse(num.toString())!.toInt();
    var rate = double.tryParse(rat.toString());

    rate = rate! / 100;

    var monthly = rate / 12;
    var payment =
        ((amount! * monthly) / (1 - math.pow((1 + monthly), -numpay)));
    var total = payment * numpay;
    var interest = total - amount;

    var fn_ttl_interst = fixVal(interest, 0, 2, ' ');
    var fn_ttl_pay = fixVal(payment, 0, 2, ' ');
    var fn_mnthly_instalment = fixVal(total, 0, 2, ' ');
    var fn_num_yrs = numpay / 12;

    var array_for_emi = [];

    var i = 1;

    while (i <= numpay) {
      array_for_emi.add(fn_ttl_pay);
      i++;
    }

    return array_for_emi;
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
