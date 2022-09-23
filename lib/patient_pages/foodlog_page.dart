import 'package:flutter/material.dart';
import 'package:glud_test/models/food_model.dart';
import 'package:glud_test/patient_pages/food_list.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FoodLog extends StatefulWidget {
  const FoodLog({Key? key}) : super(key: key);
  @override
  State<FoodLog> createState() => _FoodLogState();
}

class _FoodLogState extends State<FoodLog> {
  late List<CalData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  final List<String> mealTime = <String>['Breakfast', 'Lunch', 'Dinner'];

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

    return Scaffold(
      backgroundColor: Color(0xff273248),
      body: Center(
          child: Column(
        children: [
          Card(
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xff6A7DA1),
                Color(0xff556D9D),
                Color(0xff334974),
              ])),
              child: SfCircularChart(
                annotations: [
                  CircularChartAnnotation(
                      widget: Container(
                    child: Text(
                      '1200\nCal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
                ],
                palette: <Color>[
                  Color(0xffFDB777),
                  Color(0xffFD7F2C),
                  Color(0xffFD9346)
                ],
                title: ChartTitle(
                  text: 'Calories Tracked\n\n' + formattedDate,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 16,
                  ),
                ),
                legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 16)),
                tooltipBehavior: _tooltipBehavior,
                series: <CircularSeries>[
                  DoughnutSeries<CalData, String>(
                    dataSource: _chartData,
                    xValueMapper: (CalData data, _) => data.nutrients,
                    yValueMapper: (CalData data, _) => data.calories,
                    dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SpaceGrotesk',
                          color: Colors.white,
                        )),
                    enableTooltip: true,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 150,
              child: ListView(children: [
                Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => FoodList())));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Color(0xff6A7DA1),
                        Color(0xff556D9D),
                        Color(0xff334974),
                      ])),
                      height: 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              Text(
                                'Breakfast',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Nasi, Telur dadar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.navigate_next_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color(0xff6A7DA1),
                      Color(0xff556D9D),
                      Color(0xff334974),
                    ])),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Text(
                              'Lunch',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Nasi, Opor ayam',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.navigate_next_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Color(0xff6A7DA1),
                      Color(0xff556D9D),
                      Color(0xff334974),
                    ])),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Text(
                              'Dinner',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Nasi, Sayur sop',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.navigate_next_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          )
        ],
      )),
    );
  }

  List<CalData> getChartData() {
    final List<CalData> chartData = [
      CalData('Proteins', 180),
      CalData('Carbs', 220),
      CalData('Fats', 120),
    ];
    return chartData;
  }
}

class CalData {
  CalData(this.nutrients, this.calories);
  final String nutrients;
  final int calories;
}
