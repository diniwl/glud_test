import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double calories;
  final double carbs;
  final double proteins;
  final double fats;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.calories,
    required this.carbs,
    required this.proteins,
    required this.fats,
    
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
