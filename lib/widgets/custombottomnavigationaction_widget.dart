import 'package:flutter/material.dart';
import 'package:foodrecipe/screens/setting_screen.dart';
import '../screens/home_screen.dart';

class BottomNavigator extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigator({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  void _navigateToIndex(BuildContext context, int index) {
    switch(index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SettingPage()),
              (route) => false,
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
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
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _navigateToIndex(context, index), // 수정된 부분입니다.
    );
  }
}
