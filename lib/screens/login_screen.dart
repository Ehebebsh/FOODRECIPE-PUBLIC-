import 'package:flutter/material.dart';
import '../widgets/googleandkakao_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50), // 이미지 위의 여백
          Image.asset(
            'assets/logo.JPG',
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '간편로그인으로 더 다양한,',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Center(
            child: Text(
              '서비스를 이용하세요!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GoogleLoginButton(
            onPressed: () async {
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
                print('Firebase 사용자 인증 성공: ${user?.displayName}');
              } catch (error) {
                // 실패 시 처리
                print('Firebase 사용자 인증 실패: $error');
                // 실패 시 사용자에게 알림을 제공하는 등의 추가 처리 가능
              }
            },
          ),
          const SizedBox(height: 10),
          KakaoLoginButton(
            onPressed: () async {
            },
          ),
        ],
      ),
    );
  }
}
