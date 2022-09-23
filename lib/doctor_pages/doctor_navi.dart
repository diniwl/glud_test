import 'package:flutter/material.dart';
import 'package:glud_test/doctor_pages/doctor_consult.dart';
import 'package:glud_test/doctor_pages/doctor_home.dart';
import 'doctor_home.dart';
import 'doctor_consult.dart';


class DoctorNavi extends StatefulWidget{

  @override
  State<DoctorNavi> createState() => _DoctorNaviState();
}


class _DoctorNaviState extends State<DoctorNavi> {
  int _currentIndex = 0;
  //ypu can change the list later with the fixed pages
  final List<Widget> body = [
    DoctorHomePage(),
    DoctorConsult(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Color(0xff273248),
        body: body[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.orange,
          elevation: 0,
          iconSize: 30,
          items: [
            //urutannya harus sama di urutan list final tabs
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Colors.grey,
              label: 'Home',
            ),         
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              backgroundColor: Colors.grey,
              label: 'Consult',
              ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          ),
  );
  }
}

