import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookMarkProvider extends ChangeNotifier {
  final List<String> _favorites = [];

  BookMarkProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // 사용자가 로그인한 경우 Firestore에서 사용자의 즐겨찾기 목록을 다시 로드
        loadFavoritesFromFirestore();
      } else {
        // 사용자가 로그아웃한 경우 즐겨찾기 목록 초기화
        _favorites.clear();
        notifyListeners();
      }
    });
  }

  List<String> get favorites => _favorites;

  void toggleFavorite(String foodName) async {
    if (_favorites.contains(foodName)) {
      _favorites.remove(foodName);
    } else {
      _favorites.add(foodName);
    }
    debugPrint('Favorites: $_favorites');
    await saveFavoritesToFirestore(); // Firestore에도 변경사항을 저장합니다.
    notifyListeners(); // 데이터가 변경됨을 알립니다.
  }

  Future<void> saveFavoritesToFirestore() async {
    try {
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
      throw error;
    }
  }

  Future<void> loadFavoritesFromFirestore() async {
    try {
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
            notifyListeners(); // 데이터가 변경됨을 알립니다.
          }
        }
      }
    } catch (error) {
      print('Firestore에서 즐겨찾기 목록 로드 실패: $error');
      throw error;
    }
  }
}
