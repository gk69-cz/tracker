// convert str to double

import 'package:intl/intl.dart';

//string to double
double stringToDouble (String string){
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

// add rs 
String formatAmount(double amount){
  final format = NumberFormat.currency(locale: "en_US", symbol: "\₹",decimalDigits: 2);
  return format.format(amount);
}

// calculate total month
int calculateYearCount(int startYear, int startMonth, int currentYear,int currentMonth){

  int monthCount = (currentYear-startYear)*12 + currentMonth - startMonth +1;

  return monthCount;
}

// get current month name

String currentMonthName (){
  DateTime now = DateTime.now();
  List<String> month = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];

  return month[now.month-1];
}

