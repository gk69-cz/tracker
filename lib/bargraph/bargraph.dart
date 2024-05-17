import 'package:expensetracker/bargraph/individual_bargraph.dart';
import 'package:expensetracker/helper/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;

  const MyBarGraph(
      {super.key, required this.monthlySummary, required this.startMonth});

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => scrooltoend());
  }
  // list of data per month

  List<individualExpense> barData = [];

  void initializeBarData() {
    barData = List.generate(
      widget.monthlySummary.length,
      (index) => individualExpense(
        x: index,
        y: widget.monthlySummary[index],
      ),
    );
  }

  // upper limit of graph
  double calculateMax() {
    //initial 100o

    double max = 1000;
    widget.monthlySummary.sort();
    max = widget.monthlySummary.last * 1.10;
    if (max < 1000) {
      return 1000;
    }
    return max;
  }

  //scroll controller 
  final ScrollController _scrollController = ScrollController();
  void scrooltoend() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
       duration: const Duration(seconds: 1),
       curve: Curves.fastOutSlowIn,
       );
  }

  @override
  Widget build(BuildContext context) {
    initializeBarData();
    double barWidth = 20;
    double spaceBetween = 15;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          width:
              barWidth * barData.length + spaceBetween * (barData.length - 1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: calculateMax(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                    reservedSize: 24,
                  ),
                ),
              ),
              barGroups: barData
                  .map(
                    (data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                            toY: data.y,
                            width: barWidth,
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey.shade600,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: calculateMax(),
                              color: Colors.white,
                            )),
                      ],
                    ),
                  )
                  .toList(),
              alignment: BarChartAlignment.end,
              groupsSpace: spaceBetween,
            ),
          ),
        ),
      ),
    );
  }
}

// bottom titles
Widget getBottomTitles(double value, TitleMeta meta) {
  const textstyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  String month;
 month = currentMonthName();
  return SideTitleWidget(
    child: Text(
      month,
      style: textstyle,
    ),
    axisSide: meta.axisSide,
  );
}
