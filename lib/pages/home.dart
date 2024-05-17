import 'package:expensetracker/bargraph/bargraph.dart';
import 'package:expensetracker/component/list_tile.dart';
import 'package:expensetracker/database/expense_database.dart';
import 'package:expensetracker/helper/helper_functions.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepagem extends StatefulWidget {
  const Homepagem({super.key});

  @override
  State<Homepagem> createState() => _HomepagemState();
}

class _HomepagemState extends State<Homepagem> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<Map<String, double>>? _monthlyTotalsFuture;
  Future<double>? calculateCurrentMonthTotal;

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpense();
    // load future
    refreshData();
    super.initState();
  }

  void refreshData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateMonthlyTotals();
    calculateCurrentMonthTotal =
        Provider.of<ExpenseDatabase>(context, listen: false)
            .calculateCurrentMonthTotal();
  }

  void openNewExpeseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),

            //expense amount
            TextField(
              controller: amountController,
              decoration: const InputDecoration(hintText: 'Amount'),
            ),
          ],
        ),
        actions: [
          // cancel
          _cancelButton(),
          _addButton()

          //save
        ],
      ),
    );
  }

  void openEditBox(Expense expense) {
    // pre loading existing data
    String existingName = expense.name;
    String existingAmount = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: existingName),
            ),

            //expense amount
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: existingAmount),
            ),
          ],
        ),
        actions: [
          // cancel
          _cancelButton(),
          _editButton(expense)

          //save
        ],
      ),
    );
  }

  void openDelateBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delate Expense'),
        actions: [
          // cancel
          _cancelButton(),
          _delateButton(expense.id)

          //save
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      // get dates
      int startMonth = value.getStartMonth();
      int startYear = value.getStartYear();
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;

      // no of months calculation
      int monthCount =
          calculateYearCount(startYear, startMonth, currentYear, currentMonth);

      //display for current month
      List<Expense> currentMonthExpense = value.allExpense.where((expense) {
        return expense.date.year == currentYear &&
            expense.date.month == currentMonth;
      }).toList();

      // the ui
      return Scaffold(
        backgroundColor: Colors.grey.shade300,
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpeseBox,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: SizedBox(
            child: FutureBuilder<double>(
              future: calculateCurrentMonthTotal,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\₹" + '${snapshot.data!.toStringAsFixed(2)}'),
                      Text(currentMonthName()),
                    ],
                  );
                } else {
                  return Text("Loading...");
                }
              },
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              //graph
              SizedBox(
                height: 250,
                child: FutureBuilder(
                  future: _monthlyTotalsFuture,
                  builder: (context, snapshot) {
                    // data is loaded

                    if (monthCount > 0 &&
                        snapshot.connectionState == ConnectionState.done) {
                      Map<String, double> _monthlyTotals = snapshot.data ?? {};
                      //create monthly list

                      List<double> monthlySummary = List.generate(
                        monthCount,
                        (index) {
                          int year =
                              (startYear + ((startMonth + index - 1) / 12))
                                  .toInt();
                          int month = (startMonth + index - 1) % 12 + 1;
                          String yearMonthKey =
                              year.toString() + '-' + month.toString();
                          return _monthlyTotals[yearMonthKey] ?? 0.0;
                        },
                      );

                      return MyBarGraph(
                        monthlySummary: monthlySummary,
                        startMonth: startMonth,
                      );
                    } else {
                      return const Center(
                        child: Text('Add an expense'),
                      );
                    }
                    // loading
                  },
                ),
              ),
              const SizedBox(height: 25),
              //return list of expense
              Expanded(
                child: ListView.builder(
                  itemCount: currentMonthExpense.length,
                  itemBuilder: ((context, index) {
                    //list reverse
                    int reverseIndex = currentMonthExpense.length - 1 - index;
                    // each expense
                    Expense individualExpense =
                        currentMonthExpense[reverseIndex];
                    //list view
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: TheListTile(
                        title: individualExpense.name,
                        trailing: formatAmount(individualExpense.amount),
                        onEditPresed: (context) =>
                            openEditBox(individualExpense),
                        onDelatePresed: (context) =>
                            openDelateBox(individualExpense),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _cancelButton() {
    return MaterialButton(
      onPressed: () {
        // remove box
        Navigator.pop(context);

        // clear controllers
        nameController.clear();
        amountController.clear();
      },
      child: const Text('Cancel'),
    );
  }

  Widget _addButton() {
    return MaterialButton(
      onPressed: () async {
        // null check
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
// remove box
          Navigator.pop(context);

//create expense
          Expense newExpense = Expense(
            name: nameController.text,
            amount: stringToDouble(amountController.text),
            date: DateTime.now(),
          );
// save to db

          await context.read<ExpenseDatabase>().createNewExpense(newExpense);
          refreshData();
//clear controllers
          nameController.clear();
          amountController.clear();
        }
      },
      child: const Text('Save'),
    );
  }

  Widget _editButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          Navigator.pop(context);

          Expense updatedExpense = Expense(
            name: nameController.text.isNotEmpty
                ? nameController.text
                : expense.name,
            amount: amountController.text.isNotEmpty
                ? stringToDouble(amountController.text)
                : expense.amount,
            date: DateTime.now(),
          );
          int existingId = expense.id;

          await context
              .read<ExpenseDatabase>()
              .updateExpense(existingId, updatedExpense);
          refreshData();
        }
      },
      child: const Text('Update'),
    );
  }

  // delate button
  Widget _delateButton(int id) {
    return MaterialButton(
      onPressed: () async {
        //remove box
        Navigator.pop(context);
        //delate from db

        await context.read<ExpenseDatabase>().delateExpense(id);
        refreshData();
      },
      child: const Text('Delate'),
    );
  }
}
