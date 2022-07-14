
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glud_test/models/user_model.dart';
import 'package:glud_test/services/notification_api.dart';
import 'package:glud_test/universal_pages/login_page.dart';
import 'package:pedometer/pedometer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class HomePage extends StatefulWidget {
  final String? payload;
  const HomePage({ Key? key,
  required this. payload,
  }) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const String keyInsulin = "prefKeyInsulin";
  //store to firestore
  var glucose = '';
  var steps = '';

  //pedometer
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  //firebase auth
  final CollectionReference users = FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  //realtime database for glucose level and insulin
  String _displayText = 'Values go here';
  String _displayCount = 'Intake goes here';
  final _database = FirebaseDatabase.instance.ref();
  int _counter = 0;

  @override
  //insulin counter
  void incrementCount(){
    setState(() {
      _counter++;
    });
  }

  //displaying firestore user data 
  void initState() {
    super.initState();

    //fetching user's full name
    FirebaseFirestore.instance
    .collection("users")
    .doc(user?.uid)
    .get()
    .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
      });
    });
    //for displaying real-time glucose level
     super.initState();
    initPlatformState();
    _activateListeners();   
  }

  //displaying realtime database 
   void _activateListeners() {
    _database.child('guladarah').onValue.listen((event) {
      final Object? guladarah = event.snapshot.value;
      setState(() {
        _displayText = 'Kadar gula darah: $guladarah';
      });
    });
    _database.child('insulin').onValue.listen((event) {
      final Object? insulin = event.snapshot.value;
      setState(() {
        _displayCount = 'Insulin intake: $insulin';
      });
    });
  } 

  //pedometer
  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

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
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){
                logout(context);
              }, icon: Icon(Icons.exit_to_app_rounded, size: 30,)),
            ],
          )
        ],
        title: Text("Hello! ${loggedInUser.fullName}",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Color(0xffFC7643),
          fontSize: 25,
          fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //glucometer
              Container(
                height: 100,
                width: 500,
                child: Text(
                  _displayText + ' mg/dL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height: 20,),
        
              //insulin
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffFFA364),                  
                      ),
                      height: 50,
                      width: 250,
                      child: Directionality(textDirection: TextDirection.ltr, 
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Color(0xffFFA364)),
                        onPressed: () async {
                          try{
                            await insulinRef.update({'insulin': _counter++});
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.setString(keyInsulin, _displayCount);
                            print("The insulin value has been written");
                          } catch(e) {
                            print('Insulin intake error! $e');
                          }
                        }, 
                        icon: Icon(Icons.plus_one_rounded,
                        size: 30,), 
                        label: Text(
                          _displayCount,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff273248),
                          ),
                          textAlign: TextAlign.center,
                        ))),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:  MaterialStateProperty.all(Color(0xffFFA364)),
                      ),
                      onPressed: () {
                        NotificationApi.showScheduledNotification(
                          title: "Insulin Reminder",
                          body: "Don't forget to take your recommended daily dose of insulin!",
                          scheduledDate: DateTime.now().add(Duration(hours: 6))
                          );
                      }, 
                      icon: Icon(Icons.notifications_active_rounded,
                      size: 30), 
                      label: Text('')),
                  )
                ],  
              ),
              SizedBox(height: 20,),
              //pedometer
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffFFA364),
                  ),
                  height: 50,
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Steps taken: ',
                        style: TextStyle(fontSize: 18,
                        color: Color(0xff273248),
                        fontWeight: FontWeight.bold)),
                      Text(
                        _steps,
                        style: TextStyle(fontSize: 18,
                        color: Color(0xff273248),
                        fontWeight: FontWeight.bold)),                   
                    ],
                  ),
                ),
              ),
        
            ],
          ),
        ),
      ),
      
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
