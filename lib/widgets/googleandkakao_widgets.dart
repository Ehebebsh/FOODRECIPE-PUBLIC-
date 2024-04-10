import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/screens/home_screen.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import '../api/kakao_login.dart';

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleLoginButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.grey),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Colors.red, // 구글 컬러로 변경 가능
            ),
            SizedBox(width: 10),
            Text(
              '구글 로그인',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const KakaoLoginButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        bool loginSuccess = await KakaoLogin().login();
        if (loginSuccess) {
          String? userName = await KakaoLogin().getUserName();
          print('카카오 사용자 닉네임: $userName');
          // Kakao 로그인 성공 시 SettingPage로 이동하고 이전 화면 제거
          Navigator.pushAndRemoveUntil(
            context,
            CustomPageRoute(builder: (context) => const HomePage()),
                (route) => false,
          );
          CherryToast.success(
            animationType: AnimationType.fromTop,
            title: Text('$userName님 환영합니다.'),
          ).show(context);
        } else {
          print("Kakao 로그인 실패");
        }
      },
      color: Colors.yellow, // 카카오 컬러로 변경 가능
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.grey),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: Colors.black, // 카카오 컬러로 변경 가능
            ),
            SizedBox(width: 10),
            Text(
              '카카오 로그인',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
