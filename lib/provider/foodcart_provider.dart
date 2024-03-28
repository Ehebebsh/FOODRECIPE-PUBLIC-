import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // flutter 패키지를 함께 import합니다.

class FoodCartProvider extends ChangeNotifier {
  Set<String> _selectedIngredients = {};

  Set<String> get selectedIngredients => _selectedIngredients;

  void toggleIngredient(String ingredient) {
    if (_selectedIngredients.contains(ingredient)) {
      _selectedIngredients.remove(ingredient);
    } else {
      _selectedIngredients.add(ingredient);
    }
    notifyListeners();
  }

  void clearSelectedIngredients() {
    _selectedIngredients.clear();
    notifyListeners();
  }

  void setSelectedIngredients(Set<String> ingredients) {
    _selectedIngredients.addAll(ingredients);
    notifyListeners();
  }

}
