import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/screens/home_screen.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:provider/provider.dart';
import '../api/kakao_login.dart';
import '../models/userfirestoreservice.dart';
import '../provider/user_provider.dart';

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleLoginButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.white, // 버튼 색상 변경
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 만듦
      ),
      child: SizedBox( // 버튼 크기를 조정하기 위해 SizedBox로 감싸기
        height: 50, // 버튼의 높이 설정
        width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%로 설정
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox( // 이미지를 표시하기 위해 SizedBox로 감싸기
              width: MediaQuery.of(context).size.width * 0.1, // 화면 너비의 10%로 설정
              height: MediaQuery.of(context).size.width * 0.1, // 화면 너비의 10%로 설정
              child: Image.asset('assets/googleicon.png'), // 이미지 추가
            ),
            const SizedBox(width: 10), // 이미지와 텍스트 사이의 간격 조정
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.13), // 왼쪽 패딩 추가
              child: const Text(
                'Google로 시작하기',
                style: TextStyle(
                  fontSize: 18,
                ),
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
    final UserFirestoreService _userFirestoreService = UserFirestoreService();
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
        try {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            await _userFirestoreService.saveUserData(user);
            if (kDebugMode) {
              print('사용자 정보 저장 성공');
            }
          } else {
            if (kDebugMode) {
              print('사용자 정보 저장 실패: 사용자가 로그인되어 있지 않음');
            }
          }
        } catch (error) {
          if (kDebugMode) {
            print('사용자 정보 저장 실패: $error');
          }
        }
      },
      color: Color(0xFFFEE500), // 카카오 컬러로 변경 가능
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.grey),
      ),
      child: SizedBox( // 버튼 크기를 조정하기 위해 SizedBox로 감싸기
        height: 50, // 버튼의 높이 설정
        width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%로 설정
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox( // 이미지를 표시하기 위해 SizedBox로 감싸기
              width: MediaQuery.of(context).size.width * 0.1, // 화면 너비의 10%로 설정
              height: MediaQuery.of(context).size.width * 0.1, // 화면 너비의 10%로 설정
              child: Image.asset('assets/kakaologo.png'), // 이미지 추가
            ),
            const SizedBox(width: 10), // 이미지와 텍스트 사이의 간격 조정
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.13), // 왼쪽 패딩 추가
              child: const Text(
                'Kakao로 시작하기',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
