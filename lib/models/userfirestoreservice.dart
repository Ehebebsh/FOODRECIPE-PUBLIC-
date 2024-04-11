import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestoreService {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUserData(User user) async {
    try {
      await _usersCollection.doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        // 필요에 따라 추가 사용자 정보 저장
      });
      print('사용자 정보 Firestore에 저장 완료');
    } catch (error) {
      print('사용자 정보 Firestore 저장 실패: $error');
      // 실패 시 적절한 처리
      throw error;
    }
  }
}
