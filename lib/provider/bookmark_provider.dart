import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookMarkProvider extends ChangeNotifier {
  final List<String> _favorites = [];
  bool _isLoading = false;
  final Map<String, DateTime> _favoriteTimes = {};

  BookMarkProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loadFavoritesFromFirestore();
      } else {
        _favorites.clear();
        _favoriteTimes.clear();
        notifyListeners();
      }
    });
  }

  List<String> get favorites => _favorites;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void toggleFavorite(String foodName) async {
    if (_favorites.contains(foodName)) {
      _favorites.remove(foodName);
      _favoriteTimes.remove(foodName);
    } else {
      _favorites.add(foodName);
      _favoriteTimes[foodName] = DateTime.now();
    }
    debugPrint('Favorites: $_favorites');
    await saveFavoritesToFirestore();
    notifyListeners();
  }

  Future<void> saveFavoritesToFirestore() async {
    try {
      isLoading = true;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
        await userCollection.doc(user.uid).set({
          'favorites': _favorites,
        }, SetOptions(merge: true));

        print('즐겨찾기 목록 Firestore에 저장 완료');
      }
    } catch (error) {
      print('즐겨찾기 목록 Firestore 저장 실패: $error');
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> loadFavoritesFromFirestore() async {
    try {
      isLoading = true;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          final Map<String, dynamic>? userData =
          snapshot.data() as Map<String, dynamic>?;

          if (userData != null && userData.containsKey('favorites')) {
            _favorites.clear();
            _favorites.addAll(List<String>.from(userData['favorites']));

            _favoriteTimes.clear();
            userData['favorites'].forEach((foodName) {
              if (userData.containsKey('$foodName-time')) {
                _favoriteTimes[foodName] = DateTime.parse(userData['$foodName-time']);
              } else {
                _favoriteTimes[foodName] = DateTime.now();
              }
            });

            notifyListeners();
          }
        }
      }
    } catch (error) {
      print('Firestore에서 즐겨찾기 목록 로드 실패: $error');
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  DateTime getFavoriteTime(String foodName) {
    if (_favoriteTimes.containsKey(foodName)) {
      return _favoriteTimes[foodName]!;
    } else {
      return DateTime.now();
    }
  }
}
