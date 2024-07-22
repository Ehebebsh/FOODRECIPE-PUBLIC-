import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookMarkProvider extends ChangeNotifier {
  final List<String> _favorites = [];
  bool _isLoading = false;
  Map<String, DateTime> _favoriteTimes = {}; // 각 즐겨찾기 항목의 추가된 시간을 저장하는 맵

  BookMarkProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loadFavoritesFromFirestore();
      } else {
        _favorites.clear();
        _favoriteTimes.clear(); // 로그아웃 시 즐겨찾기 목록과 시간 초기화
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
      _favoriteTimes.remove(foodName); // 즐겨찾기 제거 시 시간도 함께 제거
    } else {
      _favorites.add(foodName);
      _favoriteTimes[foodName] = DateTime.now(); // 즐겨찾기 추가 시 현재 시간 저장
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
      }
    } catch (error) {
      throw error;
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

            // 즐겨찾기 목록을 불러올 때 각 항목의 추가된 시간도 함께 가져옴
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
      throw error;
    } finally {
      isLoading = false;
    }
  }

  // 즐겨찾기한 항목의 추가된 시간을 반환하는 메서드
  DateTime getFavoriteTime(String foodName) {
    if (_favoriteTimes.containsKey(foodName)) {
      return _favoriteTimes[foodName]!;
    } else {
      // 만약 해당 음식이 즐겨찾기 목록에 없다면 기본값인 현재 시간 반환
      return DateTime.now();
    }
  }
}