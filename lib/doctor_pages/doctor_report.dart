import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<GlucoDetails> gluco = [];

  Future<String> getJsonFromFirebase() async {
    String url =
        "https://gludtest-30ee3-default-rtdb.firebaseio.com/testData.json";
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  Future loadGlucoData() async {
    final String jsonString = await getJsonFromFirebase();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse) {
      gluco.add(GlucoDetails.fromJson(i));
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    loadGlucoData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xff273248),
            body: FutureBuilder(
              future: getJsonFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Center(
                        child: Container(
                          height: 350,
                          width: 450,
                          child: (SfCartesianChart(
                              title: ChartTitle(
                                  text: "Kadar gula darah",
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  )),
                              plotAreaBackgroundColor: Color(0xff273248),
                              primaryXAxis: CategoryAxis(
                                  visibleMaximum: 6,
                                  majorGridLines: MajorGridLines(
                                    width: 0,
                                  ),
                                  minorGridLines: MinorGridLines(
                                    width: 0,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  )),

                              primaryYAxis: NumericAxis(
                                isVisible: false,
                                  visibleMaximum: 300,
                                  majorGridLines: MajorGridLines(
                                    width: 0,
                                  ),
                                  minorGridLines: MinorGridLines(
                                    width: 0,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  )),
                                  //pagination

                              series: <ChartSeries>[
                                SplineAreaSeries<GlucoDetails, String>(
                                    borderWidth: 3,
                                    borderColor: Colors.white,
                                    gradient: LinearGradient(colors: [
                                      Color(0xfffff6c0),
                                      Color(0xfffeba00),
                                      Colors.redAccent,
                                    ]),
                                    dataSource: gluco,
                                    dataLabelSettings: DataLabelSettings(
                                      color: Colors.white,
                                      textStyle: TextStyle(
                                        color: Color(0xff273248),
                                        fontFamily: 'SpaceGrotesk',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      isVisible: true,
                                    ),
                                    xValueMapper: (GlucoDetails details, _) =>
                                        details.day,
                                    yValueMapper: (GlucoDetails details, _) =>
                                        details.readings),
                              ])),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )));
  }
}

class GlucoDetails {
  GlucoDetails(this.day, this.readings);
  final String day;
  final int readings;

  factory GlucoDetails.fromJson(Map<String, dynamic> parsedJson) {
    return GlucoDetails(parsedJson['day'].toString(), (parsedJson['readings']));
  }
}
