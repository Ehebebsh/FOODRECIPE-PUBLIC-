import 'package:flutter/material.dart';

import '../widgets/googleandkakao_widgets.dart';


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
            onPressed: () {
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
