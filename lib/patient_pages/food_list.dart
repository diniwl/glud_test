import 'package:flutter/material.dart';
import 'package:glud_test/patient_pages/food_item.dart';

import '../models/food_model.dart';

class FoodList extends StatelessWidget {
  final List<Food> loadedFood = [
    Food(
        id: "m1",
        title: "Daging Sapi",
        carbs: 0,
        proteins: 19.1,
        fats: 12,
        calories: 190),
    Food(
        id: "m2",
        title: "Cokelat Batang",
        carbs: 53.6,
        proteins: 9,
        fats: 35,
        calories: 565),
    Food(
        id: "m3",
        title: "Bakpia",
        carbs: 44,
        proteins: 8.7,
        fats: 6.7,
        calories: 272),
    Food(
        id: "m4",
        title: "Ayam",
        carbs: 0,
        proteins: 18.2,
        fats: 25,
        calories: 298),
    Food(
        id: "m5",
        title: "Hati Ayam",
        carbs: 1.6,
        proteins: 27.5,
        fats: 16.1,
        calories: 261),
    Food(
        id: "m6",
        title: "Nasi Putih",
        carbs: 77,
        proteins: 8.4,
        fats: 1.7,
        calories: 357),
    Food(
        id: "m7",
        title: "Jagung",
        carbs: 7.4,
        proteins: 2.2,
        fats: 0.1,
        calories: 35),
    Food(
        id: "m8",
        title: "Ikan Mas",
        carbs: 0,
        proteins: 15,
        fats: 2,
        calories: 86),
    Food(
        id: "m9",
        title: "Empal",
        carbs: 10,
        proteins: 36.2,
        fats: 6.9,
        calories: 248),
    Food(
        id: "m10",
        title: "Bayam",
        carbs: 2.9,
        proteins: 0.9,
        fats: 0.4,
        calories: 16),
    Food(
        id: "m11",
        title: "Alpukat",
        carbs: 7.7,
        proteins: 0.9,
        fats: 6.5,
        calories: 85),
    Food(
        id: "m12",
        title: "Buah Naga",
        carbs: 9.1,
        proteins: 1.7,
        fats: 3.1,
        calories: 71),
    Food(
        id: "m13",
        title: "Gulai Kambing",
        carbs: 6.2,
        proteins: 4.2,
        fats: 9.4,
        calories: 126),
    Food(
        id: "m14",
        title: "Ikan Mujaer",
        carbs: 0,
        proteins: 18.7,
        fats: 1,
        calories: 89),
    Food(
        id: "m15",
        title: "Bihun",
        carbs: 80.3,
        proteins: 6.1,
        fats: 3.9,
        calories: 381),
    Food(
        id: "m16",
        title: "Ikan Teri",
        carbs: 4.1,
        proteins: 10.3,
        fats: 14,
        calories: 74),
    Food(
        id: "m17",
        title: "Ikan Gurame",
        carbs: 12.7,
        proteins: 12.7,
        fats: 10,
        calories: 192),
    Food(
        id: "m18",
        title: "Ikan Kakap",
        carbs: 0,
        proteins: 20,
        fats: 0.7,
        calories: 92),
    Food(
        id: "m19",
        title: "Capcay",
        carbs: 4.2,
        proteins: 5.8,
        fats: 6.3,
        calories: 97),
    Food(
        id: "m20",
        title: "Beef Burger",
        carbs: 32.5,
        proteins: 10.6,
        fats: 9.5,
        calories: 258),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff273248),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: loadedFood.length,
        itemBuilder: (ctx, i) => FoodItem(loadedFood[i].id, loadedFood[i].title, loadedFood[i].calories),
    ));
  }
}
