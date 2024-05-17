import 'dart:async';

import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

  // setup

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

  // getter
  List<Expense> get allExpense => _allExpenses;

  //operations

  // create - new expense
  Future<void> createNewExpense(Expense newExpense) async {
    await isar.writeTxn(() => isar.expenses.put(newExpense));
    await readExpense();
  }

  //read - read expense
  Future<void> readExpense() async {
    List<Expense> fetchedExpenses = await isar.expenses.where().findAll();

    // giv local expense list
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);
  

    //ui update

    notifyListeners();
  }

  //update - update expense

  Future<void> updateExpense(int id, Expense updatedExpense) async {
    updatedExpense.id = id;
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    // re read from db
    await readExpense();
  }

  //delate -delate expense
  Future<void> delateExpense(int id) async {
    await isar.writeTxn(() => isar.expenses.delete(id));

    // re read from db
    await readExpense();
  }

  //helpers
    //current month total
    Future<double> calculateCurrentMonthTotal() async {
      //read from db
       await readExpense();

      // get month 
      int currentMonth = DateTime.now().month;
       int currentYear = DateTime.now().year;
       
       // filter for this year
       List<Expense> currentMonthExpense = _allExpenses.where((expense) {
        return 
        expense.date.month == currentMonth && 
        expense.date.year == currentYear;
       }).toList();
       double total = currentMonthExpense.fold(
        0, (sum, expense) => sum + expense.amount);

        return total;

    }



  // calculating total expense for each month
  Future<Map<String, double>> calculateMonthlyTotals() async {
    //reading expense
    await readExpense();

    // create map to track total expense per month

    Map<String, double> monthlyTotals = {};

    // iterate over all expense
    for (var expense in _allExpenses) {
     //  get year +month

      String yearMonth = expense.date.year.toString() +'-'+expense.date.month.toString();

      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0;
      }
      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + expense.amount;
    }
    return monthlyTotals;
  }

  // get start month
  int getStartMonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().month;
    }

  
// sort expense by date
    _allExpenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpenses.first.date.month;
  }

  // get start year
  int getStartYear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().year;
    }

// sort expense by date
    _allExpenses.sort(
      (a, b) => a.date.compareTo(b.date),
    );
    return _allExpenses.first.date.year;
  }
}
