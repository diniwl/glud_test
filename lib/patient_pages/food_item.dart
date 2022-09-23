import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final String id;
  final String title;
  final double calories;

  FoodItem(this.id, this.title, this.calories);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text("Kalori: " + calories.toString() + " Cal"),
      trailing: Icon(Icons.add));
  }
}