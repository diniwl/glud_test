import 'package:flutter/foundation.dart';

class Food {
  final String id;
  final String title;
  final double carbs;
  final double proteins;
  final double fats;
  final double calories;
  bool isSelected;

  Food({
    required this.id, 
    required this.title, 
    required this.carbs, 
    required this.proteins, 
    required this.fats, 
    required this.calories,
    this.isSelected = false,
    });
}