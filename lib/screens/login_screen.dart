import 'package:flutter/material.dart';
import '../widgets/googleandkakao_widgets.dart';

class LoginScreen extends StatefulWidget {
   const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
            'assets/logo.png',
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 20),
           Center(
            child: Text(
              '간편로그인으로 더 다양한,',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05, // 화면 너비의 5%를 글자 크기로 설정
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Center(
            child: Text(
              '서비스를 이용하세요!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05, // 화면 너비의 5%를 글자 크기로 설정
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 20),
          const GoogleLoginButton(),
          const SizedBox(height: 10),
          const KakaoLoginButton(),
        ],
      ),
    );
  }
}
