import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './food_chart.dart';
import './food.dart';

class FoodLog extends StatefulWidget {
  const FoodLog({Key? key}) : super(key: key);

  @override
  State<FoodLog> createState() => _FoodLogState();
}

class _FoodLogState extends State<FoodLog> {
  final List<Food> food = [];

  final List<Food> recentFood = [];

  //String? foodInput;
  //String? caloryInput;
  final foodController = TextEditingController();
  final caloryController = TextEditingController();

  void submitData() {
    final enteredFood = foodController.text;
    final enteredCalory = double.parse(caloryController.text);

    if (enteredFood.isEmpty || enteredCalory <= 0) {
      return;
    }

    addNewFood(enteredFood, enteredCalory);
  }

  void addNewFood(String meal, double calory) {
    final newMeal = Food(
        id: DateTime.now().toString(),
        title: meal,
        calory: calory,
        date: DateTime.now());

    setState(() {
      food.add(newMeal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              width: double.infinity,
              child: Card(
                color: Color(0xffFC7643),
                child: Text('Chart'),
                elevation: 3,
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Foods'),
                      controller: foodController,
                      //onChanged: (val) {
                      //foodInput = val;
                      //},
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Calories'),
                      controller: caloryController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => submitData,
                      //onChanged: (val) {
                      //caloryInput = val;
                      // },
                    ),
                    TextButton(
                        onPressed: submitData,
                        child: Text('Submit Log'),
                        style: TextButton.styleFrom(
                          primary: Colors.orange,
                        ))
                  ],
                ),
              ),
            ),
            Container(
              height: 300,
              child: food.isEmpty
                  ? Column(
                      children: [
                        SizedBox(height: 80),
                        Text('No meals added yet!',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'assets/images/hungry.png',
                              fit: BoxFit.cover,
                            )),
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Color(0xffFC7643),
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  food[index].calory.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xffFC7643)),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Color(0xffFC7643),
                                    ),
                                  ),
                                  Text(
                                    DateFormat().format(food[index].date),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: food.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
