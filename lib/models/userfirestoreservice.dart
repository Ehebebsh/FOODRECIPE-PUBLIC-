import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestoreService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUserDataWithFavorites(
      User user, List<String> favorites) async {
    try {

      await _usersCollection.doc(user.uid).set({
        'favorites': favorites,
      });

    } catch (error) {

      throw error;
    }
  }

  Future<void> saveUserData(User user) async {
    try {
      final docSnapshot = await _usersCollection.doc(user.uid).get();

      if (docSnapshot.exists) {
        await _usersCollection.doc(user.uid).update({
          'name': user.displayName,
          'email': user.email,
        });
      } else {
        // 문서가 존재하지 않으면 새로운 문서 생성
        await _usersCollection.doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
        });
      }
    } catch (error) {
      throw error;
    }
  }
}
