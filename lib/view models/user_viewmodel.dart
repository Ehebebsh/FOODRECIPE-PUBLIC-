import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';


class UserViewModel extends ChangeNotifier {
  Future<bool> checkLoginStatus(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Provider.of<UserProvider>(context, listen: false).setUser(currentUser);
      return true; // 로그인 상태일 경우 true 반환
    } else {
      return false; // 로그인 상태가 아닐 경우 false 반환
    }
  }
}
