import 'package:flutter/material.dart';
import 'package:glud_test/patient_pages/consult_page.dart';
import 'package:glud_test/patient_pages/home_page.dart';
import 'package:glud_test/patient_pages/report_page.dart';
import '../screens/products_overview_screen.dart';
import 'chart_page.dart';
import 'home_page.dart';
import 'consult_page.dart';

class BottomNavi extends StatefulWidget {
  @override
  State<BottomNavi> createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  int _currentIndex = 0;
  //ypu can change the list later with the fixed pages
  final List<Widget> body = [
    HomePage(
      payload: '',
    ),
    ChartPage(),
    ProductsOverviewScreen(),
    ConsultPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.assessment),
            backgroundColor: Colors.grey,
            label: 'Report',
          ),
          
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_rounded),
              backgroundColor: Colors.grey,
              label: 'Food Log',),

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