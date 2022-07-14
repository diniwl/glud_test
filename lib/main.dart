import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glud_test/patient_pages/bottom_navi.dart';
import 'package:glud_test/patient_pages/home_page.dart';
import 'package:glud_test/services/notification_api.dart';
import 'universal_pages/login_page.dart';
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GludTest());
}

class GludTest extends StatefulWidget {
  const GludTest({ Key? key }) : super(key: key);

  @override
  State<GludTest> createState() => _GludTestState();
}

class _GludTestState extends State<GludTest> {
  void initState() {
    super.initState();
    //flutter notif
    NotificationApi.init();
    listenNotifications();
  }
  
  void listenNotifications() => NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) => 
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(payload: payload),
        ));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GludTest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff273248),
      ),
      home: BottomNavi(),
    );
  }
}