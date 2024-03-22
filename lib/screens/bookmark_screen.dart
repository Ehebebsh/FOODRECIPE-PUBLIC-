import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:foodrecipe/widgets/custom_bottom_navigation_action_widget.dart';

import 'package:provider/provider.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({Key? key}) : super(key: key);

  @override
  BookMarkPagePageState createState() => BookMarkPagePageState();
}

class BookMarkPagePageState extends State<BookMarkPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    var favoritesProvider = Provider.of<BookMarkProvider>(context);
    var favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기 목록'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          DefaultAssetBundle.of(context)
              .loadString('assets/koreafood_data.json'),
          DefaultAssetBundle.of(context)
              .loadString('assets/chinesefood_data.json'),
          DefaultAssetBundle.of(context)
              .loadString('assets/westernfood_data.json'),
        ]),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> koreanFoodList = json.decode(snapshot.data![0]);
            List<dynamic> chineseFoodList = json.decode(snapshot.data![1]);
            List<dynamic> westernfoodList = json.decode(snapshot.data![2]);

            List<dynamic> combinedFoodList = [
              ...koreanFoodList,
              ...chineseFoodList,
              ...westernfoodList
            ];

            // 중복된 음식 이름 제거
            Set<String> uniqueNames = {};
            List<dynamic> favoriteFoods = combinedFoodList
                .where((food) => favorites.contains(food['name']))
                .where((food) => uniqueNames.add(food['name']))
                .toList();

            return ListView.builder(
              itemCount: favoriteFoods.length,
              itemBuilder: (context, index) {
                var foodData = favoriteFoods[index];
                return ListTile(
                  title: Text(foodData['name']),
                  subtitle: Text(foodData['tags'].join(', ')),
                  leading: Image.network(foodData['image']),
                  trailing: IconButton(
                    icon: const Icon(Icons.star, color: Colors.yellow),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(foodData['name']);
                      // 즐겨찾기 취소 안내 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${foodData['name']} 즐겨찾기가 취소되었습니다.'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: '취소',
                            onPressed: () {
                              favoritesProvider.toggleFavorite(foodData['name']);
                            },
                          ),
                        ),
                      );
                    },
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