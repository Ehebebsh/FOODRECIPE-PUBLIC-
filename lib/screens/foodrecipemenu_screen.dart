import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:foodrecipe/provider/bookmark_provider.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  final String title;
  final List<String> jsonFileNames;

  const FoodPage({Key? key, required this.title, required this.jsonFileNames}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {

  Future<List<dynamic>> _loadJsonData() async {
    List<dynamic> combinedFoodList = [];

    for (String fileName in widget.jsonFileNames) {
      String jsonData = await DefaultAssetBundle.of(context).loadString('assets/$fileName.json');
      combinedFoodList.addAll(json.decode(jsonData));
    }

    return combinedFoodList;
  }

  @override
  Widget build(BuildContext context) {
    var favoritesProvider = Provider.of<BookMarkProvider>(context);
    var favorites = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _loadJsonData(), // 수정된 부분: 여러 개의 JSON 파일을 로드하기 위한 future
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
                List<String> tags =
                    (food['tags'] as List<dynamic>).cast<String>();
                bool isFavorite = favorites.contains(food['name']);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: Image.network(
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
                            onTap: () {
                              String foodName = food['name'];
                              bool isAdding = !favorites.contains(foodName); // isAdding을 뒤집음
                              favoritesProvider.toggleFavorite(foodName);

                              // 즐겨찾기가 추가되거나 삭제될 때마다 적절한 Toast를 표시합니다.
                              if (isAdding) {
                                CherryToast.add(
                                  title: Text('$foodName 즐겨찾기가 추가됐습니다.'),
                                  animationType: AnimationType.fromTop,
                                ).show(context);
                              } else {
                                CherryToast.delete(
                                  title: Text('$foodName 즐겨찾기가 삭제됐습니다.'),
                                  animationType: AnimationType.fromTop,
                                ).show(context);
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
    );
  }
}
