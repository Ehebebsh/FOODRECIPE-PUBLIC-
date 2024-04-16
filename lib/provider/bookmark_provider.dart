import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookMarkProvider extends ChangeNotifier {
  final List<String> _favorites = [];
  bool _isLoading = false; // 로딩 상태 변수 추가

  BookMarkProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        loadFavoritesFromFirestore();
      } else {
        _favorites.clear();
        notifyListeners();
      }
    });
  }

  List<String> get favorites => _favorites;
  bool get isLoading => _isLoading; // 로딩 상태 변수의 게터 추가

  set isLoading(bool value) { // 로딩 상태 변수의 세터 추가
    _isLoading = value;
    notifyListeners();
  }

  void toggleFavorite(String foodName) async {
    if (_favorites.contains(foodName)) {
      _favorites.remove(foodName);
    } else {
      _favorites.add(foodName);
    }
    debugPrint('Favorites: $_favorites');
    await saveFavoritesToFirestore();
    notifyListeners();
  }

  Future<void> saveFavoritesToFirestore() async {
    try {
      isLoading = true; // 로딩 시작
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
    } finally {
      isLoading = false; // 로딩 종료
    }
  }

  Future<void> loadFavoritesFromFirestore() async {
    try {
      isLoading = true; // 로딩 시작
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
            notifyListeners();
          }
        }
      }
    } catch (error) {
      print('Firestore에서 즐겨찾기 목록 로드 실패: $error');
      throw error;
    } finally {
      isLoading = false; // 로딩 종료
    }
  }
}
