import 'package:demo/models/Transaction.dart';
import 'package:demo/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactin;
  Chart(this.recentTransactin);

  double get totlaSpending {
    return groupedValues.fold(0.0, (previousValue, element) {
      return previousValue += element['amount'];
    });
  }

  List<Map<String, Object>> get groupedValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactin.length; i++) {
        if (recentTransactin[i].date.day == weekday.day &&
            recentTransactin[i].date.month == weekday.month &&
            recentTransactin[i].date.year == weekday.year) {
          totalSum += recentTransactin[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedValues.map((e) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    e['day'],
                    e['amount'],
                    totlaSpending == 0.0
                        ? 0.0
                        : (e['amount'] as double) / totlaSpending),
              );
            }).toList()),
      ),
    );
  }
}
