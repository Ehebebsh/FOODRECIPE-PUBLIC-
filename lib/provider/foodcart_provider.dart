import 'package:flutter/foundation.dart';

class FoodCartProvider extends ChangeNotifier {
  Set<String> _selectedIngredients = {}; // 수정: selectedIngredients를 외부에서 직접 수정할 수 있도록 변경

  Set<String> get selectedIngredients => _selectedIngredients; // 수정: _selectedIngredients를 외부에서 읽을 수 있도록 변경

  void toggleIngredient(String ingredient) {
    if (_selectedIngredients.contains(ingredient)) {
      _selectedIngredients.remove(ingredient);
    } else {
      _selectedIngredients.add(ingredient);
    }
    notifyListeners();
    debugPrint('저장된 재료: $_selectedIngredients');
  }

  void clearSelectedIngredients() {
    _selectedIngredients.clear();
    notifyListeners();
  }

  // setSelectedIngredients 메소드 추가
  void setSelectedIngredients(Set<String> ingredients) {
    _selectedIngredients = ingredients.toSet(); // 수정: 새로운 Set을 할당하여 _selectedIngredients를 업데이트
    notifyListeners();
  }
}
