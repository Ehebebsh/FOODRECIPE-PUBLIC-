import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodCartProvider extends ChangeNotifier {
  final Set<String> _selectedIngredients = {};

  Set<String> get selectedIngredients => _selectedIngredients;

  FoodCartProvider() {
    loadSelectedIngredients();
  }

  Future<void> toggleIngredient(String ingredient) async {
    if (_selectedIngredients.contains(ingredient)) {
      _selectedIngredients.remove(ingredient);
    } else {
      _selectedIngredients.add(ingredient);
    }
    notifyListeners();
    await saveSelectedIngredients();
  }

  Future<void> clearSelectedIngredients() async {
    _selectedIngredients.clear();
    notifyListeners();
    await saveSelectedIngredients();
  }

  Future<void> setSelectedIngredients(Set<String> ingredients) async {
    _selectedIngredients.addAll(ingredients);
    notifyListeners();
    await saveSelectedIngredients();
  }

  Future<void> removeIngredient(String ingredient) async {
    _selectedIngredients.remove(ingredient);
    notifyListeners();
    await saveSelectedIngredients();
  }

  Future<void> saveSelectedIngredients() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedIngredients', _selectedIngredients.toList());
  }

  Future<void> loadSelectedIngredients() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? ingredientsList = prefs.getStringList('selectedIngredients');
    if (ingredientsList != null) {
      _selectedIngredients.clear();
      _selectedIngredients.addAll(ingredientsList);
      notifyListeners();
    }
  }//여기는 이제 앱시작할때 로드시킨다고 했느네 일단 안쓰고있음
}
