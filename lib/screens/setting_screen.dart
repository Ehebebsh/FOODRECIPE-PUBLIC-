import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custombottomnavigationaction_widget.dart';

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
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('설정'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.question_answer_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('1:1 문의'),
            onTap: _sendEmail,
          ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: const Text('개인정보 처리방침'),
            onTap: () {
              launch("https://sites.google.com/view/mooddiaryprivacy/%ED%99%88");
            },
          ),
          const SizedBox(height: 5),
          const ListTile(
            leading: Icon(Icons.info_outline),
            trailing: Text(
              '1.0',
              style: TextStyle(fontSize: 15),
            ),
            title: Text('버전 정보'),
          ),
        ],
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
