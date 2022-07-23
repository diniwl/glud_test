import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glud_test/models/user_model.dart';
import 'package:glud_test/services/notification_api.dart';
import 'package:glud_test/universal_pages/login_page.dart';
import 'package:pedometer/pedometer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class HomePage extends StatefulWidget {
  final String? payload;
  const HomePage({
    Key? key,
    required this.payload,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //current date
  String formattedDate = DateFormat.yMMMMd('en_US').format(DateTime.now());

  static const String keyInsulin = "prefKeyInsulin";
  //store to firestore
  var glucose = '';
  var steps = '';

  bool notifClick = true;

  //pedometer
  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  double _distance = 0;
  double _calories = 0;

  //firebase auth
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  //realtime database for glucose level and insulin
  String _displayText = '0';
  String _displayCount = '0';
  final _database = FirebaseDatabase.instance.ref();
  int _counter = 0;


  @override
  //insulin counter
  void incrementCount() {
    setState(() {
      _counter++;
    });
  }

  void initState() {
    //fetching user fullname
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    initPlatformState();
    _activateListeners();
  }

  //displaying realtime database
  void _activateListeners() {
    _database.child('guladarah').onValue.listen((event) {
      final Object? guladarah = event.snapshot.value;
      setState(() {
        _displayText = '$guladarah';
      });
    });
    _database.child('insulin/insulin').onValue.listen((event) {
      final Object? insulin = event.snapshot.value;
      setState(() {
        _displayCount = '$insulin';
      });
    });
  }

  //pedometer
  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps;
      _distance = _steps/1312;
      _calories = _steps*0.04;
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 0;
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final insulinRef = _database.child('insulin');
    return Scaffold(
      backgroundColor: Color(0xff273248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  logout(context);
                },
                child: Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
        title: Text("Hello, ${loggedInUser.fullName}",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),

            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),

            SizedBox(
              height: 30,
            ),

            //glucometer
            Center(
              child: CircularPercentIndicator(
                radius: 110,
                lineWidth: 13,
                animation: true,
                percent: double.parse(_displayText) * 0.0025,
                center: Column(
                  children: [
                    SizedBox(height: 70),
                    Text(
                      (_displayText),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text('mg/dL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ))
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Color(0xff556D9D),
                linearGradient: LinearGradient(colors: [
                  Color(0xfffff6c0),
                  Color(0xfffeba00),
                  Colors.redAccent,
                ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //pedometer
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 5,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
                child: Container(
                  height: 75,
                  width: 350,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xff6A7DA1),
                    Color(0xff556D9D),
                    Color(0xff334974),
                  ])),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.directions_walk_rounded,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        _steps.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.add_road_rounded,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(_distance.toString() +
                        ' Km',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Octicons.flame, size: 20),
                      SizedBox(width: 10),
                      Text(_calories.toString() +
                        ' Cal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),

            //insulin reminder
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              child: ClipPath(
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
                child: Container(
                  height: 100,
                  width: 350,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xff6A7DA1),
                    Color(0xff556D9D),
                    Color(0xff334974)
                  ])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.medication_rounded,
                        size: 40,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Insulin',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 23,
                          ),
                          Text(
                            _displayCount,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          //yang belom
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  notifClick = !notifClick;
                                });
                              },
                              icon: Icon((notifClick == false)?
                                Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                              )),

                          IconButton(
                              onPressed: () async {
                                try {
                                  await insulinRef
                                      .update({'insulin': _counter++});
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  print('The insulin value has been updated');
                                } catch (e) {
                                  print('Insulin intake error $e');
                                }
                              },
                              icon: Icon(
                                Icons.plus_one_rounded,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
