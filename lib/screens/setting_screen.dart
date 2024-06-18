import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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


  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // initState에서 로그인 상태 확인
  }

  // 로그인 상태 확인 메서드
  Future<void> checkLoginStatus() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    await Future.delayed(Duration.zero, () {
      Provider.of<UserProvider>(context, listen: false).setUser(currentUser);
    });
  }



  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    bool isLoggedIn = userProvider.isLoggedIn;

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
                    "https://sites.google.com/view/myfoodrecipe/%ED%99%88");
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
            if (isLoggedIn)
              ListTile(
                leading: const Icon(Icons.logout),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  LoginChecker loginChecker = LoginChecker();
                  if (await loginChecker.checkGoogleLoginStatus()) {
                    await GoogleSignIn().signOut();
                  } else if (await loginChecker.checkKakaoLoginStatus()) {
                    await UserApi.instance.logout();
                  }
                  Provider.of<UserProvider>(context, listen: false).clearUser();
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

class LoginChecker {
  Future<bool> checkKakaoLoginStatus() async {
    try {
      await UserApi.instance.accessTokenInfo();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkGoogleLoginStatus() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    bool isSignedIn = await googleSignIn.isSignedIn();
    return isSignedIn;
  }

  Future<bool> checkLoginStatus() async {
    bool isGoogleLoggedIn = await checkGoogleLoginStatus();
    bool isKakaoLoggedIn = await checkKakaoLoginStatus();
    return isGoogleLoggedIn || isKakaoLoggedIn;
  }
}
