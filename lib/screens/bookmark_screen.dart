import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:foodrecipe/widgets/custom_bottom_navigation_action_widget.dart';
import 'package:provider/provider.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  BookMarkPagePageState createState() => BookMarkPagePageState();
}

class BookMarkPagePageState extends State<BookMarkPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
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

            List<String> favorites =
                Provider.of<BookMarkProvider>(context).favorites;

            List<dynamic> favoriteFoods = combinedFoodList
                .where((food) => favorites.contains(food['name']))
                .toList();

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
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0), // 이미지 모서리를 둥글게 처리합니다.
                      child: Image.network(
                        foodData['image'],
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(
                      foodData['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(foodData['tags'].join(', ')),
                    onTap: () {
                      // 항목을 탭했을 때의 동작을 처리합니다.
                    },
                    // ListTile의 내부 여백을 조정합니다.
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
