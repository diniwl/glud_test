import 'package:flutter/material.dart';
import 'package:glud_test/patient_pages/food.dart';
import 'package:intl/intl.dart';

import './foodlog_page.dart';

class FoodChart extends StatelessWidget {

  final List<Food> recentFood;

  FoodChart(this.recentFood);

  List<Map<String, Object>> get groupedCaloryValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index),);
      var totalSum = 0.0;

      for (var i = 0; i < recentFood.length; i++) {
        if(recentFood[i].date.day == weekDay.day && 
          recentFood[i].date.month == weekDay.month && 
          recentFood[i].date.year == weekDay.year); {
            totalSum += recentFood[i].calory;
          }
      }

      print(DateFormat.E().format(weekDay));

      return {'day': DateFormat.E().format(weekDay), 'calories' : totalSum};
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedCaloryValues);
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          
        ]),
    );
  }
}