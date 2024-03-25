import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkProvider extends ChangeNotifier {
  final List<String> _favorites = [];

  BookMarkProvider() {
    loadFavorites();
  }

  List<String> get favorites => _favorites;

  void toggleFavorite(String foodName) async {
    if (_favorites.contains(foodName)) {
      _favorites.remove(foodName);
    } else {
      _favorites.add(foodName);
    }
    debugPrint('Favorites: $_favorites');
    await saveFavorites(); // 변경사항을 저장합니다.
    notifyListeners(); // 데이터가 변경됨을 알립니다.
  }

  // SharedPreferences를 사용하여 즐겨찾기 목록을 저장합니다.
  Future<void> saveFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
  }

  // SharedPreferences에서 즐겨찾기 목록을 로드합니다.
  Future<void> loadFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? loadedFavorites = prefs.getStringList('favorites');
    if (loadedFavorites != null) {
      _favorites.clear();
      _favorites.addAll(loadedFavorites);
      notifyListeners(); // 데이터가 변경됨을 알립니다.
    }
  }
}
