import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:foodrecipe/api/loginchecker.dart';
import 'package:foodrecipe/provider/user_provider.dart';
import 'package:foodrecipe/screens/login_screen.dart';
import 'package:foodrecipe/utils/colortable.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_bottom_navigation_action_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  int _selectedIndex = 4;
  bool _isLoggedIn = false; // 로그인 상태를 저장할 변수

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // initState에서 로그인 상태 확인
  }

  // 로그인 상태 확인 메서드
  Future<void> _checkLoginStatus() async {
    LoginChecker loginChecker = LoginChecker();
    bool isLoggedIn = await loginChecker.checkLoginStatus();
    setState(() {
      _isLoggedIn = isLoggedIn;
      if (kDebugMode) {
        print('_isLoggedIn: $_isLoggedIn');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Provider.of<UserProvider>(context).isLoggedIn;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('설정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.question_answer_outlined),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('1:1 문의'),
              onTap: _sendEmail,
            ),
            const SizedBox(height: 10), // 간격 조정
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('개인정보 처리방침'),
              onTap: () {
                launch(
                    "https://sites.google.com/view/mooddiaryprivacy/%ED%99%88");
              },
            ),
            const SizedBox(height: 10), // 간격 조정
            const ListTile(
              leading: Icon(Icons.info_outline),
              trailing: Text(
                '1.0',
                style: TextStyle(fontSize: 15),
              ),
              title: Text('버전 정보'),
            ),
            const SizedBox(height: 10),
            if (_isLoggedIn) // 로그인 상태에 따라 UI 조건부 렌더링
              ListTile(
                leading: const Icon(Icons.logout),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  LoginChecker loginChecker = LoginChecker();
                  if (await loginChecker.checkGoogleLoginStatus()) {
                    await GoogleSignIn().signOut(); // 구글 로그아웃
                  } else if (await loginChecker.checkKakaoLoginStatus()) {
                    await UserApi.instance.logout(); // 카카오 로그아웃
                  }
                 // Firebase Auth 로그아웃 추가

                  // 사용자 관련 상태 초기화 (예시)
                  Provider.of<UserProvider>(context, listen: false).clearUser(); // 가정: UserProvider에 clearUser 메서드가 있다고 가정

                  setState(() {
                    _isLoggedIn = false;
                  });
                },

                title: const Text('로그아웃'),
              )
            else
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  elevation: MaterialStateProperty.all<double>(10),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.green),
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(
                      color: selectedcolor1, // 테두리 색상 지정
                      width: 7.0, // 테두리 두께 조절
                    ),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 조절
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(builder: (context) =>  const LoginScreen()),
                  );
                },
                child: const Text(
                  '간편 로그인',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            const SizedBox(height: 20), // 간격 조정
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  void _sendEmail() async {
    final Email email = Email(
      body: '',
      subject: '[요리레시피 문의하기]',
      recipients: ['zau223@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
