import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodCartProvider extends ChangeNotifier {
  final Set<String> _selectedIngredients = {};

  Set<String> get selectedIngredients => _selectedIngredients;

  FoodCartProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loadSelectedIngredients(user.uid);
      } else {
        clearSelectedIngredients();
      }
    });
  }

  Future<void> toggleIngredient(String ingredient) async {
    if (_selectedIngredients.contains(ingredient)) {
      _selectedIngredients.remove(ingredient);
    } else {
      _selectedIngredients.add(ingredient);
    }
    notifyListeners();
    await saveSelectedIngredientsToFirestore();
  }

  Future<void> clearSelectedIngredients() async {
    _selectedIngredients.clear();
    notifyListeners();
    await saveSelectedIngredientsToFirestore();
  }

  Future<void> setSelectedIngredients(Set<String> ingredients) async {
    _selectedIngredients.addAll(ingredients);
    notifyListeners();
    await saveSelectedIngredientsToFirestore();
  }

  Future<void> removeIngredient(String ingredient) async {
    _selectedIngredients.remove(ingredient);
    notifyListeners();
    await saveSelectedIngredientsToFirestore();
  }

  Future<void> loadSelectedIngredients(String userId) async {
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
      print('Error loading selected ingredients from Firestore: $error');
      throw error;
    }
  }

  Future<void> saveSelectedIngredientsToFirestore() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({
          'selectedIngredients': _selectedIngredients.toList(),
        }, SetOptions(merge: true)); // 필드를 추가하고 이미 문서가 존재하는 경우에는 덮어씁니다.
        print('Selected ingredients saved to Firestore');
      }
    } catch (error) {
      print('Error saving selected ingredients to Firestore: $error');
      throw error;
    }
  }
}
