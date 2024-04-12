import 'dart:convert';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:foodrecipe/widgets/custom_bottom_navigation_action_widget.dart';
import 'package:foodrecipe/screens/food_detail_screen.dart';
import '../api/loginchecker.dart';
import '../utils/colortable.dart';
import '../widgets/custom_pageroute_widget.dart';
import 'login_screen.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({Key? key}) : super(key: key);

  @override
  BookMarkPageState createState() => BookMarkPageState();
}

class BookMarkPageState extends State<BookMarkPage> {
  int _selectedIndex = 2;
  bool _isLoggedIn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    bool isLoggedIn = await LoginChecker().checkLoginStatus();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
    loadFavoriteFoods();
  }

  Future<void> loadFavoriteFoods() async {
    await Future.delayed(Duration(seconds: 1)); // 2초 지연
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var favoritesProvider = Provider.of<BookMarkProvider>(context);
    var favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('즐겨찾기 목록'),
      ),
      body: _isLoggedIn
          ? _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
        future: Future.wait([
          DefaultAssetBundle.of(context).loadString('assets/koreafood_data.json'),
          DefaultAssetBundle.of(context).loadString('assets/chinesefood_data.json'),
          DefaultAssetBundle.of(context).loadString('assets/westernfood_data.json'),
          DefaultAssetBundle.of(context).loadString('assets/easyfood.json'),
          DefaultAssetBundle.of(context).loadString('assets/hardfood.json'),
        ]),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> koreanFoodList = json.decode(snapshot.data![0]);
            List<dynamic> chineseFoodList = json.decode(snapshot.data![1]);
            List<dynamic> westernfoodList = json.decode(snapshot.data![2]);
            List<dynamic> easyfoodList = json.decode(snapshot.data![3]);
            List<dynamic> hardfoodList = json.decode(snapshot.data![4]);

            List<dynamic> combinedFoodList = [
              ...koreanFoodList,
              ...chineseFoodList,
              ...westernfoodList,
              ...easyfoodList,
              ...hardfoodList
            ];

            // 중복된 음식 이름 제거
            Set<String> uniqueNames = {};
            List<dynamic> favoriteFoods = combinedFoodList
                .where((food) => favorites.contains(food['name']))
                .where((food) => uniqueNames.add(food['name']))
                .toList();

            if (favoriteFoods.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '즐겨찾기한 음식이 없습니다.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                var foodData = favoriteFoods[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // 여기서 배경색을 설정합니다.
                    borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 처리합니다.
                  ),
                  child: ListTile(
                    title: Text(foodData['name']),
                    subtitle: Text(foodData['tags'].join(', ')),
                    leading: Image.asset(foodData['image']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodDetailPage(foodData: foodData),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.star, color: Colors.yellow),
                      onPressed: () {
                        favoritesProvider.toggleFavorite(foodData['name']);
                        // 즐겨찾기 취소 안내 토스트 메시지 표시
                        CherryToast.delete(
                          animationType: AnimationType.fromTop,
                          title: Text('${foodData['name']} 즐겨찾기가 취소되었습니다.'),
                        ).show(context);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '로그인하여 즐겨찾기를 이용해보세요!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all<double>(10),
                shadowColor: MaterialStateProperty.all<Color>(Colors.green),
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
                    color: selectedcolor1, // 테두리 색상 지정
                    width: 7.0, // 테두리 두께 조절
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CustomPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('로그인', style: TextStyle(color: Colors.black)),
            ),
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
}
