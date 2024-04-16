import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:foodrecipe/screens/food_detail_screen.dart';
import 'package:foodrecipe/widgets/custom_pageroute_widget.dart';
import 'package:provider/provider.dart';
import '../api/loginchecker.dart';
import '../models/foodlist_model.dart';
import '../widgets/custom_bottom_navigation_action_widget.dart';
import 'login_screen.dart';


class AllFoodPage extends StatefulWidget {
  final String title;
  final List<String> jsonFileNames; // 수정된 부분: JSON 파일 이름들의 리스트

  const AllFoodPage({Key? key, required this.title, required this.jsonFileNames}) : super(key: key);

  @override
  State<AllFoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<AllFoodPage> {
  int _selectedIndex = 1;
  Future<List<dynamic>>? _foodListFuture;
  late final FoodListModel _foodListModel;

  @override
  void initState() {
    super.initState();
    _foodListModel = FoodListModel(jsonFileNames: widget.jsonFileNames);
    _foodListFuture = _foodListModel.loadJsonData(); // 데이터 로드를 initState에서 한 번만 수행
  }

  String addParticle(String word) {
    final lastChar = word.codeUnits.last;
    var hasJongSung = (lastChar - 44032) % 28 > 0;
    return hasJongSung ? '이' : '가';
  }

  @override
  Widget build(BuildContext context) {
    var favoritesProvider = Provider.of<BookMarkProvider>(context);
    var favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _foodListFuture, // 수정된 부분: 여러 개의 JSON 파일을 로드하기 위한 future
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> foodList = snapshot.data!;

            return ListView.builder(

              itemCount: foodList.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return const Divider();
                }

                var foodIndex = index ~/ 2;
                var food = foodList[foodIndex];
                List<String> tags = (food['tags'] as List<dynamic>).cast<String>();
                bool isFavorite = favorites.contains(food['name']);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CustomPageRoute(
                              builder: (context) => FoodDetailPage(foodData: food),
                            ),
                          );
                        },
                        child: Image.asset(
                          food['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              food['name'],
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              bool isGoogleLoggedIn = await LoginChecker().checkGoogleLoginStatus();
                              bool isKakaoLoggedIn = await LoginChecker().checkKakaoLoginStatus();

                              if (isGoogleLoggedIn || isKakaoLoggedIn) {
                                String foodName = food['name'];
                                bool isAdding = !favorites.contains(foodName); // isAdding을 뒤집음
                                favoritesProvider.toggleFavorite(foodName);

                                // 즐겨찾기가 추가되거나 삭제될 때마다 적절한 Toast를 표시합니다.
                                if (isAdding) {
                                  CherryToast.add(
                                    title: Text('$foodName${addParticle(foodName)} 즐겨찾기에 추가되었습니다.'),
                                    animationType: AnimationType.fromTop,
                                  ).show(context);
                                } else {
                                  CherryToast.delete(
                                    title: Text('$foodName${addParticle(foodName)} 즐겨찾기에서 삭제되었습니다.'),
                                    animationType: AnimationType.fromTop,
                                  ).show(context);
                                }
                              } else {
                                // 구글 또는 카카오 로그인이 되어 있지 않으면 로그인 유도 메시지 표시
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('로그인 필요'),
                                      content: const Text('즐겨찾기 기능을 사용하려면 로그인이 필요합니다.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              CustomPageRoute(builder: (context) =>  const LoginScreen()),
                                            );
                                          },
                                          child: const Text('로그인'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('닫기'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Icon(
                              isFavorite ? Icons.star : Icons.star_border_outlined,
                              color: Colors.yellow,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        tags.join(', '),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
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