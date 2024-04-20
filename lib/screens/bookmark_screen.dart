import 'dart:convert';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:foodrecipe/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:foodrecipe/widgets/custom_bottom_navigation_action_widget.dart';
import 'package:foodrecipe/screens/food_detail_screen.dart';
import '../utils/colortable.dart';
import '../widgets/custom_pageroute_widget.dart';
import 'login_screen.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  BookMarkPageState createState() => BookMarkPageState();
}

class BookMarkPageState extends State<BookMarkPage> {
  bool isLoading = true; // 로딩 상태를 관리하는 상태 변수
  int _selectedIndex = 2;
  late Future<List<dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _futureData = loadFoodData();
  }

  String addParticle(String word) {
    final lastChar = word.codeUnits.last;
    var hasJongSung = (lastChar - 44032) % 28 > 0;
    return hasJongSung ? '이' : '가';
  }

  Future<void> checkLoginStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    await Future.delayed(Duration.zero, () {
      Provider.of<UserProvider>(context, listen: false).setUser(currentUser);
      setState(() {
        isLoading = false; // 사용자 정보를 설정한 후 로딩 상태 업데이트
      });
    });
  }

  Future<List<dynamic>> loadFoodData() async {
    // 모든 JSON 데이터를 로드하여 합치는 비동기 함수입니다.
    var korean = await DefaultAssetBundle.of(context).loadString('assets/koreafood_data.json');
    var chinese = await DefaultAssetBundle.of(context).loadString('assets/chinesefood_data.json');
    var western = await DefaultAssetBundle.of(context).loadString('assets/westernfood_data.json');
    var easy = await DefaultAssetBundle.of(context).loadString('assets/easyfood.json');
    var hard = await DefaultAssetBundle.of(context).loadString('assets/hardfood.json');

    // 모든 음식 데이터를 하나의 리스트로 합칩니다.
    return [
      ...json.decode(korean),
      ...json.decode(chinese),
      ...json.decode(western),
      ...json.decode(easy),
      ...json.decode(hard),
    ];
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
      body: favoritesProvider.isLoading
          ? const Center(
          child: CircularProgressIndicator(
            color: selectedcolor1,
          ))
          : Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoggedIn) {
            return FutureBuilder<List<dynamic>>(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: selectedcolor1,
                      ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  Set<String> uniqueNames = {};
                  List<dynamic> favoriteFoods = snapshot.data!
                      .where((food) => favorites.contains(food['name']))
                      .where((food) => uniqueNames.add(food['name']))
                      .toList();

                  favoriteFoods.sort((a, b) {
                    var timeA = favoritesProvider.getFavoriteTime(a['name']);
                    var timeB = favoritesProvider.getFavoriteTime(b['name']);
                    return timeA.compareTo(timeB);
                  });

                  if (favoriteFoods.isEmpty) {
                    return const Center(
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
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(foodData['name']),
                          subtitle: Text(foodData['tags'].join(', ')),
                          leading: Container(
                            width: 80.0, // 이미지의 가로 크기를 조정합니다.
                            height: 80.0, // 이미지의 세로 크기를 조정합니다.
                            child: Image.asset(
                              foodData['image'],
                              fit: BoxFit.cover, // 이미지를 올바르게 조정합니다.
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                builder: (context) => FoodDetailPage(foodData: foodData),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.star, color: Colors.yellow),
                            onPressed: () {
                              favoritesProvider.toggleFavorite(foodData['name']);
                              CherryToast.delete(
                                animationType: AnimationType.fromTop,
                                title: Text('${foodData['name']}${addParticle(foodData['name'])} 즐겨찾기에서 취소되었습니다.'),
                              ).show(context);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '로그인하여 즐겨찾기를 이용해보세요!',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            elevation: MaterialStateProperty.all<double>(10),
                            shadowColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                color: selectedcolor1,
                                width: 7.0,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text('로그인',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  );
                }
              },
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
