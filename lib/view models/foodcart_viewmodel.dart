import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodCartProvider extends ChangeNotifier {
  final Set<String> _selectedIngredients = {};
  bool _isLoading = false;

  Set<String> get selectedIngredients => _selectedIngredients;
  bool get isLoading => _isLoading;

  FoodCartProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loadSelectedIngredients(user.uid);
      } else {
        clearSelectedIngredients();
      }
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> toggleIngredient(String ingredient) async {
    _setLoading(true);
    if (_selectedIngredients.contains(ingredient)) {
      _selectedIngredients.remove(ingredient);
    } else {
      _selectedIngredients.add(ingredient);
    }
    notifyListeners();
    await saveSelectedIngredientsToFirestore();
    _setLoading(false);
  }

  Future<void> clearSelectedIngredients() async {
    _setLoading(true);
    _selectedIngredients.clear();
    notifyListeners();
    await saveSelectedIngredientsToFirestore();
    _setLoading(false);
  }

  Future<void> setSelectedIngredients(Set<String> ingredients) async {
    _setLoading(true);
    _selectedIngredients.addAll(ingredients);
    notifyListeners();
    await saveSelectedIngredientsToFirestore();
    _setLoading(false);
  }

  Future<void> removeIngredient(String ingredient) async {
    _setLoading(true);
    _selectedIngredients.remove(ingredient);
    notifyListeners();
    await saveSelectedIngredientsToFirestore();
    _setLoading(false);
  }

  Future<void> loadSelectedIngredients(String userId) async {
    _setLoading(true); // 로딩 시작
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('selectedIngredients')) {
          _selectedIngredients.clear();
          _selectedIngredients.addAll(List<String>.from(data['selectedIngredients']));
          notifyListeners();
        }
      }
    } catch (error) {
      throw error;
    } finally {
      _setLoading(false); // 로딩 완료
    }
  }

  Future<void> saveSelectedIngredientsToFirestore() async {
    _setLoading(true); // 데이터 저장 시작
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({
          'selectedIngredients': _selectedIngredients.toList(),
        }, SetOptions(merge: true));
      }
    } catch (error) {
      throw error;
    } finally {
      _setLoading(false); // 데이터 저장 완료
    }
  }

  // New method to parse and set ingredients
  Future<void> parseAndSetIngredients(List<dynamic> ingredients) async {
    final parsedIngredients = ingredients
        .where((ingredient) =>
    ingredient.toString().contains(', ') &&
        ingredient.toString().split(', ').last.isNotEmpty)
        .map<String>((ingredient) =>
    ingredient.toString().split(', ').last)
        .toSet();
    await setSelectedIngredients(parsedIngredients);
  }
}
