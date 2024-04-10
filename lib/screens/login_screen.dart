import 'package:flutter/material.dart';

import '../api/kakao_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          _buildGoogleLoginButton(),
          const SizedBox(height: 10),
          _buildKakaoLoginButton(),
        ],
      ),
    );
  }

  Widget _buildGoogleLoginButton() {
    return MaterialButton(
      onPressed: () {
        // TODO: 구글 로그인 기능 구현
      },
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

  Widget _buildKakaoLoginButton() {
    return MaterialButton(
      onPressed: () async {
        bool loginSuccess = await KakaoLogin().login();
        if(loginSuccess){
          print('success');
        }
        else(){
          print("fail");
        };
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
