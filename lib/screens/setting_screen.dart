import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:foodrecipe/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_bottom_navigation_action_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('설정'),
      ),
      body: SingleChildScrollView( // 화면이 넘칠 경우 스크롤 가능하도록 변경
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
                launch("https://sites.google.com/view/mooddiaryprivacy/%ED%99%88");
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
            const SizedBox(height: 20), // 간격 조정
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // 버튼 배경색 변경
                padding: const EdgeInsets.symmetric(vertical: 15), // 버튼 내부 padding 조정
                shape: RoundedRectangleBorder( // 버튼 모서리 둥글게 변경
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
