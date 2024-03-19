// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../widgets/categorybutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 각 아이템에 해당하는 페이지로 이동
    switch(index) {
      case 0:
      // '홈' 아이템을 눌렀을 때의 동작
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
      // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('요리앱'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 요리 종류 텍스트 왼쪽 정렬
          children: <Widget>[
            Image.network(
              'https://via.placeholder.com/700', // 원하는 이미지 URL 교체
              width: MediaQuery.of(context).size.width, // 화면의 가로 너비로 설정
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
              child: Text(
                '요리 종류',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryButton(
                  imageUrl: 'https://via.placeholder.com/150',
                  buttonText: '한식',
                  onPressed: () {
                    // 한식 페이지로 이동하는 코드 추가
                  },
                ),
                CategoryButton(
                  imageUrl: 'https://via.placeholder.com/150',
                  buttonText: '중식',
                  onPressed: () {
                    // 중식 페이지로 이동하는 코드 추가
                  },
                ),
                CategoryButton(
                  imageUrl: 'https://via.placeholder.com/150',
                  buttonText: '양식',
                  onPressed: () {
                    // 양식 페이지로 이동하는 코드 추가
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
              child: Text(
                '손쉽게 할 수 있는 요리',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120, // 그리드뷰 높이 설정
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12), // 원하는 둥글기 정도 조절
                      child: SizedBox(
                        width: 120,
                        child: Image.network(
                          'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0), // 좌우 여백 추가
              child: Text(
                '당신의 요리 솜씨를 뽐내보세요!',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120, // 그리드뷰 높이 설정
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12), // 원하는 둥글기 정도 조절
                      child: SizedBox(
                        width: 120,
                        child: Image.network(
                          'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
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
}
