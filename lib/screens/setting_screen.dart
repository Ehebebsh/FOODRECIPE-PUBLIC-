import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:foodrecipe/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  int _selectedIndex = 0;
  bool canPop = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 각 아이템에 해당하는 페이지로 이동
    switch(index) {
      case 0:

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
      // '음식' 아이템을 눌렀을 때의 동작
      // Navigator.push(context, MaterialPageRoute(builder: (context) => FoodPage()));
        break;
      case 2:
      // '검색' 아이템을 눌렀을 때의 동작
      // Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
        break;
      case 3:
      // '즐겨찾기' 아이템을 눌렀을 때의 동작
      // Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkPage()));
        break;
      case 4:
      // '설정' 아이템을 눌렀을 때의 동작
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,),
      body:  WillPopScope(
        onWillPop: () async => canPop,
        child: Column(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu), // 음식 아이콘 추가
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '즐겨찾기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
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

