import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('설정',
           style: TextStyle(fontSize: 25), ),
          ),
          Divider(
            thickness: 20,
            color: Color.fromRGBO(243, 244, 249, 1),
          ), // 구분선 추가
          ListTile(
            leading: Icon(Icons.question_answer_outlined),
            trailing: Icon(Icons.arrow_forward_ios),
            title: Text('1:1 문의'),
            onTap: _sendEmail

          ),
         SizedBox(
           height: 5,
         ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            trailing: Icon(Icons.arrow_forward_ios),
            title: Text('개인정보 처리방침'),
            onTap: () {
              launch("https://sites.google.com/view/mooddiaryprivacy/%ED%99%88");
            },
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            trailing: Text('1.0',
            style: TextStyle(fontSize: 15),),
            title: Text('버전 정보'),
          ),
        ],
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

