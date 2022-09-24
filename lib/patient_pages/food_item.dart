import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final String id;
  final String title;
  final double calories;

  FoodItem(this.id, this.title, this.calories);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xff6A7DA1),
            Color(0xff556D9D),
            Color(0xff334974)
          ])),
          child: ListTile(
              title: Text(title,
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),),
              subtitle: Text("Kalori: " + calories.toString() + " Cal",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),),
              trailing: IconButton(
                onPressed: ()  {}, 
                icon: Icon(Icons.add,
                color: Colors.white,))),
        ),
      ),
    );
  }
}
