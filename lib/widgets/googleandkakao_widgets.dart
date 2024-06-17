import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/screens/home_screen.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../api/kakao_login.dart';
import '../models/userfirestoreservice.dart';
import '../provider/user_provider.dart';

class GoogleLoginButton extends StatelessWidget {

  const GoogleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: () async { // 여기에 로그인 로직 구현
          try {
            // 구글 로그인 시도
            final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
            if (googleUser == null) {
              throw Exception('구글 로그인에 실패했습니다.');
            }

            // 구글에서 인증 정보 가져오기
            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            final OAuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            // Firebase에 인증 및 사용자 생성
            final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

            // 사용자 인증 성공
            final User? user = userCredential.user;
            if (kDebugMode) {
              print('Firebase 사용자 인증 성공: ${user?.displayName}');
            }

            // Firebase 현재 사용자 정보 가져오기 및 사용자 정보 저장 시도
            try {
              User? currentUser = FirebaseAuth.instance.currentUser;

              if (currentUser != null) {
                Provider.of<UserProvider>(context, listen: false).setUser(currentUser);
                await UserFirestoreService().saveUserData(currentUser);
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

            Navigator.pushAndRemoveUntil(
              context,
              CustomPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );

            CherryToast.success(
              animationType: AnimationType.fromTop,
              title: Text('${user?.displayName}님 환영합니다.'),
            ).show(context);

          } catch (error) {
            // 실패 시 처리
            if (kDebugMode) {
              print('Firebase 사용자 인증 실패: $error');
            }
            // 실패 시 사용자에게 알림을 제공하는 등의 추가 처리 가능
          }
        },
      color: Colors.white, // 버튼 색상 변경
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 만듦
      ),
      child: SizedBox( // 버튼 크기를 조정하기 위해 SizedBox로 감싸기
        height: 50, // 버튼의 높이 설정
        width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%로 설정
        child: Row(
          children: [
            SizedBox( // 이미지를 표시하기 위해 SizedBox로 감싸기
              width: MediaQuery.of(context).size.width * 0.1, // 화면 너비의 10%로 설정
              height: MediaQuery.of(context).size.width * 0.1, // 화면 너비의 10%로 설정
              child: Image.asset('assets/googleicon.png'), // 이미지 추가
            ),
            Expanded(
              child: Center( // 텍스트를 가운데 정렬
                child: Text(
                  'Google로 시작하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
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

  const KakaoLoginButton({Key? key}) : super(key: key); // 생성자 수정

  @override
  Widget build(BuildContext context) {
    final UserFirestoreService userFirestoreService = UserFirestoreService();
    return MaterialButton(
      onPressed: () async { // 여기서부터 직접 로직 구현
        bool loginSuccess = await KakaoLogin().login();
        if (loginSuccess) {
          String? userName = await KakaoLogin().getUserName();
          print('카카오 사용자 닉네임: $userName');
          // Kakao 로그인 성공 시 HomePage로 이동하고 이전 화면 제거
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
            await userFirestoreService.saveUserData(user);
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
      color: const Color(0xFFFEE500), // 카카오 컬러로 변경 가능
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.grey),
      ),
      child: SizedBox( // 버튼 크기를 조정하기 위해 SizedBox로 감싸기
        height: 50, // 버튼의 높이 설정
        width: MediaQuery.of(context).size.width * 0.8, // 화면 너비의 80%로 설정
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // 요소들을 시작 위치에서 정렬
          children: [
            SizedBox( // 이미지를 표시하기 위해 SizedBox로 감싸기
              width: MediaQuery.of(context).size.width * 0.1, // 화면 너비의 10%로 설정
              height: MediaQuery.of(context).size.width * 0.1, // 화면 너비의 10%로 설정
              child: Image.asset('assets/kakaologo.png'), // 이미지 추가
            ),
            Expanded(
              child: Center( // 텍스트를 가운데 정렬
                child: Text(
                  'Kakao로 시작하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

