import 'package:flutter/material.dart';
import './food.dart';

class FoodLog extends StatefulWidget {
  const FoodLog({Key? key}) : super(key: key);

  @override
  State<FoodLog> createState() => _FoodLogState();
}

class _FoodLogState extends State<FoodLog> {
  final List<Food> food = [
    Food(id: 't1', title: 'Rice', calory: 200, date: DateTime.now()),
    Food(id: 't2', title: 'Fried egg', calory: 80, date: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff273248),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: double.infinity,
              child: Card(
                color: Colors.orange,
                child: Text('Chart'),
                elevation: 3,
              ),
            ),
            Column(
              children: food.map((meal) {
                return Card(
                  child: Row(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.orange,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          meal.calory.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.orange),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meal.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.orange,
                          ),),
                          Text(meal.date.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey,
                          ),),
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ));
  }
}
